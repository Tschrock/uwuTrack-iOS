//
//  ConnectView.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/16/21.
//

import SwiftUI

struct ConnectView: View {
    @State var remoteIp: String = "";
    @State var remotePort: String = "";
    
    var body: some View {
        List {
            Section(header: Text("Enter the IP and port, then tap connect.")) {
                TextField("IP", text: $remoteIp)
                    .keyboardType(/*@START_MENU_TOKEN@*/.numbersAndPunctuation/*@END_MENU_TOKEN@*/)
                TextField("Port", text: $remotePort)
                    .keyboardType(/*@START_MENU_TOKEN@*/.numberPad/*@END_MENU_TOKEN@*/)
            }
            .padding(.top)
            Button(action: {
                print("connect")
            }) {
                HStack {
                    Spacer()
                    Text("Connect")
                    Spacer()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
    }
}
