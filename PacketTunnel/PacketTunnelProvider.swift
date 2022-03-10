import NetworkExtension
import CommonKit
import ClashKit

class PacketTunnelProvider: NEPacketTunnelProvider {
        
    override func startTunnel(options: [String : NSObject]? = nil) async throws {
        try self.setupClash()
        try self.setCurrentConfig()
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "240.240.240.240")
        settings.mtu = 1500
        settings.ipv4Settings = {
            let settings = NEIPv4Settings(addresses: ["240.0.0.1"], subnetMasks: ["255.255.255.0"])
            settings.includedRoutes = [NEIPv4Route.default()]
            return settings
        }()
        settings.proxySettings = {
            let settings = NEProxySettings()
            settings.matchDomains = [""]
            settings.excludeSimpleHostnames = true
            settings.httpEnabled = true
            settings.httpServer = NEProxyServer(address: "127.0.0.1", port: 8080)
            settings.httpsEnabled = true
            settings.httpsServer = NEProxyServer(address: "127.0.0.1", port: 8080)
            return settings
        }()
        settings.dnsSettings = {
            let settings = NEDNSSettings(servers: ["127.0.0.1"])
            return settings
        }()
        try await self.setTunnelNetworkSettings(settings)
        DispatchQueue.main.async(execute: self.readPackets)
    }
    
    private func readPackets() {
        self.packetFlow.readPackets { packets, _ in
            packets.forEach(ClashReadPacket(_:))
            self.readPackets()
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason) async {
        do {
            try await self.setTunnelNetworkSettings(nil)
        } catch {
            debugPrint(error)
        }
        self.receiveTraffic(0, down: 0)
    }
    
    override func handleAppMessage(_ messageData: Data) async -> Data? {
        guard let command = messageData.first.flatMap(ClashCommand.init(rawValue:)) else {
            return nil
        }
        switch command {
        case .setCurrentConfig:
            do {
                try self.setCurrentConfig()
            } catch {
                return error.localizedDescription.data(using: .utf8)
            }
        case .setTunnelMode:
            ClashSetTunnelMode(UserDefaults.shared.string(forKey: Constant.tunnelMode))
        case .setLogLevel:
            ClashSetLogLevel(UserDefaults.shared.string(forKey: Constant.logLevel))
        }
        return nil
    }
}
