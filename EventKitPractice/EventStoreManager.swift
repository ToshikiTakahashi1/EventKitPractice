import EventKit

final class EventStoreManager {
    private init() {}
    
    static let shared = EventStoreManager()
    
    let eventStore: EKEventStore = EKEventStore()
}
