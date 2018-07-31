//
//  ViewController.swift
//  AngleDetector
//
//  Created by Vicki Larkin on 31/07/2018.
//  Copyright © 2018 Vicki Hardy. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    
    @IBOutlet weak var upArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    
    let motionManger = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        upArrow.isHidden = true
        downArrow.isHidden = true
        detectMotion()
    }
    
    // Set up motion detector
    func detectMotion() {
        
        if motionManger.isDeviceMotionAvailable {
            // do something
            motionManger.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    
                    if(error == nil) {
                        self.motionManger.deviceMotionUpdateInterval = 0.1
                        self.displayArrows(deviceAngle: self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)) 
                    } else {
                        //handle the error
                    }
            })
        }
    }
    
    // Convert radians to degrees
    func radiansToDegrees(_ radians: Double) -> Double {
        return radians * (180.0 / Double.pi)
    }
    
    // Print out the degrees of the device tilt
    func handleDeviceMotionUpdate(deviceMotion: CMDeviceMotion) -> CGFloat {
        let attitude = deviceMotion.attitude
        let quat = attitude.quaternion
        let qPitch = CGFloat(radiansToDegrees(atan2(2 * (quat.x * quat.w + quat.y * quat.z), 1 - 2 * quat.x * quat.x - 2 * quat.z * quat.z)))
        let numOfDegrees = String(format: "%.0f", qPitch)
        print("Degrees: \(numOfDegrees)")
        return qPitch
    }
    
    // show arrows
    func displayArrows(deviceAngle: CGFloat) {
        if deviceAngle > 105 {
            downArrow.isHidden = false
            upArrow.isHidden = true
        } else if  deviceAngle < 80 {
            upArrow.isHidden = false
            downArrow.isHidden = true
        } else {
            downArrow.isHidden = true
            upArrow.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

