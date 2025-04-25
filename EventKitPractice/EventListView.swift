import SwiftUI
import EventKit

struct EventListView: View {
    @StateObject private var calendarManager = EventStoreManager.shared
    
    var body: some View {
        NavigationStack {
            List(calendarManager.events, id: \.eventIdentifier) { event in
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title ?? "タイトルなし")
                        .font(.headline)
                    Text(eventDateRange(event))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("カレンダーイベント")
            .onAppear {
                calendarManager.loadEvents()
            }
        }
    }
    
    // 日付のフォーマット補助関数
    func eventDateRange(_ event: EKEvent) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return "\(formatter.string(from: event.startDate)) 〜 \(formatter.string(from: event.endDate))"
    }
}

