import SwiftUI

struct PathologyQuizView: View {
    var body: some View {
        QuizView(
            title: "Патанатомия",
            questions: pathologyQuestions
        )
    }
}

#Preview {
    NavigationStack {
        PathologyQuizView()
    }
}
