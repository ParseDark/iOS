import SwiftUI
import CommonKit

private extension ClashTraffic {
    
    var title: String {
        switch self {
        case .up:
            return "上行速率"
        case .down:
            return "下行速率"
        }
    }
    
    var imageName: String {
        switch self {
        case .up:
            return "arrow.up"
        case .down:
            return "arrow.down"
        }
    }
}

struct ClashTrafficUpView: View {
    
    @AppStorage(ClashTraffic.up.rawValue, store: .shared) private var up: Double = 0
    
    var body: some View {
        ClashTrafficView(traffic: .up, binding: $up)
    }
}

struct ClashTrafficDownView: View {
    
    @AppStorage(ClashTraffic.down.rawValue, store: .shared) private var down: Double = 0
    
    var body: some View {
        ClashTrafficView(traffic: .down, binding: $down)
    }
}

private struct ClashTrafficView: View {
    
    @Environment(\.trafficFormatter) private var formatter: NumberFormatter
    
    let traffic: ClashTraffic
    let binding: Binding<Double>
    
    init(traffic: ClashTraffic, binding: Binding<Double>) {
        self.traffic = traffic
        self.binding = binding
    }
    
    var body: some View {
        HStack {
            Image(systemName: self.traffic.imageName)
                .font(.title2)
                .foregroundColor(Color.accentColor)
            Text(self.traffic.title)
            Spacer()
            Text(formatter.string(from: NSNumber(value: self.binding.wrappedValue)) ?? "-")
                .fontWeight(.bold)
        }
    }
}
