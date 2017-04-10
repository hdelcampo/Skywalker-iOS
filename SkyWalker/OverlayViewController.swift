//
//  OverlayViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 27/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var rollLabel: UITextField!
    @IBOutlet weak var pitchLabel: UITextField!
    @IBOutlet weak var azimuthLabel: UITextField!
    
    let orientationSensor = OrientationSensor()
    
    //MARK: Indicator properties
    let margin = 0.9
    
    //MARK: Icon properties
    let outOfSightIconPath = "arrow_right.png"
    let inSightIconPath = "arrow_down.png"
    let iconSize = 35

    //MARK: Text properties
    let textSize = 12
    let textColor = UIColor.white.cgColor
    let textSeparator = "\n"
    
    var points : [PointOfInterest] = []
    var initialLayers : [CALayer] = []
    var mySelf: Vector2D = Vector2D(x: 0.5, y: 0.5)
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLayers = self.view.layer.sublayers!
        points = PointOfInterest.points!
        PointOfInterest.observer = self
        orientationSensor.registerEvents()
        Timer.scheduledTimer(timeInterval: OrientationSensor.updateRate, target: self, selector: #selector(redraw(_:)), userInfo: nil, repeats: true)
        
    }
    
    @objc func redraw (_: Any) {
        
        // Remove all but debug info
        self.view.layer.sublayers?.forEach( { if !(self.initialLayers.contains($0)) { $0.removeFromSuperlayer() } })
        
        let orientationVector = orientationSensor.orientationVector
        
        azimuthLabel.text = String(format: "X %.6f", orientationVector.x)
        pitchLabel.text = String(format: "Y %.6f", orientationVector.y)
        rollLabel.text = String(format: "Z %.6f", orientationVector.z)
        
        for point in self.points {
            
            var vectorToPoint = Vector2D(x: point.x - mySelf.x,
                                         y: point.y - mySelf.y)
            vectorToPoint.normalize()
            
            if inSight(vectorToPoint: vectorToPoint, orientationVector: orientationVector) {
                draw(point: point, vectorToPoint: vectorToPoint, orientationVector: orientationVector)
            } else {
                drawIndicator(point: point, vectorToPoint: vectorToPoint, orientationVector: orientationVector)
            }
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ("filterSegue" == segue.identifier) {
            let svc = segue.destination as! FilterViewController
            svc.allPoints = PointOfInterest.points!
            svc.usedPoints = self.points
            svc.caller = self
        }
        
    }
    
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
    private func drawIndicator(point: PointOfInterest, vectorToPoint: Vector2D, orientationVector: Vector3D) {
        
        
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
            
        } else if (45 < angle && angle <= 135) {
            correctedAngle =  135 - angle;
            x = width*(1 - margin) + (correctedAngle/(45*2)) * width*(1 - (1 - margin) * 2);
            y = height*margin;
        } else if (135 < angle && angle <= 225) {
            correctedAngle = 225 - angle;
            x = width*(1-margin);
            y = height*(1 - margin) + (correctedAngle/(45*2)) * height*(1 - (1 - margin) * 2);
        } else {
            correctedAngle = angle - 225;
            x = width*(1 - margin) + (correctedAngle/(45*2)) * width*(1 - (1 - margin) * 2);
            y = height*(1-margin);
        }
        
        draw(text: [point.name], to: view, x: x, y: y)
        draw(icon: outOfSightIconPath, to: view, x: x, y: y, angle: angle)
    }
    
    /**
        Draws a given point at actual image's position
    */
    private func draw(point: PointOfInterest, vectorToPoint: Vector2D, orientationVector: Vector3D) {
        let fovWidth = Camera.instance.horizontalFOV,
            fovHeight = Camera.instance.verticalFOV
        
        // Horizontal
        let orientationOnMap = Vector2D(x: orientationVector.x, y: orientationVector.y)
        let horizontalTheta = orientationOnMap.angleWithSign(v: vectorToPoint)
        
        //Vertical
        let verticalTheta = -90*orientationVector.z
        
        let x = Double(view.bounds.width/2) + horizontalTheta*Double(Float(view.bounds.width)/fovWidth),
            y = Double(view.bounds.height/2) - verticalTheta*Double(Float(view.bounds.height)/fovHeight)
        
        draw(text: [point.name, String(point.distance)], to: view, x: x + Double(iconSize)*2, y: y + Double(iconSize))
        draw(icon: inSightIconPath, to: view, x: x , y: y, angle: 0);
        
    }
    
    /**
     * Draws to given view, at given position, formating text with new line separators
     */
    private func draw(text: [String], to: UIView, x: Double, y: Double) -> Void {
        
        let textLayer = CATextLayer()
        let text = text.joined(separator: textSeparator)
        
        textLayer.string = text
        textLayer.fontSize = CGFloat(textSize)
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.foregroundColor = textColor
        textLayer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        textLayer.position = CGPoint(x: x, y: y)
        
        to.layer.addSublayer(textLayer)
        
    }
    
    /**
     * Draws to given view, at given position, a image specified by path, with given rotation in degrees
     */
    private func draw(icon: String, to: UIView, x: Double, y: Double, angle: Double) -> Void {
        
        let iconLayer = CALayer()
        iconLayer.contents = UIImage(named: icon)?.cgImage
        iconLayer.transform = CATransform3DMakeRotation(CGFloat(angle.toRadians), 0, 0, 1)
        iconLayer.bounds = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        iconLayer.position = CGPoint(x: x, y: y)

        
        to.layer.addSublayer(iconLayer)
        
    }

}
