import SwiftUI
import CommonKit

struct ClashLogView: View {
        
    var body: some View {
        NavigationLink {
            LogView()
        } label: {
            HStack {
                Image(systemName: "doc.text")
                    .font(.title2)
                    .foregroundColor(Color.accentColor)
                Text("日志")
            }
        }
    }
}

private struct LogView: View {
    
    private static let formatter: DateFormatter = {
        let temp = DateFormatter()
        temp.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return temp
    }()
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClashLog.date, ascending: false)],
        animation: .default
    ) private var logs: FetchedResults<ClashLog>
    
    var body: some View {
        List(logs) { log in
            VStack(alignment: .leading, spacing: 8.0) {
                HStack {
                    if let level = log.level.flatMap(ClashLogLevel.init(rawValue:)) {
                        Text(level.rawValue.uppercased())
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                            .background(RoundedRectangle(cornerRadius: 2).fill().foregroundColor(level.color))
                    }
                    if let date = log.date {
                        Text(LogView.formatter.string(from: date))
                            .foregroundColor(Color.secondary)
                    }
                }
                if let payload = log.payload {
                    Text(payload)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                }
            }
            .padding([.top, .bottom], 8)
        }
        .navigationBarTitle("日志")
        .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate extension ClashLogLevel {
    
    var color: Color {
        switch self {
        case .slient:
            return .black
        case .info:
            return .green
        case .debug:
            return .blue
        case .warning:
            return .yellow
        case .error:
            return .red
        }
    }
}
