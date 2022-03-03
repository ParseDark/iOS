import Foundation

public enum ClashTunnelMode: String, Hashable, Identifiable, CaseIterable {
    
    public var id: Self { self }
    
    case global, rule, direct
}
