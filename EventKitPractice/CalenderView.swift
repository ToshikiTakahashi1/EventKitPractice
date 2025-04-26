import SwiftUI

struct ContentView: View {
    
    @State private var isEventViewPresented: Bool = false
    @State private var isEventEditViewPresented = false
    @State private var isEventListViewPresented = false
    @State private var isCUstomCreateEventViewPresented: Bool = false
    
    var body: some View {
        VStack {
            Button("EKEventViewController") {
                isEventViewPresented = true
            }
            Button("EKEventEditViewController") {
                isEventEditViewPresented = true
            }
            Button("カスタムで新規イベント作成") {
                isCUstomCreateEventViewPresented = true
            }
            Button("1ヶ月以内の予定一覧") {
                isEventListViewPresented = true
            }
        }
        .sheet(isPresented: $isEventViewPresented) {
            NavigationStack {
                EventView()
                    .navigationTitle("予定")
            }
        }
        .sheet(isPresented: $isEventEditViewPresented) {
            EventEditView()
        }
        .sheet(isPresented: $isEventListViewPresented) {
            EventListView()
        }
        .sheet(isPresented: $isCUstomCreateEventViewPresented) {
            EventCreateView()
        }
    }
}

#Preview {
    ContentView()
}
