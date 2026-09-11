import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Text("MedQuiz")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Выберите тему для тренировки")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                NavigationLink {
                    PathologyQuizView()
                } label: {
                    topicCard(
                        title: "Патанатомия",
                        icon: "cross.case.fill"
                    )
                }

                NavigationLink {
                    Text("Здесь будут вопросы по кардиологии")
                        .font(.title2)
                        .padding()
                } label: {
                    topicCard(
                        title: "Кардиология",
                        icon: "heart.fill"
                    )
                }

                NavigationLink {
                    Text("Здесь будут вопросы по фармакологии")
                        .font(.title2)
                        .padding()
                } label: {
                    topicCard(
                        title: "Фармакология",
                        icon: "pills.fill"
                    )
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Главная")
        }
    }

    private func topicCard(title: String, icon: String) -> some View {
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
}

#Preview {
    ContentView()
}
