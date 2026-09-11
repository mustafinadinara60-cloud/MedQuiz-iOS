import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var resultStore: ResultStore

    var body: some View {
        Group {
            if resultStore.results.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 55))
                        .foregroundStyle(.secondary)

                    Text("История пока пуста")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Пройдите любой тест, и результат появится здесь.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List {
                    ForEach(resultStore.results) { result in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(result.topic)
                                    .font(.headline)

                                Spacer()

                                Text("\(result.score)/\(result.total)")
                                    .font(.headline)
                            }

                            Text(
                                result.date.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }

                    Section {
                        Button("Очистить историю", role: .destructive) {
                            resultStore.clearResults()
                        }
                    }
                }
            }
        }
        .navigationTitle("История")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .environmentObject(ResultStore())
}
