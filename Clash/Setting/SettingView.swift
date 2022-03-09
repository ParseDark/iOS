import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ClashLogView()
                }
                Section {
                    UninstallVPNView()
                        .disabled(manager.controller == nil)
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
