import SwiftUI

@main
struct MedQuizApp: App {

    @StateObject private var resultStore = ResultStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(resultStore)
        }
    }
}
