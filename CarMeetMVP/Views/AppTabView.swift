import SwiftUI

struct AppTabView: View {
    let store: MockCarSocialStore

    var body: some View {
        TabView {
            NavigationStack {
                LiveMapView(store: store)
            }
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }

            NavigationStack {
                BuildsView(store: store)
            }
            .tabItem {
                Label("Builds", systemImage: "car.side.fill")
            }

            NavigationStack {
                EventsView(store: store)
            }
            .tabItem {
                Label("Meets", systemImage: "calendar")
            }

            NavigationStack {
                ProfileView(store: store, user: store.currentUser)
            }
            .tabItem {
                Label("Garage", systemImage: "person.fill")
            }
        }
    }
}

#Preview {
    AppTabView(store: MockCarSocialStore())
}
