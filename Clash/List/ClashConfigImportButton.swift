import SwiftUI

struct ClashConfigImportItem: Identifiable {
    
    let id: UUID
    let fileURL: URL?
    
    init(fileURL: URL?) {
        self.id = UUID()
        self.fileURL = fileURL
    }
}

struct ClashConfigImportButton: View {
    
    @State private var isConfirmationDialogPresented = false
    @State private var isDocumentPickerViewPresented = false
    @State private var importItem: ClashConfigImportItem?
    @State private var fileURL: URL?
    
    var body: some View {
        Button {
            isConfirmationDialogPresented.toggle()
        } label: {
            Image(systemName: "plus")
        }
        .confirmationDialog(Text("添加配置"), isPresented: $isConfirmationDialogPresented, titleVisibility: .visible) {
            Button(role: nil) {
                importItem = ClashConfigImportItem(fileURL: nil)
            } label: {
                Text("下载配置文件")
            }
            Button(role: nil) {
                isDocumentPickerViewPresented.toggle()
            } label: {
                Text("导入本地配置文件")
            }
            Button("取消", role: .cancel, action: {})
        } message: {
            Text("从网络下载或者文件App导入配置文件, 配置文件暂不支持Rule Provider")
        }
        .sheet(item: $importItem, onDismiss: nil) {
            ClashConfigImportView(importItem: $0)
        }
        .sheet(isPresented: $isDocumentPickerViewPresented) {
            DispatchQueue.main.async {
                importItem = ClashConfigImportItem(fileURL: fileURL)
            }
        } content: {
            DocumentPickerView(filenameExtension: "yaml", binding: $fileURL)
                .ignoresSafeArea()
        }
    }
}
