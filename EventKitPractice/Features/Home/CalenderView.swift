import SwiftUI

struct ContentView: View {
    
    @State private var isEventViewPresented: Bool = false
    @State private var isEventEditViewPresented = false
    @State private var isCUstomCreateEventViewPresented: Bool = false
    
    var body: some View {
        NavigationStack {
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
                NavigationLink("📌予定リスト（1ヶ月以内）") {
                    EventListView()
                }
            }
        }
        .sheet(isPresented: $isEventViewPresented) {
            NavigationStack {
                EventView()
                    .navigationTitle("予定")
            }
        }
        .sheet(isPresented: $isEventEditViewPresented) {
            EventEditView(eventToEdit: nil, isPresented: $isEventEditViewPresented)
        }
        .sheet(isPresented: $isCUstomCreateEventViewPresented) {
            EventCreateView()
        }
    }
}

#Preview {
    ContentView()
}
