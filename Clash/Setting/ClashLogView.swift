import SwiftUI
import CommonKit

struct ClashLogView: View {
    
    @AppStorage(Constant.logLevel, store: .shared) private var logLevel: ClashLogLevel = .slient
        
    var body: some View {
        NavigationLink {
            Form {
                Picker("日志等级", selection: $logLevel) {
                    ForEach(ClashLogLevel.allCases) { level in
                        Text(level.displayName)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            .navigationBarTitle("日志等级")
        } label: {
            HStack {
                Image(systemName: "doc.text")
                    .font(.title2)
                    .foregroundColor(Color.accentColor)
                Text("日志等级")
                Spacer()
                Text(logLevel.displayName)
                    .fontWeight(.bold)
            }
        }
    }
}

fileprivate extension ClashLogLevel {
    
    var displayName: String {
        switch self {
        case .slient:
            return "静默"
        case .info:
            return "信息"
        case .debug:
            return "调试"
        case .warning:
            return "警告"
        case .error:
            return "错误"
        }
    }
}
