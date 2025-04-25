import EventKit

final class EventStoreManager: ObservableObject {
    private init() {}
    
    static let shared = EventStoreManager()
    
    let eventStore: EKEventStore = EKEventStore()
    
    @Published var events: [EKEvent] = []
    
    // アクセス許可＋イベント取得
    func loadEvents() {
        let calendars = eventStore.calendars(for: .event)
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
        
        let predicate = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        
        let fetchedEvents = self.eventStore.events(matching: predicate)
        
        DispatchQueue.main.async {
            self.events = fetchedEvents
        }
    }
}
