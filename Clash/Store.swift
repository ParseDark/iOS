import CoreData

public final class Store {
    
    public static let shared = Store()

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
