import CoreData

public final class ConfigurationStore {
    
    public static let shared = ConfigurationStore()

    public let container: NSPersistentContainer

    private init() {
        self.container = NSPersistentContainer(name: "Clash")
        self.container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
