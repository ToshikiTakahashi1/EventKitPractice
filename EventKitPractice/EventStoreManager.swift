import EventKit

final class EventStoreManager: ObservableObject {
    private init() {}
    
    static let shared = EventStoreManager()
    
    let eventStore: EKEventStore = EKEventStore()
    
    @Published var events: [EKEvent] = []
    
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
