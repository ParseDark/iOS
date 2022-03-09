import SwiftUI

struct InstallVPNView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    var body: some View {
        HStack {
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
                        .onTapGesture {
                            Task(priority: .high) {
                                do {
                                    try await self.manager.installVPNConfiguration()
                                } catch {
                                    debugPrint(error.localizedDescription)
                                }
                            }
                        }
                }
        }
    }
}
