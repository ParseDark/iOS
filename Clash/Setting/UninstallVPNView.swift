import SwiftUI

struct UninstallVPNView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    @State private var isAlertPresented = false
    
    var body: some View {
        Button(role: .destructive, action: { isAlertPresented.toggle() }) {
            HStack {
                Spacer()
                Text("移除VPN配置")
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .alert("移除VPN配置", isPresented: $isAlertPresented) {
            Button("确定", role: .destructive) {
                Task(priority: .high) {
                    guard let controller = manager.controller else {
                        return
                    }
                    do {
                        try await controller.uninstallVPNConfiguration()
                        await manager.refreshController()
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
        } message: {
            Text("移除VPN配置后, 您可以在主页点击配置开关重新添加VPN配置")
        }
    }
}
