import SwiftUI
import CommonKit

struct ClashLogView: View {
    
    @EnvironmentObject private var manager: VPNManager
    
    @AppStorage(Constant.logLevel, store: .shared) private var logLevel: ClashLogLevel = .silent
        
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
            .task(id: logLevel) {
                guard let controller = self.manager.controller else {
                    return
                }
                do {
                    try await controller.execute(command: .setLogLevel)
                } catch {
                    debugPrint(error)
                }
            }
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
        case .silent:
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
