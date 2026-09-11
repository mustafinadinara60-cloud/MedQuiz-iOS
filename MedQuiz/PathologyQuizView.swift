import SwiftUI

struct QuizQuestion {
    let text: String
    let answers: [String]
    let correctAnswer: Int
    let explanation: String
}

struct PathologyQuizView: View {

    private let questions = [
        QuizQuestion(
            text: "Как называется омертвение ткани в живом организме?",
            answers: [
                "Некроз",
                "Гипертрофия",
                "Метаплазия",
                "Регенерация"
            ],
            correctAnswer: 0,
            explanation: "Некроз — это гибель клеток и тканей в живом организме под действием повреждающего фактора."
        ),

        QuizQuestion(
            text: "Какой тип некроза наиболее характерен для инфаркта миокарда?",
            answers: [
                "Колликвационный",
                "Коагуляционный",
                "Жировой",
                "Фибриноидный"
            ],
            correctAnswer: 1,
            explanation: "При инфаркте миокарда наиболее типичен коагуляционный некроз."
        ),

        QuizQuestion(
            text: "Как называется увеличение органа за счёт увеличения размера клеток?",
            answers: [
                "Гиперплазия",
                "Атрофия",
                "Гипертрофия",
                "Дисплазия"
            ],
            correctAnswer: 2,
            explanation: "Гипертрофия — увеличение размера клеток и вследствие этого увеличение органа."
        ),

        QuizQuestion(
            text: "Что происходит при тромбоэмболии?",
            answers: [
                "Уменьшается количество эритроцитов",
                "Тромб или его часть переносится током крови",
                "Повышается образование лимфы",
                "Разрушается сосудистая стенка"
            ],
            correctAnswer: 1,
            explanation: "При тромбоэмболии тромб или его фрагмент переносится током крови и может закупорить сосуд."
        ),

        QuizQuestion(
            text: "Как называется запрограммированная гибель клетки?",
            answers: [
                "Апоптоз",
                "Некроз",
                "Дистрофия",
                "Гиперплазия"
            ],
            correctAnswer: 0,
            explanation: "Апоптоз — это регулируемая запрограммированная гибель клетки."
        )
    ]

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
        .navigationTitle("Патанатомия")
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
        PathologyQuizView()
    }
}
