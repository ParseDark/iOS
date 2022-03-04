import Foundation
import CommonKit
import ClashKit

extension PacketTunnelProvider: ClashPacketFlowProtocol, ClashTrafficReceiverProtocol, ClashNativeLoggerProtocol {
    
    func setupClash() throws {
        let config = """
        mixed-port: 8080
        mode: \(UserDefaults.shared.string(forKey: Constant.tunnelMode) ?? ClashTunnelMode.rule.rawValue)
        log-level: info
        """
        var error: NSError? = nil
        ClashSetup(self, Constant.homeDirectoryURL.path, config, &error)
        if let error = error {
            throw error
        }
        ClashSetNativeLogger(self)
        ClashSetTrafficReceiver(self)
    }
    
    func setCurrentConfig() throws {
        var error: NSError? = nil
        ClashApplyConfig(UserDefaults.shared.string(forKey: Constant.currentConfigUUID), &error)
        guard let error = error else {
            return
        }
        throw error
    }
    
    func writePacket(_ packet: Data?) {
        guard let packet = packet else {
            return
        }
        self.packetFlow.writePackets([packet], withProtocols: [AF_INET as NSNumber])
    }
    
    func receiveTraffic(_ up: Int64, down: Int64) {
        UserDefaults.shared.set(Double(up), forKey: ClashTraffic.up.rawValue)
        UserDefaults.shared.set(Double(down), forKey: ClashTraffic.down.rawValue)
    }
    
    func log(_ level: String?, payload: String?) {
        guard let level = level, let payload = payload else {
            return
        }
        NSLog("---> \(level): \(payload)")
    }
}
