import SwiftUI

@main
struct SpitefulApp: App {
    @StateObject private var store = Store()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .task { store.requestNotifications() }
        }
    }
}

struct RootView: View {
    var body: some View {
        TabView {
            SwipeDeckView()
                .tabItem { Label("Swipe", systemImage: "flame.fill") }
            DuelsView()
                .tabItem { Label("Duels", systemImage: "bolt.fill") }
            RivalsView()
                .tabItem { Label("Rivals", systemImage: "person.2.fill") }
        }
        .tint(.orange)
    }
}
