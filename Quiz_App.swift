import SwiftUI

struct Question {
    let text: String
    let answers: [String]
    let correctAnswer: Int
}

struct QuizView: View {
    let questions: [Question]
    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int?
    @Binding var score: Int // Use @Binding to pass the score from ContentView
    @Binding var quizFinished: Bool // Use @Binding to indicate if the quiz has finished
    
    var body: some View {
        VStack {
            Text(questions[currentQuestion].text)
                .font(.title)
                .padding()
            ForEach(questions[currentQuestion].answers.indices, id: \.self) { index in
                Button(action: {
                    selectedAnswer = index
                }) {
                    Text(questions[currentQuestion].answers[index])
                        .padding()
                        .foregroundColor(selectedAnswer == index ? .orange : .white)
                        .background(selectedAnswer == index ? .purple : .pink)
                        .cornerRadius(10)
                }
            }
            Button("Next") {
                if let selectedAnswer = selectedAnswer {
                    if selectedAnswer == questions[currentQuestion].correctAnswer {
                        score += 1
                    }
                    if currentQuestion < questions.count - 1 {
                        currentQuestion += 1
                        self.selectedAnswer = nil
                    } else {
                        quizFinished = true
                    }
                }
            }
            .disabled(selectedAnswer == nil)
            .padding()
            Spacer()
        }
        .padding()
    }
}

struct QuizDetails: View {
    let score: Int
    let totalQuestions: Int
    
    var body: some View {
        VStack {
            Text("You scored \(score) out of \(totalQuestions)!")
                .font(.title)
                .padding()
            Button("Restart") {
                // Reset the quiz
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}

struct ContentView: View {
    let questions = [
        Question(text: "In Snooker 8 points refers to which coloured ball?", answers: ["Blue", "Black", "Pink"], correctAnswer: 0),
        Question(text: "What is the Capital of the India?", answers: ["Kolkata", "Delhi", "Mumbai"], correctAnswer: 1),
        Question(text: "Name the German breed of the Dog?", answers: ["German Shepherd", "Pug", "Golden Retriever"], correctAnswer: 0)
    ]
    @State private var quizStarted = false
    @State private var quizFinished = false
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if quizStarted {
                    if quizFinished {
                        QuizDetails(score: score, totalQuestions: questions.count)
                    } else {
                        QuizView(questions: questions, score: $score, quizFinished: $quizFinished)
                    }
                } else {
                    Text("Let's start the Quiz!")
                        .font(.title)
                        .padding()
                    Button("Start") {
                        quizStarted = true
                    }
                    .padding()
                }
                Spacer()
            }
            .frame(minWidth: 400, minHeight: 300) // Specify a minimum size for the content view
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Quiz") // Use a custom title view in the toolbar
                        .font(.headline)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
