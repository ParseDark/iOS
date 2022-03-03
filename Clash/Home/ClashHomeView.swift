import SwiftUI
import CommonKit

struct ClashHomeView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ClashConfigView()
                    if let controller = self.manager.controller {
                        VPNStateView()
                            .environmentObject(controller)
                        if controller.connectionStatus == .connected {
                            VPNConnecteDurationView()
                        }
                    }
                }
                Section {
                    VPNConfigView()
                }
                Section {
                    ClashTunnelModeView()
                }
                Section {
                    ClashTrafficUpView()
                    ClashTrafficDownView()
                }
            }
            .navigationBarTitle("Clash")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
