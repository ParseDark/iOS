import SwiftUI

struct VPNConfigView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    @State private var uninstallVPN = false
    
    var body: some View {
        Button(role: self.manager.controller == nil ? nil : .destructive, action: install) {
            Text("\(self.manager.controller == nil ? "添加" : "移除")VPN配置")
                .fontWeight(self.manager.controller == nil ? .bold : .regular)
        }
        .alert("移除VPN配置", isPresented: $uninstallVPN) {
            Button("确定", role: .destructive, action: uninstall)
        } message: {
            Text("移除VPN配置后, 您将无法通过“Clash”连接到网络")
        }
    }
    
    private func install() {
        if self.manager.controller == nil {
            Task(priority: .high) {
                do {
                    try await self.manager.installVPNConfiguration()
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        } else {
            self.uninstallVPN = true
        }
    }
    
    private func uninstall() {
        guard let controller = self.manager.controller else {
            return
        }
        Task(priority: .high) {
            do {
                try await controller.uninstallVPNConfiguration()
                await self.manager.refreshController()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}
