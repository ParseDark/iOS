import SwiftUI

@main
struct ClashApp: App {
    
    @UIApplicationDelegateAdaptor private var delegate: AppDelegate
    
    @StateObject var manager = VPNManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .environment(\.trafficFormatter, ClashTrafficFormatterKey.defaultValue)
                .environment(\.managedObjectContext, ConfigurationStore.shared.container.viewContext)
        }
    }
}
