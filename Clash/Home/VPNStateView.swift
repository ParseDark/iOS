import SwiftUI
import NetworkExtension

struct VPNStateView: View {
    
    @EnvironmentObject private var controller: VPNController
    
    @State private var isVPNOn = false
        
    var body: some View {
        HStack {
            Image(systemName: "app.connected.to.app.below.fill")
                .font(.title2)
                .foregroundColor(Color.accentColor)
            Text("状态")
            Spacer()
            Text(self.controller.connectionStatus.displayString)
                .foregroundColor(.secondary)
            Toggle("状态", isOn: .constant(isVPNOn))
                .labelsHidden()
                .allowsHitTesting(false)
                .overlay {
                    Text("VPN")
                        .foregroundColor(.clear)
                        .onTapGesture(perform: toggleVPN)
                }
        }
        .onChange(of: controller.connectionStatus) { status in
            withAnimation(.default) {
                switch status {
                case .invalid, .disconnecting, .disconnected:
                    isVPNOn = false
                case .connecting, .connected, .reasserting:
                    isVPNOn = true
                @unknown default:
                    isVPNOn = false
                }
            }
        }
    }
    
    private func toggleVPN() {
        switch self.controller.connectionStatus {
        case .invalid, .connected, .disconnected:
            break
        case .connecting, .disconnecting, .reasserting:
            return
        @unknown default:
            break
        }
        withAnimation(.default) {
            isVPNOn.toggle()
        }
        let isOn = isVPNOn
        Task(priority: .high) {
            do {
                isOn ? try await self.controller.startVPN() : self.controller.stopVPN()
            } catch {
                debugPrint(error)
            }
        }
    }
}

fileprivate extension NEVPNStatus {
    
    var displayString: String {
        switch self {
        case .invalid:
            return "不可用"
        case .connecting:
            return "正在连接..."
        case .connected:
            return "已连接"
        case .reasserting:
            return "正在重新连接..."
        case .disconnecting:
            return "正在断开连接..."
        case .disconnected:
            return "未连接"
        @unknown default:
            return "未知"
        }
    }
}
