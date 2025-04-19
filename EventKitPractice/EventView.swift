import UIKit
import SwiftUI
import EventKitUI

struct EventView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return EKEventViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
