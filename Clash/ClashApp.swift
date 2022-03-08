import SwiftUI
import CommonKit

@main
struct ClashApp: App {
    
    @UIApplicationDelegateAdaptor private var delegate: AppDelegate
    
    @StateObject var manager = VPNManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .environment(\.trafficFormatter, ClashTrafficFormatterKey.defaultValue)
                .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
        }
    }
}
