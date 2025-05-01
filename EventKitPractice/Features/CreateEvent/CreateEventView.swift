import SwiftUI
import EventKit

struct EventCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(3600) // デフォルト1時間後
    @State private var isAllDay: Bool = false
    @State private var availability: EKEventAvailability = .busy
    @State private var location: String = ""
    @State private var url: String = ""
    @State private var selectedTimeZoneID: String = TimeZone.current.identifier
    @State private var notes: String = ""
    @State private var selectedAlarmOffsets: Set<TimeInterval> = []
    
    private let eventStore = EKEventStore()
    
    let alarmOptions: [(label: String, offset: TimeInterval)] = [
        ("5分前", -300),
        ("10分前", -600),
        ("30分前", -1800),
        ("1時間前", -3600),
        ("1日前", -86400)
    ]

    
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
                
                Section("場所") {
                    TextField("場所を入力", text: $location)
                }

                Section("参加可否") {
                    Picker("参加状況", selection: $availability) {
                        Text("出席可").tag(EKEventAvailability.free)
                        Text("多忙").tag(EKEventAvailability.busy)
                        Text("仮予定").tag(EKEventAvailability.tentative)
                        Text("不可").tag(EKEventAvailability.unavailable)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("URL") {
                    TextField("関連URL（任意）", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                
                Section("タイムゾーン") {
                    Picker("タイムゾーン", selection: $selectedTimeZoneID) {
                        ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { id in
                            Text(id).tag(id)
                        }
                    }
                }
                
                Section("メモ") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
                
                Section("通知") {
                    ForEach(alarmOptions, id: \.offset) { option in
                        Toggle(option.label, isOn: Binding(
                            get: { selectedAlarmOffsets.contains(option.offset) },
                            set: { isSelected in
                                if isSelected {
                                    selectedAlarmOffsets.insert(option.offset)
                                } else {
                                    selectedAlarmOffsets.remove(option.offset)
                                }
                            }
                        ))
                    }
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
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.availability = availability // ← 追加！
        
        if !location.isEmpty {
            let structuredLocation = EKStructuredLocation(title: location)
            structuredLocation.geoLocation = nil // ここでは座標は設定しない（必要なら後で）
            event.structuredLocation = structuredLocation // ← 追加！
            event.location = location // ← これは普通の文字列locationも一応セット
        }
        
        if let eventURL = URL(string: url), !url.isEmpty {
            event.url = eventURL
        }
        
        if let selectedTimeZone = TimeZone(identifier: selectedTimeZoneID) {
            event.timeZone = selectedTimeZone
        }
        
        event.notes = notes
        
        event.alarms = selectedAlarmOffsets.map { offset in
            EKAlarm(relativeOffset: offset)
        }
        
        do {
            try eventStore.save(event, span: .thisEvent)
            dismiss()
        } catch {
            print("保存失敗: \(error.localizedDescription)")
        }
    }
}
