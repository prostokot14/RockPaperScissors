//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Антон Кашников on 31.07.2021.
//
import SwiftUI
// The structure changes the style of the button. When the button is pressed, it increases
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("ButtonColor"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct ContentView: View {
    @State private var moves = ["Rock ✊", "Paper ✋", "Scissors ✌️"] // Move's variants
    @State private var currentChoice = Int.random(in: 0 ... 2) // The app’s current move's choice
    @State private var shouldWin = Bool.random() // Whether the player should win or lose.
    @State private var score: UInt8 = 0
    @State private var endGame = false
    var body: some View {
        ZStack {
            VStack {
                Text("The player’s score is \(score)").padding().font(.title)
                Text("The app’s move is \(moves[currentChoice])").padding().font(.title)
                if shouldWin {
                    Text("The player should win").padding().font(.title)
                } else {
                    Text("The player should lose").padding().font(.title)
                }
                ForEach(0 ..< 3) { choice in
                    Button(action: {
                        if score < 10 { // The game ends after 10 questions
                            buttonTapped(choice)
                            newGame()
                        }
                    }, label: {
                        Text("\(moves[choice])").font(.title).fontWeight(.bold)
                    }).buttonStyle(GrowingButton())
                }
                Spacer()
            }
        }.alert(isPresented: $endGame, content: {
            Alert(title: Text("The game is end"), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                score = 0
                newGame()
            })
        })
    }
    enum Result {
        case winning, draw, losing
    }
    func buttonTapped(_ choice: Int) {
        let result = isBeat(choice)
        if shouldWin { // If player should win the app
            if score > 0 {
                switch result {
                case .winning:
                    score += 1
                default:
                    score -= 1
                }
            } else {
                score = result == .winning ? score + 1 : 0
            }
        } else { // If player should lose to the app
            if score > 0 {
                switch result {
                case .losing:
                    score += 1
                default:
                    score -= 1
                }
            } else {
                score = result == .losing ? score + 1 : 0
            }
        }
        if score == 10 {
            endGame = true
        }
    }
    // Does your choice beat the choice of the application
    func isBeat(_ choice: Int) -> Result {
        var newIndex = choice
        if newIndex == currentChoice {
            return .draw
        }
        newIndex = newIndex == 0 ? 3 : newIndex
        if newIndex == currentChoice + 1 {
            return .winning
        } else {
            return .losing
        }
    }
    func newGame() {
        currentChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
