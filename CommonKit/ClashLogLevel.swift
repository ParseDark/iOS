import Foundation

public enum ClashLogLevel: String, Identifiable, CaseIterable {
    
    public var id: Self { self }
    
    case slient, info, debug, warning, error
}
