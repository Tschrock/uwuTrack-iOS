//
//  MotionSensorService.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/17/21.
//

import Foundation
import CoreMotion

class MotionSensorService: ObservableObject {
    let motionManager = CMMotionManager()
    
    weak var tcpClientService: TcpClientService?
    
    func startUpdates() {
        if(self.motionManager.isDeviceMotionAvailable) {
            print("device motion available")
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 20.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main) { data, error in
                if let data = data {
                    self.tcpClientService?.sendGyro(values: [Float(data.rotationRate.x), Float(data.rotationRate.y), Float(data.rotationRate.z)])
                    self.tcpClientService?.sendRot(values: [Float(data.attitude.quaternion.x), Float(data.attitude.quaternion.y), Float(data.attitude.quaternion.z), Float(data.attitude.quaternion.w)])
                    //self.tcpClientService?.sendAccel(values: [Float(data.userAcceleration.x), Float(data.userAcceleration.y), Float(data.userAcceleration.z)])
                }
            }
        }
        else {
            print("device motion not")
            // TODO: Log error
        }
        // if(self.motionManager.isGyroAvailable && !self.motionManager.isGyroActive) {
        //     self.motionManager.startGyroUpdates(to: .main) { data, error in
        //         if let data = data {
        //             self.udpClientService?.sendGyro(values: [Float(data.rotationRate.x), Float(data.rotationRate.y), Float(data.rotationRate.z)])
        //         }
        //     }
        // }
        // if(self.motionManager.isMagnetometerAvailable && !self.motionManager.isMagnetometerActive) {
        //     self.motionManager.startMagnetometerUpdates(to: .main) { data, error in
        //         if let data = data {
        //             self.udpClientService?.sendRot(values: [Float(data.magneticField.x), Float(data.rotationRate.y), Float(data.magneticField.z)])
        //         }
        //     }
        // }
        // if(self.motionManager.isAccelerometerAvailable && !self.motionManager.isAccelerometerActive) {
        //     self.motionManager.startAccelerometerUpdates(to: .main) { data, error in
        //         if let data = data {
        //             self.udpClientService?.sendGyro(values: [Float(data.acceleration.x), Float(data.acceleration.y), Float(data.acceleration.z)])
        //         }
        //     }
        // }
    }
    func stopUpdates() {
        self.motionManager.stopDeviceMotionUpdates()
        // self.motionManager.stopGyroUpdates()
        // self.motionManager.stopMagnetometerUpdates()
        // self.motionManager.stopAccelerometerUpdates()
    }
}
