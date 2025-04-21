import UIKit
import SwiftUI
import EventKit
import EventKitUI

struct EventView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let event = EKEvent(eventStore: CalenderAuthManager.shared.eventStore)
        let eventViewController = EKEventViewController()
        eventViewController.event = event
        return eventViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
