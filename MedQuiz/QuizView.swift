import SwiftUI

struct QuizView: View {
    let title: String
    let questions: [QuizQuestion]

    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var quizFinished = false

    var body: some View {
        VStack(spacing: 24) {
            if quizFinished {
                resultView
            } else {
                quizView
            }
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var quizView: some View {
        VStack(spacing: 20) {

            Text("Вопрос \(currentQuestion + 1) из \(questions.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ProgressView(
                value: Double(currentQuestion + 1),
                total: Double(questions.count)
            )

            Text(questions[currentQuestion].text)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.vertical)

            ForEach(
                questions[currentQuestion].answers.indices,
                id: \.self
            ) { index in

                Button {
                    chooseAnswer(index)
                } label: {
                    HStack {
                        Text(questions[currentQuestion].answers[index])

                        Spacer()

                        if selectedAnswer == index {
                            Image(
                                systemName: isCorrect(index)
                                ? "checkmark.circle.fill"
                                : "xmark.circle.fill"
                            )
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(answerBackground(index))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )
                }
                .buttonStyle(.plain)
                .disabled(selectedAnswer != nil)
            }

            if let selectedAnswer {
                VStack(alignment: .leading, spacing: 8) {

                    Text(
                        isCorrect(selectedAnswer)
                        ? "Правильно!"
                        : "Неправильно"
                    )
                    .font(.headline)

                    Text(questions[currentQuestion].explanation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
            }

            if selectedAnswer != nil {
                Button {
                    nextQuestion()
                } label: {
                    Text(
                        currentQuestion == questions.count - 1
                        ? "Показать результат"
                        : "Следующий вопрос"
                    )
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
    }

    private var resultView: some View {
        VStack(spacing: 20) {

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 70))

            Text("Тест завершён!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(score) из \(questions.count)")
                .font(.title)

            Text(resultMessage)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Пройти ещё раз") {
                restartQuiz()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func chooseAnswer(_ index: Int) {
        selectedAnswer = index

        if isCorrect(index) {
            score += 1
        }
    }

    private func isCorrect(_ index: Int) -> Bool {
        index == questions[currentQuestion].correctAnswer
    }

    private func answerBackground(_ index: Int) -> Color {
        guard let selectedAnswer else {
            return Color(.secondarySystemBackground)
        }

        if index == questions[currentQuestion].correctAnswer {
            return Color.green.opacity(0.25)
        }

        if index == selectedAnswer {
            return Color.red.opacity(0.25)
        }

        return Color(.secondarySystemBackground)
    }

    private func nextQuestion() {
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
            selectedAnswer = nil
        } else {
            quizFinished = true
        }
    }

    private func restartQuiz() {
        currentQuestion = 0
        selectedAnswer = nil
        score = 0
        quizFinished = false
    }

    private var resultMessage: String {
        let percentage = Double(score) / Double(questions.count)

        if percentage == 1 {
            return "Отличный результат!"
        } else if percentage >= 0.6 {
            return "Хорошо! Но некоторые темы стоит повторить."
        } else {
            return "Стоит ещё немного повторить материал."
        }
    }
}

#Preview {
    NavigationStack {
        QuizView(
            title: "Тест",
            questions: [
                QuizQuestion(
                    text: "Тестовый вопрос?",
                    answers: [
                        "Ответ 1",
                        "Ответ 2",
                        "Ответ 3",
                        "Ответ 4"
                    ],
                    correctAnswer: 0,
                    explanation: "Это тестовое объяснение."
                )
            ]
        )
    }
}
