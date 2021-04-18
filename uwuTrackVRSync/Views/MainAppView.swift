//
//  ContentView.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/16/21.
//

import SwiftUI

struct MainAppView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.yellow
        UITabBar.appearance().isTranslucent = true
    }
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            ConnectView()
                .tabItem {
                    Label("Connect", systemImage: "laptopcomputer")
                }
            OutputLogView()
                .tabItem {
                    Label("Output Log", systemImage: "questionmark.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainAppView()
                .preferredColorScheme(.light)
            MainAppView()
                .preferredColorScheme(.dark)
        }
    }
}
