import EventKit

final class EventStoreManager: ObservableObject {
    private init() {}
    
    static let shared = EventStoreManager()
    
    let eventStore: EKEventStore = EKEventStore()
    
    @Published var isRequested: Bool = false
    @Published var isAuthorized: Bool = false
    @Published var isWriteOnlyAccessToEventsRequested = false
    @Published var isWriteOnlyAccessToEventsAuthorized = false
    @Published var isFullAccessToRemindersRequested = false
    @Published var isFullAccessToRemindersAuthorized = false
    
    @Published var events: [EKEvent] = []
    
    /// アクセス許可
    @MainActor
    func requestFullAccessToEvents() async throws {
        do {
            isAuthorized = try await eventStore.requestFullAccessToEvents()
            isRequested = true
        } catch {
            throw error
        }
    }
    
    @MainActor
    func requestWriteOnlyAccessToEvents() async throws {
        do {
            isWriteOnlyAccessToEventsRequested = try await eventStore.requestWriteOnlyAccessToEvents()
            isWriteOnlyAccessToEventsAuthorized = true
        } catch {
            throw error
        }
    }
    
    @MainActor
    func requestFullAccessToReminders() async throws {
        do {
            isFullAccessToRemindersRequested = try await eventStore.requestFullAccessToReminders()
            isFullAccessToRemindersAuthorized = true
        } catch {
            throw error
        }
    }
    
    /// イベント検索処理
    func findEvents() {
        let allCalendarsForEvent = eventStore.calendars(for: .event)
        let startDate = Date.now
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: allCalendarsForEvent
        )
        
        let foundEvents = eventStore.events(matching: predicate)
        events = foundEvents
    }
}
