import Foundation
import EventKit

@MainActor
final class CalenderAuthManager: ObservableObject {
    private init() {}
    
    static let shared = CalenderAuthManager()
    
    let eventStore = EKEventStore()
    
    @Published var isRequested: Bool = false
    @Published var isAuthorized: Bool = false
    
    func requestAccess() async throws {
        do {
            isAuthorized = try await eventStore.requestFullAccessToEvents()
            isRequested = true
        } catch {
            throw error
        }
    }
}
