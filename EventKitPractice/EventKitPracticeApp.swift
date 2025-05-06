import SwiftUI

@main
struct EventKitPracticeApp: App {
    @StateObject private var eventStoreManager = EventStoreManager.shared
    
    @State private var isNoAccessAlertPresented = false
    
    var body: some Scene {
        WindowGroup {
            if eventStoreManager.isRequested {
                ContentView()
            } else {
                ProgressView()
                    .task {
                        do {
                            try eventStoreManager.requestAccess(
                                for: .event,
                                actionForNoAccess: {
                                    isNoAccessAlertPresented = true
                                }
                            )
                        } catch {
                            // TODO: エラハン
                        }
                    }
                    .alert("アクセスが拒否されています。", isPresented: $isNoAccessAlertPresented, actions: {}, message: {
                        Text("アプリの機能を利用するには、設定 > アプリ > 本アプリ > カレンダーにてアクセス許可をお願いします。")
                    })
            }
        }
    }
}
