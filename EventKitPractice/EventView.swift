import UIKit
import SwiftUI
import EventKit
import EventKitUI

struct EventView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let event = EKEvent(eventStore: EventStoreManager.shared.eventStore)
        let eventViewController = EKEventViewController()
        eventViewController.allowsCalendarPreview = true
        eventViewController.allowsEditing = true
        eventViewController.event = event
        return eventViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
