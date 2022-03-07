import CoreData

public final class CoreDataStack {
    
    public static let shared = CoreDataStack()

    public let container: NSPersistentContainer

    private init() {
        self.container = NSPersistentContainer(name: "Clash")
        self.loadPersistentStores()
    }
    
    private func loadPersistentStores() {
        self.container.loadPersistentStores { storeDescription, error in
            guard error != nil else {
                return
            }
            guard let fileURL = storeDescription.url else {
                fatalError("无法找到数据库文件")
            }
            do {
                try FileManager.default.removeItem(at: fileURL)
                self.loadPersistentStores()
            } catch {
                fatalError("删除数据库失败: \(error.localizedDescription)")
            }
        }
    }
}
