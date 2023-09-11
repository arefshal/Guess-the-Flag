//
//  ContentView.swift
//  guess the flag
//
//  Created by Aref on 9/10/23.
//

import SwiftUI
struct FlagImage: View {
    var country: String

    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var score = 0
    @State private var textColor: Color = .white

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var questionCount = 0
    @State private var isGameFinished = false

    var body: some View {
        ZStack{
            RadialGradient(stops: [.init(color: Color(red:0.1,green: 0.2,blue:0.45), location: 0.3),.init(color: Color(red:0.76,green: 0.15,blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                if !isGameFinished {
                    VStack(spacing:15){
                        VStack{
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                            
                        }
                        ForEach(0..<3) { number in
                            Button{
                                flagTapped(number)
                            }label: {
                                FlagImage(country: countries[number])
                            }
                            
                        }
                        
                    }
                    
                    .frame(maxWidth:.infinity)
                    .padding(.vertical,20)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                } else {
                    Text("Game Over!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    Text("Your score is: \(score)")
                        .font(.title)
                        .foregroundColor(textColor)
                        .padding()
                    Button("Restart Game") {
                        restartGame()
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                }
            }
            .padding()
            .alert(scoreTitle, isPresented: $showingScore)  {
                if questionCount < 8 {
                    Button("Next Question", action: askQuestion)
                } else {
                    Button("Finish", action: finishGame)
                }
            } message: {
                Text(scoreTitle)
                    .foregroundColor(textColor)
                    .font(.title)
                    .bold()
            }
        }
        .ignoresSafeArea()
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            textColor = .green // Set text color to green for correct answers
        } else {
            scoreTitle = "Wrong"
            textColor = .red // Set text color to red for wrong answers
            let correctCountry = countries[correctAnswer]
            scoreTitle += "\nThat's the flag of \(correctCountry)"
        }
        showingScore = true
        questionCount += 1
        if questionCount == 8 {
            isGameFinished = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func finishGame() {
        isGameFinished = true
    }
    
    func restartGame() {
        score = 0
        questionCount = 0
        isGameFinished = false
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
