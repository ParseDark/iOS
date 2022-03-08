import SwiftUI
import CommonKit

struct ClashConfigView: View {
    
    @AppStorage(Constant.currentConfigUUID, store: .shared) private var uuidString: String = ""
        
    private var predicate: NSPredicate {
        NSPredicate(format: "%K == %@", "uuid", (UUID(uuidString: self.uuidString) ?? UUID()).uuidString)
    }
    
    var body: some View {
        ManagedObjectFetchView(predicate: predicate) { (result: FetchedResults<ClashConfig>) in
            ModalPresentationLink {
                ClashConfigListView()
            } label: {
                HStack {
                    Image(systemName: "square.text.square")
                        .font(.title2)
                        .foregroundColor(Color.accentColor)
                    Text("配置")
                    Spacer()
                    Text(result.first.flatMap({ $0.name ?? "-" }) ?? "未选择")
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                }
            }
        }
    }
}
