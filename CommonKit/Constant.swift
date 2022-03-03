import Foundation

public enum Constant {
    
    public static let appGroup = "group.com.Arror.Clash"
    
    public static let tunnelMode: String = "ClashTunnelMode"
    
    public static let currentConfigUUID: String = "CurrentConfigUUID"
    
    public static let homeDirectoryURL: URL = {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constant.appGroup) else {
            fatalError("无法加载共享文件路径")
        }
        let url = containerURL.appendingPathComponent("Library/Application Support/Clash")
        guard FileManager.default.fileExists(atPath: url.path) == false else {
            return url
        }
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return url
    }()
}
