import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var resultStore: ResultStore

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 26) {

                        heroSection

                        statsSection

                        sectionHeader(
                            title: "Дисциплины",
                            subtitle: "Выберите тему для тренировки"
                        )

                        NavigationLink {
                            PathologyQuizView()
                        } label: {
                            subjectCard(
                                title: "Патанатомия",
                                subtitle: "Морфология и механизмы заболеваний",
                                icon: "cross.case.fill",
                                color: AppTheme.pathology
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            CardiologyQuizView()
                        } label: {
                            subjectCard(
                                title: "Кардиология",
                                subtitle: "Сердце, ЭКГ и неотложные состояния",
                                icon: "heart.fill",
                                color: AppTheme.cardiology
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            PharmacologyQuizView()
                        } label: {
                            subjectCard(
                                title: "Фармакология",
                                subtitle: "Препараты и механизмы действия",
                                icon: "pills.fill",
                                color: AppTheme.pharmacology
                            )
                        }
                        .buttonStyle(.plain)

                        sectionHeader(
                            title: "Активность",
                            subtitle: "Следите за своими результатами"
                        )

                        NavigationLink {
                            HistoryView()
                        } label: {
                            historyCard
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .topTrailing) {

            LinearGradient(
                colors: [
                    AppTheme.primary,
                    AppTheme.secondary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 180, height: 180)
                .offset(x: 65, y: -70)

            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 110, height: 110)
                .offset(x: 20, y: 120)

            VStack(alignment: .leading, spacing: 18) {

                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("MEDQUIZ")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundStyle(.white.opacity(0.75))

                        Text("Тренируй знания")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.16))
                            .frame(width: 54, height: 54)

                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }

                Text("Короткие медицинские тесты,\nкоторые помогают запоминать.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.80))

                HStack(spacing: 10) {
                    heroBadge(
                        icon: "checkmark.circle.fill",
                        text: "\(resultStore.results.count) попыток"
                    )

                    heroBadge(
                        icon: "chart.line.uptrend.xyaxis",
                        text: averageScore
                    )
                }
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
        )
        .shadow(
            color: AppTheme.primary.opacity(0.20),
            radius: 20,
            y: 10
        )
    }

    private func heroBadge(
        icon: String,
        text: String
    ) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)

            Text(text)
                .fontWeight(.semibold)
        }
        .font(.caption)
        .foregroundStyle(.white)
        .padding(.horizontal, 11)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.14))
        .clipShape(Capsule())
    }

    private var statsSection: some View {
        HStack(spacing: 12) {
            statCard(
                icon: "checkmark.seal.fill",
                value: "\(resultStore.results.count)",
                title: "Тестов",
                color: AppTheme.primary
            )

            statCard(
                icon: "chart.bar.fill",
                value: averageScore,
                title: "Средний",
                color: AppTheme.secondary
            )

            statCard(
                icon: "trophy.fill",
                value: bestScore,
                title: "Лучший",
                color: AppTheme.history
            )
        }
    }

    private func statCard(
        icon: String,
        value: String,
        title: String,
        color: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 9) {
            Image(systemName: icon)
                .foregroundStyle(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 19,
                style: .continuous
            )
        )
    }

    private func sectionHeader(
        title: String,
        subtitle: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func subjectCard(
        title: String,
        subtitle: String,
        icon: String,
        color: Color
    ) -> some View {

        let progress = bestScore(for: title)

        return VStack(alignment: .leading, spacing: 15) {

            HStack(spacing: 14) {

                ZStack {
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                    .fill(color.opacity(0.12))
                    .frame(width: 54, height: 54)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.tertiary)
            }

            if progress > 0 {
                VStack(spacing: 7) {
                    HStack {
                        Text("Лучший результат")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("\(Int((progress * 100).rounded()))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(color)
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(color.opacity(0.10))

                            Capsule()
                                .fill(color)
                                .frame(
                                    width: geometry.size.width * progress
                                )
                        }
                    }
                    .frame(height: 7)
                }
            } else {
                HStack(spacing: 6) {
                    Circle()
                        .fill(color.opacity(0.45))
                        .frame(width: 6, height: 6)

                    Text("Ещё не проходили")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(17)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 23,
                style: .continuous
            )
        )
    }

    private var historyCard: some View {
        HStack(spacing: 14) {

            ZStack {
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(AppTheme.history.opacity(0.12))
                .frame(width: 54, height: 54)

                Image(systemName: "clock.arrow.circlepath")
                    .font(.title2)
                    .foregroundStyle(AppTheme.history)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("История результатов")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Предыдущие попытки и результаты")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.tertiary)
        }
        .padding(17)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 23,
                style: .continuous
            )
        )
    }

    private var averageScore: String {
        guard !resultStore.results.isEmpty else {
            return "—"
        }

        let values = resultStore.results.map {
            Double($0.score) / Double($0.total)
        }

        let average =
            values.reduce(0, +)
            / Double(values.count)

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
        resultStore.results
            .filter {
                $0.topic == topic
            }
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
