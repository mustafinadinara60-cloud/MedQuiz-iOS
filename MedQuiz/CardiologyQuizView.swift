import SwiftUI

struct CardiologyQuizView: View {
    var body: some View {
        QuizView(
            title: "Кардиология",
            questions: cardiologyQuestions
        )
    }
}

#Preview {
    NavigationStack {
        CardiologyQuizView()
    }
}
