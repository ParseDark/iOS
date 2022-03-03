import SwiftUI
import CommonKit

struct ClashConfigListView: View {
    
    @AppStorage(Constant.currentConfigUUID, store: .shared) private var uuidString: String = ""
        
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Configuration.date, ascending: false)],
        animation: .default
    ) private var configs: FetchedResults<Configuration>
        
    var body: some View {
        NavigationView {
            List(configs) { config in
                HStack {
                    Text(config.name ?? "-")
                    Spacer()
                    if config.uuid.flatMap({ $0.uuidString }) == uuidString {
                        Text(Image(systemName: "checkmark"))
                            .fontWeight(.medium)
                            .foregroundColor(Color.accentColor)
                    }
                }
                .lineLimit(1)
                .contentShape(Rectangle())
                .onTapGesture { onCellTapGesture(config: config) }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button("删除", role: .destructive) { onCellDeleteAction(config: config) }
                }
            }
            .navigationBarTitle("配置管理")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ClashConfigImportButton()
                }
            }
        }
    }
    
    private func onCellTapGesture(config: Configuration) {
        uuidString = config.uuid?.uuidString ?? ""
        dismiss()
    }
    
    private func onCellDeleteAction(config: Configuration) {
        do {
            if config.uuid.flatMap({ $0.uuidString }) == uuidString {
                uuidString = ""
            }
            try context.deleteClashConfig(config)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
