//
//  ConnectView.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/16/21.
//

import SwiftUI
import Network

struct ConnectView: View {
    @EnvironmentObject private var tcpClientService: TcpClientService
    @State var remoteIp: String = "";
    @State var remotePort: String = "";
    
    var body: some View {
        Form {
            Section(header: Text("Enter the IP and port, then tap connect.")) {
                TextField("IP", text: $remoteIp)
                    .keyboardType(/*@START_MENU_TOKEN@*/.numbersAndPunctuation/*@END_MENU_TOKEN@*/)
                TextField("Port", text: $remotePort)
                    .keyboardType(/*@START_MENU_TOKEN@*/.numberPad/*@END_MENU_TOKEN@*/)
            }
            .padding(.top)
            Button(action: {
                if self.tcpClientService.isConnected {
                    self.tcpClientService.disconnect()
                }
                else {
                    self.tcpClientService.connect(address: self.remoteIp, port: self.remotePort)
                }
            }) {
                HStack {
                    Spacer()
                    if self.tcpClientService.isConnected {
                        Text("Disconnect")
                    }
                    else {
                        Text("Connect")
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            self.remoteIp = self.tcpClientService.address
            self.remotePort = self.tcpClientService.port
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
            .preferredColorScheme(.light)
        ConnectView()
            .preferredColorScheme(.dark)
    }
}
