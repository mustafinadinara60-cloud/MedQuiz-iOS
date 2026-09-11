import SwiftUI

struct PharmacologyQuizView: View {
    var body: some View {
        QuizView(
            title: "Фармакология",
            questions: pharmacologyQuestions
        )
    }
}

#Preview {
    NavigationStack {
        PharmacologyQuizView()
    }
}
