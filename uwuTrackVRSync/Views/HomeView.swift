//
//  HomeView.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/16/21.
//

import SwiftUI
import CoreMotion

struct HomeView: View {
    @EnvironmentObject private var motionService: MotionSensorService
    
    var body: some View {
        VStack {
            Text("uwu")
                .font(.title3)
                .padding(.bottom)
            Text("Warning: This app is a work-in-progress and probably has a ton of bugs. Caveat Emptor")
                .font(.callout)
                .padding(.bottom)
            Group {
                Text("Device Motion")
                    .padding(.vertical, 4.0)
                if self.motionService.motionManager.isDeviceMotionAvailable {
                    Image(systemName: "checkmark").foregroundColor(.green).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                else {
                    Image(systemName: "xmark").foregroundColor(.red).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
            }
            Group {
                Text("Gyroscope")
                    .padding(.vertical, 4.0)
                if self.motionService.motionManager.isGyroAvailable {
                    Image(systemName: "checkmark").foregroundColor(.green).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                else {
                    Image(systemName: "xmark").foregroundColor(.red).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
            }
            Group {
                Text("Magnetometer")
                    .padding(.vertical, 4.0)
                if self.motionService.motionManager.isMagnetometerAvailable {
                    Image(systemName: "checkmark").foregroundColor(.green).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                else {
                    Image(systemName: "xmark").foregroundColor(.red).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
            }
            Group {
                Text("Accelerometer")
                    .padding(.vertical, 4.0)
                if self.motionService.motionManager.isAccelerometerAvailable {
                    Image(systemName: "checkmark").foregroundColor(.green).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                else {
                    Image(systemName: "xmark").foregroundColor(.red).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
            }
            Spacer()
        }
        .padding(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.light)
            .environmentObject(MotionSensorService())
        HomeView()
            .preferredColorScheme(.dark)
            .environmentObject(MotionSensorService())
    }
}
