import SwiftUI
import CommonKit

struct ClashConfigImportView: View {
        
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var url: String = ""
    @State private var isURLEditable: Bool = true
    
    let importItem: ClashConfigImportItem
    
    @MainActor @State private var isProcessing: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("名称:")
                        TextField("名称", text: $name, prompt: Text("请输入名称"))
                    }
                    if isURLEditable {
                        HStack {
                            Text("地址:")
                            TextField("地址", text: $url, prompt: Text("请输入地址"))
                        }
                    }
                }
                Section {
                    Button(action: importClashConfig) {
                        HStack {
                            Spacer()
                            if isProcessing {
                                ProgressView()
                            } else {
                                Text(importItem.fileURL == nil ? "下载" : "添加")
                            }
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty || url.isEmpty)
                }
            }
            .navigationTitle("\(importItem.fileURL == nil ? "下载" : "添加")配置")
            .navigationBarTitleDisplayMode(.inline)
        }
        .disabled(isProcessing)
        .interactiveDismissDisabled(isProcessing)
        .onAppear {
            guard let fileURL = importItem.fileURL else {
                return
            }
            self.name = fileURL.deletingPathExtension().lastPathComponent
            self.url = fileURL.absoluteString
            self.isURLEditable = !fileURL.isFileURL
        }
    }
    
    private func importClashConfig() {
        guard let url = URL(string: url) else {
            return
        }
        Task(priority: .high) {
            await MainActor.run {
                isProcessing = true
            }
            do {
                try await context.importClashConfig(name: name, url: url)
                dismiss()
            } catch {
                debugPrint(error.localizedDescription)
            }
            await MainActor.run {
                isProcessing = false
            }
        }
    }
}
