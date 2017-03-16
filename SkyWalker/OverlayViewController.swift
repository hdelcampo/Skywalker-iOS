//
//  OverlayViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 27/9/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var rollLabel: UITextField!
    @IBOutlet weak var pitchLabel: UITextField!
    @IBOutlet weak var azimuthLabel: UITextField!
    @IBOutlet weak var buildLabel: UILabel!
    
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
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setBuildStamp()
        initialLayers = self.view.layer.sublayers!
        points = PointOfInterest.points!
        PointOfInterest.observer = self
        orientationSensor.registerEvents()
        Timer.scheduledTimer(timeInterval: OrientationSensor.updateRate, target: self, selector: #selector(redraw(_:)), userInfo: nil, repeats: true)
        
    }
    
    @objc func redraw (_: Any) {
        
        // Remove all but debug info
        self.view.layer.sublayers?.forEach( { if !(self.initialLayers.contains($0)) { $0.removeFromSuperlayer() } })
        
        
        self.azimuthLabel.text = String(format: "Azimuth %.6f", self.orientationSensor.azimuth)
        self.pitchLabel.text = String(format: "Pitch %.6f", self.orientationSensor.pitch)
        self.rollLabel.text = String(format: "Roll %.6f", self.orientationSensor.roll)
        for point in self.points {
            if self.inSight(point: point) {
                self.draw(point: point)
            } else {
                self.drawIndicator(for: point)
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
        Sets the build stamp to the UI
    */
    private func setBuildStamp () {
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as! String
        buildLabel.text = "(Build: \(build))"
    }
    
    /**
        Draws an indicator for the given point indicating heading direction
    */
    private func drawIndicator(for point: PointOfInterest) {
        
        var x = (orientationSensor.azimuth - Double(point.x)) / 180,
            y = (orientationSensor.pitch - Double(point.z)) / 90;
        
        let angle = Vector3D.getAngle(x: x, y: -y)
        
        let height = Double(view.bounds.height)
        let width = Double(view.bounds.width)
        
        /**
         * So once we get angle, we must remap it to coordinates. There are 2 kinds:
         *  -Left screen and down screen, they go in reverse coordinates system
         *  -Up and right screen are "normal" cases. However, right screen is special due to [0,360) angles
         *
         * Once we get corrected angle, we start coordinates from size*margin, and we multiply current angle to
         * size of the "rect", size of rect is size of height or weight subtracting twice the margin.
         */
        var correctedAngle = 0.0
        
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
        Checks if a given point is in sight of camera's image.
    */
    private func inSight(point: PointOfInterest) -> Bool {
        let fovWidth = Camera.instance.horizontalFOV,
            fovHeight = Camera.instance.verticalFOV
        return (abs(orientationSensor.azimuth - Double(point.x)) <= Double(fovWidth/2) &&
            abs(orientationSensor.pitch - Double(point.z)) <= Double(fovHeight/2));
    }
    
    /**
        Draws a given point at actual image's position
    */
    private func draw(point: PointOfInterest) {
        let fovWidth = Camera.instance.horizontalFOV,
            fovHeight = Camera.instance.verticalFOV
        
        let x = Double(view.frame.width)/2 - (-orientationSensor.azimuth + Double(point.x))*Double(view.frame.width)/Double(fovWidth),
            y = Double(view.frame.height)/2 - (orientationSensor.pitch - Double(point.z))*Double(view.frame.height)/Double(fovHeight)
        
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
