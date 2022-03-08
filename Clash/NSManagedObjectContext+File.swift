import Foundation
import CoreData
import CommonKit

extension NSManagedObjectContext {
    
    func importClashConfig(name: String, url: URL) async throws {
        let content: String
        if url.isFileURL {
            content = try String(contentsOf: url)
        } else {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            content = String(data: data, encoding: .utf8) ?? ""
        }
        let uuid = UUID()
        let directoryURL = Constant.homeDirectoryURL.appendingPathComponent("\(uuid.uuidString)")
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        let targetURL = directoryURL.appendingPathComponent("config.yaml")
        FileManager.default.createFile(atPath: targetURL.path, contents: content.data(using: .utf8), attributes: nil)
        let configuration = ClashConfig(context: self)
        configuration.uuid = uuid
        configuration.name = name
        configuration.link = targetURL
        configuration.date = Date()
        try self.save()
    }
    
    func deleteClashConfig(_ config: ClashConfig) throws {
        self.delete(config)
        try self.save()
        guard let uuid = config.uuid else {
            return
        }
        try FileManager.default.removeItem(at: Constant.homeDirectoryURL.appendingPathComponent("\(uuid.uuidString)"))
    }
}
