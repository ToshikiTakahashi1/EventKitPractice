import SwiftUI
import EventKit

@main
struct EventKitPracticeApp: App {
    
    init() {
        Task {
            do {
                try await EKEventStore().requestFullAccessToEvents()
            } catch {
                // TODO: Error Handling
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
