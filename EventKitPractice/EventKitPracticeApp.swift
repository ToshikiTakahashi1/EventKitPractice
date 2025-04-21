import SwiftUI

@main
struct EventKitPracticeApp: App {
    @StateObject private var calenderAuthManager = CalenderAuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            if calenderAuthManager.isRequested {
                ContentView()
            } else {
                ProgressView()
                    .task {
                        do {
                            try await calenderAuthManager.requestAccess()
                        } catch {
                            
                        }
                    }
            }
        }
    }
}
