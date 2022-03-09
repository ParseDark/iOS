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
                        VPNConnecteDurationView()
                            .environmentObject(controller)
                    } else {
                        VPNConfigView()
                    }
                }
                Section {
                    ClashTunnelModeView()
                }
                Section {
                    ClashTrafficUpView()
                    ClashTrafficDownView()
                }
            }
            .navigationBarTitle("主页")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
