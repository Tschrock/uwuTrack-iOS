//
//  UDPClientService.swift
//  uwuTrackVRSync
//
//  Created by Tyler Schrock on 4/16/21.
//

import Foundation
import Network

class TcpClientService: ObservableObject {
    @Published var address: String = "192.168.10.100"
    @Published var port: String = "6969"
    @Published var isConnected = false
    private var lastStatus: String = "Service not started"
    private var packetId: Int64 = 0
    
    private var connection: NWConnection?
    
    weak var motionSensorService: MotionSensorService?
    
    func updateStatus(status: String) {
        print(status)
    }
    
    func connect(address: String, port: String) {
        if(self.connection != nil) {
            switch self.connection!.state {
            case .cancelled, .failed(_):
                self.disconnect()
                return
            default:
                self.updateStatus(status: "Service is already running!")
                return
            }
        }
        print(address)
        print(port)
        self.connection = NWConnection(host: NWEndpoint.Host(address), port: NWEndpoint.Port(port) ?? 6969, using: .udp)
        self.address = address
        self.port = port
        self.isConnected = true
        self.packetId = 0
        guard let connection = self.connection else {
            return
        }
        connection.stateUpdateHandler = { state in
            switch state {
            case .cancelled:
                self.updateStatus(status: "Connection closed.")
                self.disconnect()
                return
            case .failed(let error):
                self.updateStatus(status: "Connection error: " + error.localizedDescription)
                self.disconnect()
                return
            case .preparing:
                self.updateStatus(status: "Preparing connection...")
                return
            case .ready:
                self.updateStatus(status: "Ready!")
                self.sendHandshake()
                self.updateStatus(status: "Sent Handshake!")
                connection.receiveMessage(completion: self.recieveMessage)
                self.updateStatus(status: "Registered recieve")
                return
            case .setup:
                self.updateStatus(status: "Setting up connection...")
                return
            case .waiting(let error):
                self.updateStatus(status: "Waiting on network change: " + error.localizedDescription)
                return
            default:
                self.updateStatus(status: "unknown state")
                break
            }
        }
        connection.start(queue: .global(qos: .default))
    }
    
    func disconnect() {
        self.updateStatus(status: "disconnecting")
        self.motionSensorService?.stopUpdates()
        self.isConnected = false
        guard let connection = self.connection else {
            return
        }
        self.connection = nil
        connection.cancel()
    }
    
    private func recieveMessage(data: Data?, context: NWConnection.ContentContext?, isComplete: Bool, error:NWError?) {
        self.updateStatus(status: "Got data: " + (data?.base64EncodedString() ?? ""))
        self.updateStatus(status: "IsComplete:" + isComplete.description)
        if let data = data {
            if data[0] == 3 {
                print("got handshake")
                self.motionSensorService?.startUpdates()
            }
            else {
                data.withUnsafeBytes { rawData in
                    let msg_type = rawData.load(fromByteOffset: 0, as: Int32.self)
                    switch msg_type {
                    case 1: // Heartbeat
                        print("got heartbeat")
                        break
                    case 2: // Vibrate
                        print("got vibrate")
                        // let duration = rawData.load(fromByteOffset: 4, as: Float32.self)
                        // let frequency = rawData.load(fromByteOffset: 8, as: Float32.self)
                        // let amplitude = rawData.load(fromByteOffset: 12, as: Float32.self)
                        // TODO: Use Core Haptics to play vibrations
                        break
                    default:
                        print("got unknown")
                        break
                    }
                }
            }
        }
        if let error = error {
            self.updateStatus(status: error.localizedDescription)
            self.disconnect()
        }
        else if let connection = self.connection, connection.state == .ready {
            connection.receiveMessage(completion: self.recieveMessage)
        }
    }
    
    private func sendFloats(messageType: Int32, values: Array<Float>) {
        guard let connection = self.connection, connection.state == .ready else {
            return
        }
        let bytes = 12 + values.count * 4
        var data = Data(capacity: bytes)
        withUnsafeBytes(of: messageType.bigEndian) { data.append(contentsOf: $0) }
        withUnsafeBytes(of: self.packetId.bigEndian) { data.append(contentsOf: $0) }
        for value in values {
            withUnsafeBytes(of: value.bitPattern.bigEndian) { data.append(contentsOf: $0) }
        }
        self.updateStatus(status: "Sending data: " + data.base64EncodedString())
        connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed({ _ in }))
        self.packetId += 1
    }
    
    func sendRot(values: Array<Float>) {
        self.sendFloats(messageType: 1, values: values)
    }
    
    func sendGyro(values: Array<Float>) {
        self.sendFloats(messageType: 2, values: values)
    }
    
    func sendHandshake() {
        self.sendFloats(messageType: 3, values: [])
    }
    
    func sendAccel(values: Array<Float>) {
        self.sendFloats(messageType: 4, values: values)
    }
}
