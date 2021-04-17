//
//  ContentView.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/16/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("uwuTrackVR").font(.headline).foregroundColor(Color.white)
                }
            }.navigationBarColor(backgroundColor: UIColor(named: "AccentColor"), titleColor: .white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
