import SwiftUI

struct ContentView: View {
    
    @State private var isEventViewPresented: Bool = false
    
    var body: some View {
        VStack {
            Button("EKEventViewController") {
                isEventViewPresented = true
            }
        }
        .sheet(isPresented: $isEventViewPresented) {
            NavigationStack {
                EventView()
                    .navigationTitle("予定")
            }
        }
    }
}

#Preview {
    ContentView()
}
