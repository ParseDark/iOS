import Foundation
import CommonKit
import ClashKit

extension PacketTunnelProvider: ClashPacketFlowProtocol, ClashTrafficReceiverProtocol, ClashRealTimeLoggerProtocol {
    
    func setupClash() throws {
        let config = """
        mixed-port: 8080
        mode: \(UserDefaults.shared.string(forKey: Constant.tunnelMode) ?? ClashTunnelMode.rule.rawValue)
        log-level: \(UserDefaults.shared.string(forKey: Constant.logLevel) ?? ClashLogLevel.silent.rawValue)
        dns:
          enable: true
          ipv6: false
          listen: 0.0.0.0:53
          enhanced-mode: redir-host
          use-hosts: false
          nameserver:
            - 114.114.114.114
          fallback:
            - 8.8.8.8
            - 1.1.1.1
            - tls://8.8.8.8:853
            - tls://1.1.1.1:853
            - https://dns.google/dns-query
            - https://cloudflare-dns.com/dns-query
          fallback-filter:
            geoip: true
            ipcidr:
              - 240.0.0.0/4
        """
        var error: NSError? = nil
        ClashSetup(self, Constant.homeDirectoryURL.path, config, &error)
        if let error = error {
            throw error
        }
        ClashSetRealTimeLogger(self)
        ClashSetTrafficReceiver(self)
    }
    
    func setCurrentConfig() throws {
        var error: NSError? = nil
        ClashSetConfig(UserDefaults.shared.string(forKey: Constant.currentConfigUUID), &error)
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
        guard let level = level.flatMap(ClashLogLevel.init(rawValue:)),
              let payload = payload, !payload.isEmpty else {
            return
        }
        NSLog("Clash Core: [\(level.rawValue.uppercased())] \(payload)")
    }
}
