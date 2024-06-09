//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dmitriy Eliseev on 22.05.2024.
//

import SwiftUI

struct CapsuleImage: View {
    
    //MARK: - PROPORTIES
    var image: String
    
    //MARK: - BODY
    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }//: BODY
}

struct BlueTitle: ViewModifier {
    
    //MARK: - BODY
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.blue)
    }//: BODY
}


//MARK: - EXTENSION
extension View {
    func blueStyle() -> some View {
        modifier(BlueTitle())
    }
}//: EXTENSION

struct ContentView: View {
    //MARK: - PROPERTIES
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Russia", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var countQuestion = 0
    @State private var showingCountQuestion = false
    @State private var flagNumber = 0
    @State private var isCorrect = false
    @State private var isOpacity = false
    @State private var isError = false
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            //LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
            //.ignoresSafeArea()
            RadialGradient(stops:[
                .init(color: Color(red: 0.3, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess  the Flag")
                    .font(.largeTitle.weight(.bold))
                //.foregroundStyle(.white)
                    .blueStyle()
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        
                            .font(.largeTitle.weight(.semibold))
                    }//: VSTACK
                    ForEach(0..<3) {number in
                        Button{
                            withAnimation {
                                flagTapped(number)
                            }
                        } label: {
                            //Image(countries[number].lowercased())
                            //.clipShape(.capsule)
                            //.shadow(radius: 5)
                            CapsuleImage(image: countries[number].lowercased())
                                .rotation3DEffect(
                                    .degrees(isCorrect && flagNumber == number ? 360 : 0),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                                .opacity(isOpacity && flagNumber != number ? 0.25 : 1)
                                .scaleEffect(isError && flagNumber == number ? 0.3 : 1)
                        }
                    }
                }//: VSTACK
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .blueStyle()
                //.foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }//: VSTACK
            .padding()
        }//: ZSTACK
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Eight questions complite.", isPresented: $showingCountQuestion) {
            Button("Delite score and try again?", action: resetGame)
        } message: {
            Text("Your score is \(score)")
        }
    }//: BODY
    
    func flagTapped(_ number: Int){
        flagNumber = number
        if number == correctAnswer {
            isCorrect = true
            isOpacity = true
            scoreTitle = "Correct"
            score += 1
        } else {
            isError = true
            isOpacity = true
            scoreTitle = "Wrong it is the \(countries[number]) flag"
            if score > 0 {
                score -= 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            showingScore = true
        })
        countQuestion += 1
    }
    
    func askQuestion(){
        if countQuestion > 7 {
            showingCountQuestion = true
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isCorrect = false
        isOpacity = false
        isError = false
    }
    
    func resetGame(){
        score = 0
        countQuestion = 0
        askQuestion()
    }
}

//MARK: - PREVIEW
#Preview {
    ContentView()
}
