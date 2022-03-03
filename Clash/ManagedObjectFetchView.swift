import SwiftUI
import CoreData

public struct ManagedObjectFetchView<Object: NSManagedObject, Content: View>: View {
    
    @FetchRequest private var results: FetchedResults<Object>
    
    private let content: (FetchedResults<Object>) -> Content
    
    public init(
        sortDescriptors: [NSSortDescriptor] = [],
        predicate: NSPredicate? = nil,
        animation: Animation? = nil,
        content: @escaping (FetchedResults<Object>) -> Content
    ) {
        _results = FetchRequest(entity: Object.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: animation)
        self.content = content
    }
    
    public var body: some View {
        self.content(self.results)
    }
}
