import Foundation
import SwiftUI

private class ClashTrafficFormatter: NumberFormatter {
    
    static let `default` = ClashTrafficFormatter()
    
    override init() {
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    public override func number(from string: String) -> NSNumber? {
        fatalError("number(from:) has not been implemented")
    }
    
    override func string(from number: NSNumber) -> String? {
        let kb = number.int64Value / 1024
        guard kb >= 1024 else {
            return "\(kb)KB/s"
        }
        let mb = number.doubleValue / 1024.0 / 1024.0
        if mb >= 1000 {
            return String(format: "%.1fGB/s", mb / 1024.0)
        } else if mb >= 100 {
            return String(format: "%.1fMB/s", mb)
        } else {
            return String(format: "%.2fMB/s", mb)
        }
    }
}

enum ClashTrafficFormatterKey: EnvironmentKey {
    static let defaultValue: NumberFormatter = ClashTrafficFormatter.default
}

extension EnvironmentValues {
    
    public var trafficFormatter: NumberFormatter {
        get { self[ClashTrafficFormatterKey.self] }
        set { self[ClashTrafficFormatterKey.self] = newValue }
    }
}
