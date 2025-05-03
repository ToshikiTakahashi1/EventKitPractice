import SwiftUI
import EventKit

struct EventCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - States
    @State private var title: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(3600)
    @State private var isAllDay: Bool = false
    @State private var availability: EKEventAvailability = .busy
    @State private var location: String = ""
    @State private var url: String = ""
    @State private var selectedTimeZoneID: String = TimeZone.current.identifier
    @State private var notes: String = ""
    @State private var selectedAlarmOffsets: Set<TimeInterval> = []
    @State private var selectedRepeat: RepeatRule = .none
    
    private let eventStore = EKEventStore()
    
    var body: some View {
        NavigationStack {
            Form {
                titleSection
                dateSection
                allDayToggleSection
                locationSection
                availabilitySection
                urlSection
                timeZoneSection
                notesSection
                alarmSection
                recurrenceSection
            }
            .navigationTitle("新規")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル", action: {dismiss()})
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("追加", action: saveEvent)
                        .bold()
                        .disabled(title.isEmpty)
                }
            }
        }
        .interactiveDismissDisabled()
    }
    
    // MARK: - Subviews
    
    private var titleSection: some View {
        Section("タイトル") {
            TextField("イベントタイトル", text: $title)
        }
    }
    
    private var dateSection: some View {
        Group {
            Section("開始日時") {
                DatePicker("開始", selection: $startDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            
            Section("終了日時") {
                DatePicker("終了", selection: $endDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
        }
    }
    
    private var allDayToggleSection: some View {
        Section {
            Toggle("終日イベント", isOn: $isAllDay)
        }
    }
    
    private var locationSection: some View {
        Section("場所") {
            TextField("場所を入力", text: $location)
        }
    }
    
    private var availabilitySection: some View {
        Section("参加可否") {
            Picker("参加状況", selection: $availability) {
                Text("出席可").tag(EKEventAvailability.free)
                Text("多忙").tag(EKEventAvailability.busy)
                Text("仮予定").tag(EKEventAvailability.tentative)
                Text("不可").tag(EKEventAvailability.unavailable)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var urlSection: some View {
        Section("URL") {
            TextField("関連URL（任意）", text: $url)
                .keyboardType(.URL)
                .autocapitalization(.none)
        }
    }
    
    private var timeZoneSection: some View {
        Section("タイムゾーン") {
            Picker("タイムゾーン", selection: $selectedTimeZoneID) {
                ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { id in
                    Text(id).tag(id)
                }
            }
        }
    }
    
    private var notesSection: some View {
        Section("メモ") {
            TextEditor(text: $notes)
                .frame(minHeight: 100)
        }
    }
    
    private var alarmSection: some View {
        Section("通知") {
            ForEach(AlarmOption.allCases, id: \.self) { option in
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
    }
    
    private var recurrenceSection: some View {
        Section("繰り返し") {
            Picker("繰り返し", selection: $selectedRepeat) {
                ForEach(RepeatRule.allCases) { rule in
                    Text(rule.label).tag(rule)
                }
            }
        }
    }
    
    // MARK: - Save Logic
    
    private func saveEvent() {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.availability = availability
        
        if !location.isEmpty {
            let structuredLocation = EKStructuredLocation(title: location)
            structuredLocation.geoLocation = nil
            event.structuredLocation = structuredLocation
            event.location = location
        }
        
        if let eventURL = URL(string: url), !url.isEmpty {
            event.url = eventURL
        }
        
        if let selectedTimeZone = TimeZone(identifier: selectedTimeZoneID) {
            event.timeZone = selectedTimeZone
        }
        
        event.notes = notes
        
        event.alarms = selectedAlarmOffsets.map {
            EKAlarm(relativeOffset: $0)
        }
        
        if let freq = selectedRepeat.frequency {
            let rule = EKRecurrenceRule(recurrenceWith: freq, interval: 1, end: nil)
            event.recurrenceRules = [rule]
        }
        
        do {
            try eventStore.save(event, span: .thisEvent)
            dismiss()
        } catch {
            print("保存失敗: \(error.localizedDescription)")
        }
    }
}

// MARK: - RepeatRule

enum RepeatRule: String, CaseIterable, Identifiable {
    case none, daily, weekly, monthly, yearly
    var id: String { self.rawValue }
    
    var label: String {
        switch self {
        case .none: return "繰り返しなし"
        case .daily: return "毎日"
        case .weekly: return "毎週"
        case .monthly: return "毎月"
        case .yearly: return "毎年"
        }
    }
    
    var frequency: EKRecurrenceFrequency? {
        switch self {
        case .none: return nil
        case .daily: return .daily
        case .weekly: return .weekly
        case .monthly: return .monthly
        case .yearly: return .yearly
        }
    }
}

// MARK: - AlarmOption

enum AlarmOption: CaseIterable, Hashable {
    case min5, min10, min30, hour1, day1
    
    var label: String {
        switch self {
        case .min5: return "5分前"
        case .min10: return "10分前"
        case .min30: return "30分前"
        case .hour1: return "1時間前"
        case .day1: return "1日前"
        }
    }
    
    var offset: TimeInterval {
        switch self {
        case .min5: return -300
        case .min10: return -600
        case .min30: return -1800
        case .hour1: return -3600
        case .day1: return -86400
        }
    }
}
