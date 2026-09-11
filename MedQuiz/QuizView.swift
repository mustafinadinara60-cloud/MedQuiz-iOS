import SwiftUI

struct QuizView: View {

    @EnvironmentObject private var resultStore: ResultStore
    @Environment(\.dismiss) private var dismiss

    let title: String
    let questions: [QuizQuestion]
    let savesResult: Bool
    let isReviewMode: Bool

    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int?
    @State private var score = 0
    @State private var quizFinished = false

    @State private var wrongQuestions: [QuizQuestion] = []
    @State private var showMistakeReview = false

    init(
        title: String,
        questions: [QuizQuestion],
        savesResult: Bool = true,
        isReviewMode: Bool = false
    ) {
        self.title = title
        self.questions = questions
        self.savesResult = savesResult
        self.isReviewMode = isReviewMode
    }

    var body: some View {
        SwiftUI.ZStack {
            AppTheme.background
                .ignoresSafeArea()

            if quizFinished {
                resultScreen
            } else {
                quizScreen
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(
            isPresented: $showMistakeReview
        ) {
            NavigationStack {
                QuizView(
                    title: title,
                    questions: wrongQuestions,
                    savesResult: false,
                    isReviewMode: true
                )
                .environmentObject(resultStore)
            }
        }
    }

    // MARK: - Quiz Screen

    private var quizScreen: some View {
        SwiftUI.VStack(spacing: 0) {

            topBar

            ScrollView(showsIndicators: false) {
                SwiftUI.VStack(
                    alignment: HorizontalAlignment.leading,
                    spacing: 22
                ) {

                    progressBlock

                    questionCard

                    answersBlock

                    if let selectedAnswer {
                        explanationCard(
                            correct: isCorrect(selectedAnswer)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }

            if selectedAnswer != nil {
                nextButton
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                    .background(AppTheme.background)
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        SwiftUI.HStack {

            Button {
                dismiss()
            } label: {
                SwiftUI.ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 44, height: 44)

                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 8,
                    y: 3
                )
            }
            .buttonStyle(.plain)

            Spacer()

            SwiftUI.VStack(spacing: 2) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(
                    isReviewMode
                    ? "Работа над ошибками"
                    : "Тренировка"
                )
                .font(.caption2)
                .foregroundStyle(.secondary)
            }

            Spacer()

            SwiftUI.ZStack {
                Circle()
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: subjectIcon)
                    .foregroundStyle(accentColor)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
    }

    // MARK: - Progress

    private var progressBlock: some View {
        SwiftUI.VStack(spacing: 10) {

            SwiftUI.HStack {
                Text(
                    "Вопрос \(currentQuestion + 1) из \(questions.count)"
                )
                .font(.subheadline)
                .fontWeight(.semibold)

                Spacer()

                Text("\(progressPercent)%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(accentColor)
            }

            GeometryReader { geometry in
                SwiftUI.ZStack(alignment: .leading) {

                    Capsule()
                        .fill(accentColor.opacity(0.10))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor,
                                    accentColor.opacity(0.70)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width:
                                geometry.size.width
                                * progress
                        )
                }
            }
            .frame(height: 8)
        }
    }

    // MARK: - Question

    private var questionCard: some View {
        SwiftUI.VStack(
            alignment: HorizontalAlignment.leading,
            spacing: 18
        ) {

            Text(
                isReviewMode
                ? "РАБОТА НАД ОШИБКОЙ"
                : "ВОПРОС"
            )
            .font(.caption2)
            .fontWeight(.bold)
            .tracking(1.5)
            .foregroundStyle(accentColor)

            Text(questions[currentQuestion].text)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .padding(22)
        .frame(
            maxWidth: .infinity,
            minHeight: 155,
            alignment: .leading
        )
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
        )
        .shadow(
            color: Color.black.opacity(0.04),
            radius: 16,
            y: 7
        )
    }

    // MARK: - Answers

    private var answersBlock: some View {
        SwiftUI.VStack(spacing: 12) {

            ForEach(
                questions[currentQuestion]
                    .answers.indices,
                id: \.self
            ) { index in

                Button {
                    selectAnswer(index)
                } label: {
                    answerCard(index)
                }
                .buttonStyle(.plain)
                .disabled(selectedAnswer != nil)
            }
        }
    }

    private func answerCard(
        _ index: Int
    ) -> some View {

        SwiftUI.HStack(spacing: 14) {

            SwiftUI.ZStack {
                Circle()
                    .fill(
                        answerBadgeBackground(index)
                    )
                    .frame(width: 40, height: 40)

                Text(answerLetter(index))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        answerBadgeColor(index)
                    )
            }

            Text(
                questions[currentQuestion]
                    .answers[index]
            )
            .font(.body)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.leading)

            Spacer(minLength: 8)

            if selectedAnswer != nil {

                if index ==
                    questions[currentQuestion]
                    .correctAnswer {

                    Image(
                        systemName:
                            "checkmark.circle.fill"
                    )
                    .font(.title3)
                    .foregroundStyle(Color.green)

                } else if index == selectedAnswer {

                    Image(
                        systemName:
                            "xmark.circle.fill"
                    )
                    .font(.title3)
                    .foregroundStyle(Color.red)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(
            maxWidth: .infinity,
            minHeight: 68
        )
        .background(
            answerBackground(index)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(
                answerBorder(index),
                lineWidth: 1.5
            )
        }
    }

    // MARK: - Explanation

    private func explanationCard(
        correct: Bool
    ) -> some View {

        SwiftUI.VStack(
            alignment: HorizontalAlignment.leading,
            spacing: 12
        ) {

            SwiftUI.HStack(spacing: 9) {

                Image(
                    systemName:
                        correct
                        ? "checkmark.seal.fill"
                        : "exclamationmark.circle.fill"
                )
                .font(.title3)
                .foregroundStyle(
                    correct
                    ? Color.green
                    : Color.red
                )

                Text(
                    correct
                    ? "Правильно"
                    : "Разберём ошибку"
                )
                .font(.headline)
            }

            Text(
                questions[currentQuestion]
                    .explanation
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .padding(18)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            correct
            ? Color.green.opacity(0.08)
            : Color.red.opacity(0.07)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 21,
                style: .continuous
            )
        )
    }

    // MARK: - Next Button

    private var nextButton: some View {
        Button {
            nextQuestion()
        } label: {

            SwiftUI.HStack {

                Text(
                    currentQuestion ==
                        questions.count - 1
                    ? "Показать результат"
                    : "Продолжить"
                )
                .fontWeight(.semibold)

                Spacer()

                Image(
                    systemName:
                        currentQuestion ==
                        questions.count - 1
                        ? "flag.checkered"
                        : "arrow.right"
                )
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                LinearGradient(
                    colors: [
                        accentColor,
                        accentColor.opacity(0.75)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Result Screen

    private var resultScreen: some View {
        ScrollView(showsIndicators: false) {

            SwiftUI.VStack(spacing: 26) {

                SwiftUI.HStack {

                    Button {
                        dismiss()
                    } label: {
                        SwiftUI.ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(
                                    width: 44,
                                    height: 44
                                )

                            Image(
                                systemName:
                                    "chevron.left"
                            )
                            .foregroundStyle(.primary)
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }

                resultRing

                SwiftUI.VStack(spacing: 8) {

                    Text(resultTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(
                        "\(score) правильных из \(questions.count)"
                    )
                    .font(.title3)
                    .foregroundStyle(.secondary)
                }

                resultSummaryCard

                resultButtons
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Result Buttons

    private var resultButtons: some View {
        SwiftUI.VStack(spacing: 12) {

            if !isReviewMode &&
                !wrongQuestions.isEmpty {

                Button {
                    showMistakeReview = true
                } label: {
                    SwiftUI.HStack {

                        Image(
                            systemName:
                                "arrow.triangle.2.circlepath"
                        )

                        Text("Работа над ошибками")
                            .fontWeight(.semibold)

                        Spacer()

                        Text("\(wrongQuestions.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 5)
                            .background(
                                Color.white.opacity(0.18)
                            )
                            .clipShape(Capsule())
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        LinearGradient(
                            colors: [
                                accentColor,
                                accentColor.opacity(0.76)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                    )
                }
                .buttonStyle(.plain)
            }

            Button {
                restartQuiz()
            } label: {

                SwiftUI.HStack {
                    Image(
                        systemName:
                            "arrow.counterclockwise"
                    )

                    Text(
                        isReviewMode
                        ? "Повторить ошибки ещё раз"
                        : "Пройти тест ещё раз"
                    )
                }
                .font(.headline)
                .foregroundStyle(accentColor)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
            }
            .buttonStyle(.plain)

            Button {
                dismiss()
            } label: {
                Text(
                    isReviewMode
                    ? "Вернуться к результату"
                    : "Вернуться к дисциплинам"
                )
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Result Ring

    private var resultRing: some View {
        SwiftUI.ZStack {

            Circle()
                .stroke(
                    accentColor.opacity(0.10),
                    lineWidth: 15
                )

            Circle()
                .trim(
                    from: 0,
                    to: finalProgress
                )
                .stroke(
                    accentColor,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            SwiftUI.VStack(spacing: 3) {

                Text("\(finalPercentage)%")
                    .font(
                        .system(
                            size: 42,
                            weight: .bold,
                            design: .rounded
                        )
                    )

                Text(
                    isReviewMode
                    ? "ошибок исправлено"
                    : "результат"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .frame(
            width: 190,
            height: 190
        )
    }

    // MARK: - Result Summary

    private var resultSummaryCard: some View {
        SwiftUI.VStack(spacing: 16) {

            SwiftUI.HStack {

                resultMetric(
                    value: "\(score)",
                    title: "Верно",
                    color: .green
                )

                Divider()
                    .frame(height: 42)

                resultMetric(
                    value:
                        "\(questions.count - score)",
                    title: "Ошибок",
                    color: .red
                )

                Divider()
                    .frame(height: 42)

                resultMetric(
                    value:
                        "\(finalPercentage)%",
                    title: "Итого",
                    color: accentColor
                )
            }

            GeometryReader { geometry in
                SwiftUI.ZStack(
                    alignment: .leading
                ) {

                    Capsule()
                        .fill(
                            accentColor.opacity(0.10)
                        )

                    Capsule()
                        .fill(accentColor)
                        .frame(
                            width:
                                geometry.size.width
                                * finalProgress
                        )
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }

    private func resultMetric(
        value: String,
        title: String,
        color: Color
    ) -> some View {

        SwiftUI.VStack(spacing: 5) {

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Logic

    private func selectAnswer(
        _ index: Int
    ) {

        guard selectedAnswer == nil else {
            return
        }

        selectedAnswer = index

        if isCorrect(index) {
            score += 1
        } else {
            wrongQuestions.append(
                questions[currentQuestion]
            )
        }
    }

    private func isCorrect(
        _ index: Int
    ) -> Bool {

        index ==
            questions[currentQuestion]
            .correctAnswer
    }

    private func nextQuestion() {

        if currentQuestion <
            questions.count - 1 {

            currentQuestion += 1
            selectedAnswer = nil

        } else {

            if savesResult {
                resultStore.addResult(
                    topic: title,
                    score: score,
                    total: questions.count
                )
            }

            quizFinished = true
        }
    }

    private func restartQuiz() {
        currentQuestion = 0
        selectedAnswer = nil
        score = 0
        quizFinished = false
        wrongQuestions = []
    }

    // MARK: - Answer Appearance

    private func answerBackground(
        _ index: Int
    ) -> Color {

        guard let selectedAnswer else {
            return Color.white
        }

        if index ==
            questions[currentQuestion]
            .correctAnswer {

            return Color.green.opacity(0.08)
        }

        if index == selectedAnswer {
            return Color.red.opacity(0.07)
        }

        return Color.white
    }

    private func answerBorder(
        _ index: Int
    ) -> Color {

        guard let selectedAnswer else {
            return Color.black.opacity(0.045)
        }

        if index ==
            questions[currentQuestion]
            .correctAnswer {

            return Color.green.opacity(0.42)
        }

        if index == selectedAnswer {
            return Color.red.opacity(0.38)
        }

        return Color.black.opacity(0.04)
    }

    private func answerBadgeBackground(
        _ index: Int
    ) -> Color {

        if selectedAnswer != nil &&
            index ==
            questions[currentQuestion]
            .correctAnswer {

            return Color.green.opacity(0.14)
        }

        if selectedAnswer == index {
            return Color.red.opacity(0.13)
        }

        return accentColor.opacity(0.10)
    }

    private func answerBadgeColor(
        _ index: Int
    ) -> Color {

        if selectedAnswer != nil &&
            index ==
            questions[currentQuestion]
            .correctAnswer {

            return .green
        }

        if selectedAnswer == index {
            return .red
        }

        return accentColor
    }

    private func answerLetter(
        _ index: Int
    ) -> String {

        let letters = [
            "A",
            "B",
            "C",
            "D",
            "E",
            "F"
        ]

        if index < letters.count {
            return letters[index]
        }

        return "\(index + 1)"
    }

    // MARK: - Subject Theme

    private var accentColor: Color {
        switch title {

        case "Патанатомия":
            return AppTheme.pathology

        case "Кардиология":
            return AppTheme.cardiology

        case "Фармакология":
            return AppTheme.pharmacology

        default:
            return AppTheme.primary
        }
    }

    private var subjectIcon: String {
        switch title {

        case "Патанатомия":
            return "cross.case.fill"

        case "Кардиология":
            return "heart.fill"

        case "Фармакология":
            return "pills.fill"

        default:
            return "brain.head.profile"
        }
    }

    // MARK: - Calculations

    private var progress: Double {
        Double(currentQuestion + 1)
        / Double(questions.count)
    }

    private var progressPercent: Int {
        Int((progress * 100).rounded())
    }

    private var finalProgress: Double {
        Double(score)
        / Double(questions.count)
    }

    private var finalPercentage: Int {
        Int((finalProgress * 100).rounded())
    }

    private var resultTitle: String {

        if isReviewMode {

            if finalProgress == 1 {
                return "Ошибки разобраны!"
            }

            if finalProgress >= 0.6 {
                return "Уже намного лучше"
            }

            return "Повторим ещё раз"
        }

        if finalProgress == 1 {
            return "Идеально!"
        }

        if finalProgress >= 0.8 {
            return "Отличная работа"
        }

        if finalProgress >= 0.6 {
            return "Хороший результат"
        }

        return "Стоит повторить"
    }
}

#Preview {
    NavigationStack {
        QuizView(
            title: "Кардиология",
            questions: [
                QuizQuestion(
                    text: "Какой ритм считается нормальным водителем ритма сердца?",
                    answers: [
                        "Синусовый",
                        "Желудочковый",
                        "Узловой",
                        "Фибрилляция предсердий"
                    ],
                    correctAnswer: 0,
                    explanation: "В норме водителем ритма является синусовый узел."
                )
            ]
        )
    }
    .environmentObject(ResultStore())
}
