import EventKit

final class EventStoreManager: ObservableObject {
    private init() {}
    
    static let shared = EventStoreManager()
    
    let eventStore: EKEventStore = EKEventStore()
    
    @Published var isFullAccessToEventsRequested: Bool = false
    @Published var isFullAccessToEventsAuthorized: Bool = false
    @Published var isWriteOnlyAccessToEventsRequested = false
    @Published var isWriteOnlyAccessToEventsAuthorized = false
    @Published var isFullAccessToRemindersRequested = false
    @Published var isFullAccessToRemindersAuthorized = false
    
    @Published var events: [EKEvent] = []
    
    func requestAccess(for entityType: EKEntityType, actionForNoAccess: () -> Void) throws {
        let authorizationStatus = EKEventStore.authorizationStatus(for: entityType)
        switch authorizationStatus {
        case .notDetermined:
            Task {
                do {
                    try await requestFullAccessToEvents()
                } catch {
                    throw error
                }
            }
        case .restricted:
            actionForNoAccess()
        case .denied:
            actionForNoAccess()
        case .fullAccess:
            isFullAccessToEventsRequested = true
            return
        case .writeOnly:
            isFullAccessToEventsRequested = true
            return
        default:
            return
        }
    }
    
    /// アクセス許可
    @MainActor
    private func requestFullAccessToEvents() async throws {
        do {
            isFullAccessToEventsAuthorized = try await eventStore.requestFullAccessToEvents()
            isFullAccessToEventsRequested = true
        } catch {
            throw error
        }
    }
    
    @MainActor
    private func requestWriteOnlyAccessToEvents() async throws {
        do {
            isWriteOnlyAccessToEventsRequested = try await eventStore.requestWriteOnlyAccessToEvents()
            isWriteOnlyAccessToEventsAuthorized = true
        } catch {
            throw error
        }
    }
    
    @MainActor
    private func requestFullAccessToReminders() async throws {
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
