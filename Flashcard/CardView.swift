//
//  CardView.swift
//  Flashcard
//
//  Created by Lou-Michael Salvant on 10/2/24.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    private let swipeThreshold: Double = 200
    
    @State private var isShowingQuestion = true
    @State private var offset: CGSize = .zero // <-- A state property to store the offset
    
    var body: some View {
        ZStack {
            
            // Card background
            ZStack {
                // Back-most card background
                RoundedRectangle(cornerRadius: 25.0) // <-- Add another card background behind the original
                    .fill(offset.width < 0 ? .red : .green) // <-- Set fill based on offset (swipe left vs right)

                // Front-most card background (i.e. original background)
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(isShowingQuestion ? Color.blue.gradient : Color.indigo.gradient)
                    .shadow(color: .black, radius: 4, x: -2, y: 2)
                    .opacity(1 - abs(offset.width) / swipeThreshold) // <-- Fade out front-most background as user swipes
                
            }

            VStack(spacing: 20) {

                // Card type (question vs answer)
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()

                // Separator
                Rectangle()
                    .frame(height: 1)

                // Card text
                Text(isShowingQuestion ? card.question : card.answer)            }
            .font(.title)
            .foregroundStyle(.white)
            .padding()
        }
        .frame(width: 300, height: 500)
        .onTapGesture {
            isShowingQuestion.toggle()
        }
        .opacity(3 - abs(offset.width) / swipeThreshold * 3)
        .rotationEffect(.degrees(offset.width / 20.0))
        .offset(CGSize(width: offset.width, height: 0))
        .gesture(DragGesture()
            .onChanged { gesture in
                let translation = gesture.translation
                print(translation)
                offset = translation // <-- update the state offset property as the gesture translation changes
            }
        )
    }
}

// Card data model
struct Card {
    let question: String
    let answer: String
    
    static let mockedCards = [
            Card(question: "Located at the southern end of Puget Sound, what is the capitol of Washington?", answer: "Olympia"),
            Card(question: "Which city serves as the capital of Texas?", answer: "Austin"),
            Card(question: "What is the capital of New York?", answer: "Albany"),
            Card(question: "Which city is the capital of Florida?", answer: "Tallahassee"),
            Card(question: "What is the capital of Colorado?", answer: "Denver")
        ]
}

#Preview {
    CardView(card: Card(
        question: "Located at the southern end of Puget Sound, what is the capitol of Washington?",
        answer: "Olympia"))
}
