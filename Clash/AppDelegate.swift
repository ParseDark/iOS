import UIKit
import CommonKit

public final class AppDelegate: NSObject, UIApplicationDelegate {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.copyCountryDB()
        
        return true
    }
    
    private func copyCountryDB() {
        let dbFileName = "Country"
        let dbFileExtension = "mmdb"
        let dbURL = Constant.homeDirectoryURL.appendingPathComponent("\(dbFileName).\(dbFileExtension)")
        guard !FileManager.default.fileExists(atPath: dbURL.path) else {
            return
        }
        guard let local = Bundle.main.url(forResource: dbFileName, withExtension: dbFileExtension) else {
            return
        }
        do {
            try FileManager.default.copyItem(at: local, to: dbURL)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
