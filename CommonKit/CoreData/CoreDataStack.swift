import CoreData

private class ClashPersistentContainer: NSPersistentContainer {
    
    override class func defaultDirectoryURL() -> URL {
        Constant.homeDirectoryURL.appendingPathComponent("CoreData", isDirectory: true)
    }
}

public final class CoreDataStack {
    
    public static let shared = CoreDataStack()

    public let container: NSPersistentContainer

    private init() {
        guard let url = Bundle(for: CoreDataStack.self).url(forResource: "Clash", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("数据库模型文件加载失败")
        }
        self.container = ClashPersistentContainer(name: "Clash", managedObjectModel: model)
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
