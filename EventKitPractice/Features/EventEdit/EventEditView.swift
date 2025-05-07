import EventKitUI
import SwiftUI

struct EventEditView: UIViewControllerRepresentable {
    private let eventToEdit: EKEvent?
    
    init(eventToEdit: EKEvent?) {
        self.eventToEdit = eventToEdit
    }
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let editViewController = EKEventEditViewController()
        editViewController.event = eventToEdit
        editViewController.eventStore = EventStoreManager.shared.eventStore
        editViewController.delegate = context.coordinator
        return editViewController
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, EKEventEditViewDelegate {
        
        var parent: EventEditView
        
        init(_ parent: EventEditView) {
            self.parent = parent
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
