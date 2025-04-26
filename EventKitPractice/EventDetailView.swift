import SwiftUI
import EventKit

struct EventDetailView: View {
    private let event: EKEvent
    
    init(event: EKEvent) {
        self.event = event
    }
    
    var body: some View {
        List {
            Section("タイトル") {
                Text(event.title ?? "なし")
            }
            Section("場所") {
                Text(event.location ?? "なし")
            }
            Section("開始日時") {
                Text(dateString(event.startDate))
            }
            Section("終了日時") {
                Text(dateString(event.endDate))
            }
            Section("終日イベント？") {
                Text(event.isAllDay ? "はい" : "いいえ")
            }
            Section("カレンダー名") {
                Text(event.calendar.title)
            }
            Section("タイムゾーン") {
                Text(event.timeZone?.identifier ?? "未設定")
            }
            if event.hasNotes {
                Section("メモ") {
                    Text(event.notes ?? "なし")
                }
            }
            Section("リンク") {
                Text(event.url?.absoluteString ?? "なし")
            }
            Section("空き状況") {
                Text(availabilityString(event.availability))
            }
            if event.hasAlarms, let alarms = event.alarms {
                Section("アラーム") {
                    ForEach(Array(alarms.enumerated()), id: \.offset) { index, alarm in
                        if let relativeOffset = alarm.relativeOffset as Double? {
                            Text("アラーム\(index + 1): \(relativeOffset / 60)分前に通知")
                        } else if let absoluteDate = alarm.absoluteDate {
                            Text("アラーム\(index + 1): \(dateString(absoluteDate))に通知")
                        } else {
                            Text("アラーム\(index + 1): 詳細不明")
                        }
                    }
                }
            } else {
                Section("アラーム") {
                    Text("なし")
                }
            }
            if event.hasAttendees, let attendees = event.attendees {
                Section("参加者数") {
                    Text("\(attendees.count)人")
                }
            } else {
                Section("参加者") {
                    Text("なし")
                }
            }
            if let organizer = event.organizer {
                Section("主催者") {
                    Text(organizer.name ?? "不明")
                }
            } else {
                Section("主催者") {
                    Text("なし")
                }
            }
            if let recurrenceRules = event.recurrenceRules, !recurrenceRules.isEmpty {
                Section("繰り返しルール") {
                    Text(recurrenceDescription(recurrenceRules))
                }
            } else {
                Section("繰り返しルール") {
                    Text("なし")
                }
            }
            if let createdDate = event.creationDate {
                Section("作成日時") {
                    Text(dateString(createdDate))
                }
            }
            if let modifiedDate = event.lastModifiedDate {
                Section("最終更新日時") {
                    Text(dateString(modifiedDate))
                }
            }
            if let structuredLocation = event.structuredLocation {
                Section("位置情報名") {
                    Text(structuredLocation.title ?? "なし")
                }
                if let geoLocation = structuredLocation.geoLocation {
                    Section("緯度") {
                        Text("\(geoLocation.coordinate.latitude)")
                    }
                    Section("経度") {
                        Text("\(geoLocation.coordinate.longitude)")
                    }
                }
            }
            if let contactId = event.birthdayContactIdentifier {
                Section("誕生日連絡先ID") {
                    Text(contactId)
                }
            }
        }
        .navigationTitle("イベント詳細")
    }
    
    private func dateString(_ date: Date?) -> String {
        guard let date = date else { return "未設定" }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func availabilityString(_ availability: EKEventAvailability) -> String {
        switch availability {
        case .busy: return "予定あり"
        case .free: return "空き"
        case .tentative: return "仮予定"
        case .unavailable: return "利用不可"
        default: return "不明"
        }
    }
    
    private func recurrenceDescription(_ rules: [EKRecurrenceRule]) -> String {
        guard let rule = rules.first else { return "なし" }
        switch rule.frequency {
        case .daily: return "毎日"
        case .weekly: return "毎週"
        case .monthly: return "毎月"
        case .yearly: return "毎年"
        @unknown default: return "不明な繰り返し"
        }
    }
}
