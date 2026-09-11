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

                    // Общая статистика
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

                    // Патанатомия
                    NavigationLink {
                        PathologyQuizView()
                    } label: {
                        topicCard(
                            title: "Патанатомия",
                            icon: "cross.case.fill"
                        )
                    }

                    // Кардиология
                    NavigationLink {
                        CardiologyQuizView()
                    } label: {
                        topicCard(
                            title: "Кардиология",
                            icon: "heart.fill"
                        )
                    }

                    // Фармакология
                    NavigationLink {
                        PharmacologyQuizView()
                    } label: {
                        topicCard(
                            title: "Фармакология",
                            icon: "pills.fill"
                        )
                    }

                    // История
                    NavigationLink {
                        HistoryView()
                    } label: {
                        historyCard
                    }
                }
                .padding()
            }
            .navigationTitle("Главная")
        }
    }

    // MARK: - Карточка предмета

    private func topicCard(
        title: String,
        icon: String
    ) -> some View {

        let progress = bestScore(for: title)

        return VStack(alignment: .leading, spacing: 12) {

            SwiftUI.HStack {
                Image(systemName: icon)
                    .font(.title2)

                Text(title)
                    .font(.headline)

                Spacer()

                if progress > 0 {
                    Text("\(Int((progress * 100).rounded()))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Image(systemName: "chevron.right")
            }

            if progress > 0 {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Лучший результат")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ProgressView(value: progress)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // MARK: - История

    private var historyCard: some View {
        HStack {
            Image(systemName: "clock.arrow.circlepath")
                .font(.title2)

            Text("История результатов")
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

    // MARK: - Статистика

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

    private func bestScore(for topic: String) -> Double {
        let topicResults = resultStore.results.filter {
            $0.topic == topic
        }

        return topicResults
            .map {
                Double($0.score) / Double($0.total)
            }
            .max() ?? 0
    }
}

#Preview {
    ContentView()
        .environmentObject(ResultStore())
}
