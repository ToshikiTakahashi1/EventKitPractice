import SwiftUI

@main
struct EventKitPracticeApp: App {
    @StateObject private var eventStoreManager = EventStoreManager.shared
    
    var body: some Scene {
        WindowGroup {
            if eventStoreManager.isRequested {
                ContentView()
            } else {
                ProgressView()
                    .task {
                        do {
                            try await eventStoreManager.requestAccess()
                        } catch {
                            
                        }
                    }
            }
        }
    }
}
