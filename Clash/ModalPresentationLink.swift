import SwiftUI

struct ModalPresentationLink<Label: View, Destination: View>: View {
    
    private let destination: () -> Destination
    private let label: () -> Label
    private let onDismiss: (() -> Void)?
    
    @State private var isPresented = false
    
    init(destination: @escaping () -> Destination, label: @escaping () -> Label, onDismiss: (() -> Void)? = nil) {
        self.destination = destination
        self.label = label
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        label()
            .contentShape(Rectangle())
            .onTapGesture { isPresented.toggle() }
            .sheet(isPresented: $isPresented, onDismiss: onDismiss, content: destination)
    }
}
