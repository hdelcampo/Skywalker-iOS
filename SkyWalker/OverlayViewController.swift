//
//  OverlayViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 27/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit
import CoreBluetooth

class OverlayViewController: UIViewController, CBPeripheralManagerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBOutlet weak var debugView: UIView!
    
    let orientationSensor = OrientationSensor()
    
    //MARK: Indicator properties
    let margin = 0.9
    
    //MARK: Icon properties
    let outOfSightIconPath = "out_of_sight_icon.png"
    let outOfSightIconAngleOffset: Double = 90
    let inSightIconPath = "in_sight_icon.png"
    let iconSize = 60.0

    //MARK: Text properties
    let textSize = CGFloat(24)
    let textColor = UIColor.white.cgColor
    let strokeColor = UIColor.black.cgColor
    let strokeSize = 2
    let textSeparator = "\n"
    
    var points : [PointOfInterest] = [] {
        
        didSet {
            for index in 0..<points.count {
                let attrText = NSAttributedString(string: points[index].name,
                                                  attributes:
                    [NSForegroundColorAttributeName: textColor,
                     NSStrokeColorAttributeName: strokeColor,
                     NSStrokeWidthAttributeName: -strokeSize,
                     NSFontAttributeName: UIFont.systemFont(ofSize: textSize)])
                
                let size = attrText.size()
                
                (outOfSighttLayers[index]?.sublayers?[1] as? CATextLayer)?.string = attrText
                (outOfSighttLayers[index]?.sublayers?[1] as? CATextLayer)?.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            }
        }
        
    }
    var initialLayers : [CALayer] = []
    var mySelf: PointOfInterest!
    
    var bleManager: CBPeripheralManager!
    
    /**
        Maximum number of points to draw
    */
    static let maxPoints = 5
    
    /**
        Thread that handles drawing.
    */
    var painterThread: DispatchSourceTimer?
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLayers = self.view.layer.sublayers!
        
        points = Array(User.instance.center!.points!.prefix(OverlayViewController.maxPoints))
        mySelf = PointOfInterest.mySelf
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!User.instance.isDemo) {
            bleManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: false])
        } else {
            startDrawingThread()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (User.instance.transmitter.isTransmitting) {
            User.instance.transmitter.stopTransmission()
        }
        stopThreads()
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOff {
            User.instance.transmitter.stopTransmission()
            stopThreads()
            let alert = UIAlertController(title: NSLocalizedString("bluetooth_off_title", comment: ""),
                              message: NSLocalizedString("bluetooth_off_msg", comment: ""),
                              preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("settings", comment: ""),
                                           style: .default,
                                           handler: { _ in
                                            let url = URL(string: "App-Prefs:root=Bluetooth")
                                            UIApplication.shared.openURL(url!)
            }))
            self.present(alert, animated: true, completion: nil)
        } else if (peripheral.state == .poweredOn) {
            User.instance.transmitter.startTransmission()
            startThreads()
        }
    }
    
    private var connectionThread: DispatchSourceTimer?
    
    private let updateRate = 0.25
    
    /**
        Starts all threads.
    */
    private func startThreads() {
        
        connectionThread = DispatchSource.makeTimerSource(queue: connectionQueue)
        connectionThread!.scheduleRepeating(deadline: .now(), interval: updateRate)
        connectionThread!.setEventHandler { _ in
            self.updatePoints()
        }
        
        if #available(iOS 10.0, *) {
            connectionThread!.activate()
        } else {
            connectionThread!.resume()
        }
        
        mySelf.x = 0.5
        mySelf.y = 0.5
        mySelf.z = 0
        
        startDrawingThread()
    }
    
    /**
        Starts the drawing thread and layers
    */
    private func startDrawingThread() {
        
        orientationSensor.registerEvents()
        
        initLayers()
        painterThread = DispatchSource.makeTimerSource(queue: queue)
        painterThread!.scheduleRepeating(deadline: .now(), interval: OrientationSensor.updateRate)
        painterThread!.setEventHandler { _ in
            self.redraw()
        }
        
        if #available(iOS 10.0, *) {
            painterThread!.activate()
        } else {
            painterThread!.resume()
        }
        
    }
    
    /**
        Destroys all threads.
    */
    private func stopThreads() {
        
        orientationSensor.registerEvents()
        
        connectionThread?.cancel()
        connectionThread = nil
        
        painterThread?.cancel()
        painterThread = nil
    }
    
    private func onInternetError() {
        DispatchQueue.main.sync {
            let alert = UIAlertController(title: NSLocalizedString("internet_off_title", comment: ""),
                                      message: NSLocalizedString("internet_off_msg", comment: ""),
                                      preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                           style: .default,
                                           handler: { _ in
                                            self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Drawing
    
    /**
     In sight layers pool
     */
    var inSightLayers = [CALayer?](repeating: nil, count: OverlayViewController.maxPoints)
    
    /**
     Out of sight layers pool
     */
    var outOfSighttLayers = [CALayer?](repeating: nil, count: OverlayViewController.maxPoints)
    
    /**
     GDC Queue for painting.
     */
    let queue = DispatchQueue(label: "Painter", qos: DispatchQoS.userInitiated)
    
    /**
     Checks if a given point is in sight of camera's image.
     */
    private func inSight(vectorToPoint: Vector2D, orientationVector: Vector3D) -> Bool {
        
        let fovWidth = Camera.instance.horizontalFOV,
        fovHeight = Camera.instance.verticalFOV
        
        // Horizontal
        var orientationOnMap = Vector2D(x: orientationVector.x, y: orientationVector.y)
        orientationOnMap.normalize()
        
        let horizontalTheta = orientationOnMap.angle(v: vectorToPoint)
        
        //Vertical
        let verticalTheta = abs(-90*orientationVector.z)
        
        return (horizontalTheta <= Double(fovWidth/2) &&
            verticalTheta <= Double(fovHeight/2))
        
    }
    
    /**
     Draws an indicator for the given point indicating heading direction
     */
    private func drawIndicator(index: Int, vectorToPoint: Vector2D, orientationVector: Vector3D) {
        
        
        // Horizontal
        let orientationOnMap = Vector2D(x: orientationVector.x, y: orientationVector.y)
        var x = orientationOnMap.angleWithSign(v: vectorToPoint)/180
        
        //Vertical
        var y = orientationVector.z
        
        let angle = Vector3D.getAngle(x: x, y: y)
        
        /*
         * So once we get angle, we must remap it to coordinates. There are 2 kinds:
         *  -Left screen and down screen, they go in reverse coordinates system
         *  -Up and right screen are "normal" cases. However, right screen is special due to [0,360) angles
         *
         * Once we get corrected angle, we start coordinates from size*margin, and we multiply current angle to
         * size of the "rect", size of rect is size of height or weight subtracting twice the margin.
         */
        var correctedAngle = 0.0
        
        let height = Double(view.bounds.height)
        let width = Double(view.bounds.width)
        
        var textX = iconSize/6
        var textY = iconSize/4
        
        if (0 <= angle && angle <= 45 ||
            315 <= angle && angle <= 360) {
            x = width*margin
            correctedAngle = 0.0
            
            // As angle can be > 315, correct it
            if (315 <= angle && angle <= 360) {
                correctedAngle = abs(360-angle-45)
            } else {
                correctedAngle = angle + 45
            }
            
            y = height*(1 - margin) + ((correctedAngle/(45*2))) * height*(1 - (1 - margin) * 2)   //Decimal part from div by 45 angles
            textX *= -2
            textY *= -1.75
            
        } else if (45 < angle && angle <= 135) {
            correctedAngle =  135 - angle;
            x = width*(1 - margin) + (correctedAngle/(45*2)) * width*(1 - (1 - margin) * 2);
            y = height*margin;
            textY *= -2
        } else if (135 < angle && angle <= 225) {
            correctedAngle = 225 - angle;
            x = width*(1-margin);
            y = height*(1 - margin) + (correctedAngle/(45*2)) * height*(1 - (1 - margin) * 2);
            textX *= 2
        } else {
            correctedAngle = angle - 225;
            x = width*(1 - margin) + (correctedAngle/(45*2)) * width*(1 - (1 - margin) * 2);
            y = height*(1-margin);
            textY *= 2
        }
        
        transformOutOfSightLayer(outOfSighttLayers[index]!,
                                 x: x,
                                 y: y,
                                 textX: textX,
                                 textY: textY,
                                 angle: angle + outOfSightIconAngleOffset)
        
    }
    
    /**
        Draws a given point at actual image's position
    */
    private func draw(index: Int, point: PointOfInterest, vectorToPoint: Vector2D, orientationVector: Vector3D) {
        let fovWidth = Camera.instance.horizontalFOV,
            fovHeight = Camera.instance.verticalFOV
        
        // Horizontal
        let orientationOnMap = Vector2D(x: orientationVector.x, y: orientationVector.y)
        let horizontalTheta = orientationOnMap.angleWithSign(v: vectorToPoint)
        
        //Vertical
        let verticalTheta = -90*orientationVector.z
        
        let x = Double(view.bounds.width/2) + horizontalTheta*Double(Float(view.bounds.width)/fovWidth),
            y = Double(view.bounds.height/2) - verticalTheta*Double(Float(view.bounds.height)/fovHeight)
        
        let floorDelta = point.z - mySelf.z
        let floorLabel: String
        
        if (floorDelta == 0) {
            floorLabel = ""
        } else if (floorDelta > 0) {
            floorLabel = " +\(floorDelta)f \u{25B2}"
        } else {
            floorLabel = " \(floorDelta)f \u{25BC}"
        }
        
        let distanceVector = Vector2D(x: point.x - self.mySelf.x,
                                     y: point.y - self.mySelf.y)
        
        transformInSightLayer(inSightLayers[index]!,
                              text: [point.name, "\(String(format: "%.2f", distanceVector.module() * User.instance.center!.scale))m" + floorLabel],
                              x: x,
                              y: y)
        
    }
    
    /**
        Creates a layer with text on the given layer.
        - Parameters:
            - text: The text to spawn.
            - to: Target layer.
     */
    private func spawnLayer(text: [String], to: CALayer) {
        
        let textLayer = CATextLayer()
        let text = text.joined(separator: textSeparator)

        let attrText = NSAttributedString(string: text,
                                      attributes:
            [NSForegroundColorAttributeName: textColor,
             NSStrokeColorAttributeName: strokeColor,
             NSStrokeWidthAttributeName: -strokeSize,
             NSFontAttributeName: UIFont.systemFont(ofSize: textSize)])
        
        textLayer.string = attrText
        textLayer.contentsScale = UIScreen.main.scale
        let size = attrText.size()
        textLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        textLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        to.addSublayer(textLayer)
        
    }
    
    /**
        Creates a layer with an icon on the given layer
        - Parameters:
            - icon: The icon to spawn.
            - to: Target layer.
     */
    private func spawnLayer(icon: String, to: CALayer) {
        
        let iconLayer = CALayer()
        iconLayer.contents = UIImage(named: icon)?.cgImage
        iconLayer.bounds = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)

        to.addSublayer(iconLayer)
        
    }
    
    /**
        The main painter loop, this will handle the queues and all painting logic.
    */
    private func redraw () {
        
        let orientationVector = orientationSensor.orientationVector
        
        DispatchQueue.main.async {
            self.xLabel.text = String(format: "X %.6f", orientationVector.x)
            self.yLabel.text = String(format: "Y %.6f", orientationVector.y)
            self.zLabel.text = String(format: "Z %.6f", orientationVector.z)
        }
        
        
            for index in 0..<OverlayViewController.maxPoints {
                
                if (index >= points.count) {
                    DispatchQueue.main.async {
                        self.outOfSighttLayers[index]?.isHidden = true
                        self.inSightLayers[index]?.isHidden = true
                    }
                    
                    continue
                }
                
                let point = points[index]
                
                var vectorToPoint = Vector2D(x: point.x - self.mySelf.x,
                                             y: point.y - self.mySelf.y)
                
                if ( point.isUndefined ||
                    (vectorToPoint.x == 0 && vectorToPoint.y == 0)) {
                    DispatchQueue.main.async {
                        self.outOfSighttLayers[index]?.isHidden = true
                        self.inSightLayers[index]?.isHidden = true
                    }
                    continue
                }
                
                vectorToPoint.normalize()
                
                if self.inSight(vectorToPoint: vectorToPoint, orientationVector: orientationVector) {
                    DispatchQueue.main.async {
                        self.outOfSighttLayers[index]?.isHidden = true
                        self.inSightLayers[index]?.isHidden = false
                    }
                    self.draw(index: index, point: point, vectorToPoint: vectorToPoint, orientationVector: orientationVector)
                } else {
                    DispatchQueue.main.async {
                        self.inSightLayers[index]?.isHidden = true
                        self.outOfSighttLayers[index]?.isHidden = false
                    }
                    self.drawIndicator(index: index, vectorToPoint: vectorToPoint, orientationVector: orientationVector)
                }
            }
        
    }
    
    /**
     Transforms an already existing layer to the given position and angle.
     - Parameters:
     - layer: Target layer.
     - x: X position.
     - y: Y position.
     - textX: text X offset.
     - textY: text Y offset.
     - angle: icon angle.
     */
    func transformOutOfSightLayer (_ layer: CALayer, x: Double, y: Double, textX: Double, textY: Double, angle: Double) {
        
        DispatchQueue.main.async {
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            layer.sublayers![0].transform = CATransform3DMakeRotation(CGFloat(angle.toRadians), 0, 0, 1)
            layer.sublayers![1].position = CGPoint(x: textX, y: textY)
            layer.position = CGPoint(x: x, y: y)
            
            CATransaction.commit()
        }
    }
    
    /**
     Transforms an already existing layer to the given position and test.
     - Parameters:
     - layer: Target layer.
     - text: To draw.
     - x: X position.
     - y: Y position.
     */
    func transformInSightLayer (_ layer: CALayer, text: [String], x: Double, y: Double) {
        
        let textSplitted = text.joined(separator: textSeparator)
        
        let attrText = NSAttributedString(string: textSplitted,
                                          attributes:
            [NSForegroundColorAttributeName: textColor,
             NSStrokeColorAttributeName: strokeColor,
             NSStrokeWidthAttributeName: -strokeSize,
             NSFontAttributeName: UIFont.systemFont(ofSize: textSize)])
        
        let size = attrText.size()
        
        DispatchQueue.main.async {
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            (layer.sublayers![1] as! CATextLayer).string = attrText
            layer.sublayers![1].bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layer.sublayers![1].position = CGPoint(x: self.iconSize/3, y: self.iconSize/4)
            layer.position = CGPoint(x: x, y: y)
            
            CATransaction.commit()
        }
        
    }
    
    /**
     Inits the layer objects pool
     */
    func initLayers () {
        
        // Remove all but debug info
        self.view.layer.sublayers?.forEach( { if !(self.initialLayers.contains($0)) { $0.removeFromSuperlayer() } })
        
        for (index, point) in points.enumerated() {
            initOutOfSightLayer(index: index, point: point)
            initInSightLayer(index: index, point: point)
        }
    }
    
    /**
     Starts an out of sight layer.
     - Parameters:
     - index: The layer index.
     - point: To represent.
     */
    private func initOutOfSightLayer (index: Int, point: PointOfInterest) {
        let layer = CALayer()
        spawnLayer(icon: outOfSightIconPath, to: layer)
        spawnLayer(text: [point.name], to: layer)
        outOfSighttLayers[index] = layer
        view.layer.addSublayer(layer)
    }
    
    /**
     Starts an in sight layer.
     - Parameters:
     - index: The layer index.
     - point: To represent.
     */
    private func initInSightLayer (index: Int, point: PointOfInterest) {
        let layer = CALayer()
        spawnLayer(icon: inSightIconPath, to: layer)
        spawnLayer(text: [point.name], to: layer)
        inSightLayers[index] = layer
        view.layer.addSublayer(layer)
    }

    let connectionQueue = DispatchQueue(label: "Connection", qos: DispatchQoS.userInitiated)
    
    let maxErrorsPorc: Float = 0.6
    let maxLoopsWithoutCheck: Float = 4
    
    func updatePoints() {
        
        var numLoopsWithoutCheck: Float = 0
        var numPetitionsWithoutCheck: Float = 4
        var numErrors = AtomicInteger()
        
        let onError: (PersistenceErrors) -> Void = { _ in
            numErrors.increment()
        }
        
            if (maxLoopsWithoutCheck == numLoopsWithoutCheck) {
                if ( Float(numErrors.get()) >= numPetitionsWithoutCheck * maxErrorsPorc) {
                    onInternetError()
                    return;
                } else {
                    numErrors.set(0)
                    numPetitionsWithoutCheck = 0
                    numLoopsWithoutCheck = 0
                }
            }
            
            mySelf.updatePosition(successDelegate: nil, errorDelegate: onError)
            
            numPetitionsWithoutCheck += 1
            
            for point in points {
                point.updatePosition(successDelegate: nil, errorDelegate: onError)
                numPetitionsWithoutCheck += 1
            }
            
            numLoopsWithoutCheck += 1
    }
    
    
}
