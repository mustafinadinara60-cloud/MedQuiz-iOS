import Foundation

struct QuizResult: Identifiable, Codable {
    let id: UUID
    let topic: String
    let score: Int
    let total: Int
    let date: Date

    init(topic: String, score: Int, total: Int, date: Date = Date()) {
        self.id = UUID()
        self.topic = topic
        self.score = score
        self.total = total
        self.date = date
    }
}
