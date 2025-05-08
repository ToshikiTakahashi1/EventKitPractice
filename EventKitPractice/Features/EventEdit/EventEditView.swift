import EventKitUI
import SwiftUI

struct EventEditView: UIViewControllerRepresentable {
    private let eventToEdit: EKEvent?
    @Binding private var isPresentet: Bool
    
    init(eventToEdit: EKEvent?, isPresented: Binding<Bool>) {
        self.eventToEdit = eventToEdit
        self._isPresentet = isPresented
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
        
        func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
            return EventStoreManager.shared.eventStore.defaultCalendarForNewEvents!
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            switch action {
            case .canceled:
                print("キャンセルされました")
            case .saved:
                print("イベントが保存されました")
            case .deleted:
                print("イベントが削除されました")
            @unknown default:
                print("未定義のアクション")
            }
            parent.isPresentet = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
