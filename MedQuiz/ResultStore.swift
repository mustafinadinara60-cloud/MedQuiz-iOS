import Foundation
import Combine

final class ResultStore: ObservableObject {

    @Published var results: [QuizResult] = [] {
        didSet {
            saveResults()
        }
    }

    private let storageKey = "quizResults"

    init() {
        loadResults()
    }

    func addResult(topic: String, score: Int, total: Int) {
        let result = QuizResult(
            topic: topic,
            score: score,
            total: total
        )

        results.insert(result, at: 0)
    }

    func clearResults() {
        results.removeAll()
    }

    private func saveResults() {
        guard let data = try? JSONEncoder().encode(results) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func loadResults() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let savedResults = try? JSONDecoder().decode(
                [QuizResult].self,
                from: data
            )
        else {
            return
        }

        results = savedResults
    }
}
