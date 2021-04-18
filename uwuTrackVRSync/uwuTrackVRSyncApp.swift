//
//  uwuTrackVRSyncApp.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/16/21.
//

import SwiftUI

@main
struct uwuTrackVRSyncApp: App {
    @StateObject var clientService = TcpClientService()
    @StateObject var sensorService = MotionSensorService()
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environmentObject(clientService)
                .environmentObject(sensorService)
                .onAppear {
                    self.clientService.motionSensorService = sensorService
                    self.sensorService.tcpClientService = self.clientService
                }
        }
    }
}
