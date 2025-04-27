import SwiftUI
import EventKit

struct EventCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(3600) // デフォルト1時間後
    @State private var isAllDay: Bool = false
    
    private let eventStore = EKEventStore()
    
    var body: some View {
        NavigationView {
            Form {
                Section("タイトル") {
                    TextField("イベントタイトル", text: $title)
                }
                
                Section("開始日時") {
                    DatePicker("開始", selection: $startDate)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                Section("終了日時") {
                    DatePicker("終了", selection: $endDate)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                Section {
                    Toggle("終日イベント", isOn: $isAllDay)
                }
                
                Section {
                    Button("イベントを保存") {
                        saveEvent()
                    }
                    .disabled(title.isEmpty) // タイトルが空なら保存不可
                }
            }
            .navigationTitle("新規イベント作成")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveEvent() {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.isAllDay = isAllDay
                event.calendar = eventStore.defaultCalendarForNewEvents // デフォルトカレンダーに登録
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    DispatchQueue.main.async {
                        dismiss()
                    }
                } catch {
                    print("保存失敗: \(error.localizedDescription)")
                }
            } else {
                print("カレンダーへのアクセスが拒否されました")
            }
        }
    }
}
