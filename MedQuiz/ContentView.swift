import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var resultStore: ResultStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    Text("MedQuiz")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Выберите тему для тренировки")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // Статистика
                    HStack(spacing: 12) {
                        statCard(
                            title: "Тестов",
                            value: "\(resultStore.results.count)"
                        )

                        statCard(
                            title: "Средний",
                            value: averageScore
                        )

                        statCard(
                            title: "Лучший",
                            value: bestScore
                        )
                    }

                    NavigationLink {
                        PathologyQuizView()
                    } label: {
                        topicCard(
                            title: "Патанатомия",
                            icon: "cross.case.fill"
                        )
                    }

                    NavigationLink {
                        CardiologyQuizView()
                    } label: {
                        topicCard(
                            title: "Кардиология",
                            icon: "heart.fill"
                        )
                    }

                    NavigationLink {
                        PharmacologyQuizView()
                    } label: {
                        topicCard(
                            title: "Фармакология",
                            icon: "pills.fill"
                        )
                    }

                    NavigationLink {
                        HistoryView()
                    } label: {
                        topicCard(
                            title: "История результатов",
                            icon: "clock.arrow.circlepath"
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Главная")
        }
    }

    // Карточка темы
    private func topicCard(
        title: String,
        icon: String
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)

            Text(title)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // Карточка статистики
    private func statCard(
        title: String,
        value: String
    ) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // Средний результат
    private var averageScore: String {
        guard !resultStore.results.isEmpty else {
            return "—"
        }

        let percentages = resultStore.results.map { result in
            Double(result.score) / Double(result.total)
        }

        let average =
            percentages.reduce(0, +)
            / Double(percentages.count)

        return "\(Int((average * 100).rounded()))%"
    }

    // Лучший результат
    private var bestScore: String {
        guard let best = resultStore.results
            .map({
                Double($0.score) / Double($0.total)
            })
            .max()
        else {
            return "—"
        }

        return "\(Int((best * 100).rounded()))%"
    }
}

#Preview {
    ContentView()
        .environmentObject(ResultStore())
}
