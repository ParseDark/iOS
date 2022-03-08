import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ClashLogView()
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
