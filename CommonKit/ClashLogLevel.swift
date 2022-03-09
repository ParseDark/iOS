import Foundation

public enum ClashLogLevel: String, Identifiable, CaseIterable {
        
    public var id: Self { self }
    
    case silent, info, debug, warning, error
}
