import EventKitUI
import SwiftUI

struct EventEditView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let editViewController = EKEventEditViewController()
        editViewController.delegate = context.coordinator
        return editViewController
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, EKEventEditViewDelegate {
        
        var parent: EventEditView
        
        init(_ parent: EventEditView) {
            self.parent = parent
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
