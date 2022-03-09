import SwiftUI

struct VPNConfigView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    @State private var uninstallVPN = false
    
    var body: some View {
        HStack {
            if let controller = manager.controller {
                Spacer()
                Button(role: .destructive, action: { uninstallVPN.toggle() }) {
                    Text("移除VPN配置")
                        .fontWeight(.bold)
                }
                .alert("移除VPN配置", isPresented: $uninstallVPN) {
                    Button("确定", role: .destructive, action: { uninstall(controller: controller) })
                } message: {
                    Text("移除VPN配置后, 您将无法通过“Clash”连接到网络")
                }
                Spacer()
            } else {
                Image(systemName: "link")
                    .font(.title2)
                    .foregroundColor(Color.accentColor)
                Text("状态")
                Spacer()
                Toggle("状态", isOn: .constant(false))
                    .labelsHidden()
                    .allowsHitTesting(false)
                    .overlay {
                        Text("VPN")
                            .foregroundColor(.clear)
                            .onTapGesture(perform: install)
                    }
            }
        }
    }
    
    private func install() {
        Task(priority: .high) {
            do {
                try await self.manager.installVPNConfiguration()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func uninstall(controller: VPNController) {
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
