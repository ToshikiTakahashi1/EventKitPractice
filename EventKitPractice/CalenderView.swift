import SwiftUI

struct ContentView: View {
    
    @State private var isEventViewPresented: Bool = false
    @State private var isEventEditViewPresented = false
    
    var body: some View {
        VStack {
            Button("EKEventViewController") {
                isEventViewPresented = true
            }
            Button("EKEventEditViewController") {
                isEventEditViewPresented = true
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
    }
}

#Preview {
    ContentView()
}
