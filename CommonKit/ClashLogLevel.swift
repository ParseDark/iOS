import Foundation

public enum ClashLogLevel: String, Identifiable, CaseIterable, Comparable {
        
    public var id: Self { self }
    
    case silent, info, debug, warning, error
    
    public static func < (lhs: ClashLogLevel, rhs: ClashLogLevel) -> Bool {
        lhs.weight < rhs.weight
    }
    
    private var weight: Int {
        switch self {
        case .silent:
            return 0
        case .info:
            return 1
        case .debug:
            return 2
        case .warning:
            return 3
        case .error:
            return 4
        }
    }
}
