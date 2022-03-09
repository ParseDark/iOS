import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ClashLogView()
                }
                if manager.controller != nil {
                    Section {
                        VPNConfigView()
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
