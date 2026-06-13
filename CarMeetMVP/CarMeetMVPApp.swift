import SwiftUI

@main
struct CarMeetMVPApp: App {
    @State private var store = MockCarSocialStore()

    var body: some Scene {
        WindowGroup {
            AppTabView(store: store)
        }
    }
}
