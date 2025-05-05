import SwiftUI
import EventKit

struct EventListView: View {
    @StateObject private var calendarManager = EventStoreManager.shared
    
    var body: some View {
        NavigationView {
            List(calendarManager.events, id: \.eventIdentifier) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    VStack(alignment: .leading) {
                        Text(event.title ?? "タイトルなし")
                            .font(.headline)
                        Text(dateRangeString(for: event))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("カレンダーイベント")
            .onAppear {
                calendarManager.findEvents()
            }
        }
    }
    
    private func dateRangeString(for event: EKEvent) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return "\(formatter.string(from: event.startDate)) 〜 \(formatter.string(from: event.endDate))"
    }
}
