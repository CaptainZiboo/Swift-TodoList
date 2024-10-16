//
//  SnakeView.swift
//  TodoList
//
//  Created by POYART Lucas on 16/10/2024.
//

import SwiftUI

enum Direction: String {
    case left = "left"
    case right = "right"
    case up = "up"
    case down = "down"
}

struct Position {
    var x: Int
    var y: Int
}

struct SnakeView: View {
    @State var direction: Direction = .up
    @State var positions: [Position] = []
    @State var blocks:  [Position] = []
    @State var food: [Position] = []
    
    @State var rows: Int = 20
    @State var cols: Int = 20
    
    let minLenght: Int = 5
    
    @State var playing: Bool = true
    
    @State var timer: Timer?
    
    @State var maxScore: Int = UserDefaults.standard.integer(forKey: "snake.maxScore")
    @State var score: Int = 0 {
        didSet {
            if score > maxScore {
                UserDefaults.standard.setValue(score, forKey: "snake.maxScore")
                
                // Update max score
                maxScore = score
            }
        }
    }
    
    @State var isAlert: Bool = false
    @State var message: String?
    
    func start() {
        timer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            tick()
        })
    }
    
    func stop() {
        timer?.invalidate()
        
        positions = []
        blocks = []
        food = []
    }
    
    func getColor(_ row: Int, _ col: Int) -> Color {
        if positions.contains(where: { $0.x == col && $0.y == row }) {
            return .white
        }
        
        if blocks.contains(where: { $0.x == col && $0.y == row }) {
            return .gray
        }
        
        if food.contains(where: { $0.x == col && $0.y == row }) {
            return .red
        }
        
        return .black
    }
    
    func getNext() -> Position {
        guard var last = positions.first else {
            return Position(x: cols/2, y: cols/2)
        }
        
        switch direction {
            case .left:
                last.x += -1
            case .right:
                last.x += 1
            case .up:
                last.y += -1
            case .down:
                last.y += 1
        }
        
        return last
    }
    
    func isOutOfBounds(_ position: Position) -> Bool {
        return position.x < 0 || position.x > cols || position.y < 0 || position.y > rows
    }
    
    func tick() {
        
        guard timer?.isValid == true else {
            return
        }
            
        let next: Position = getNext()
        
        print(positions)
        print(next)
        
        
        if positions.contains(where: { $0.x == next.x && $0.y == next.y }) {
            isAlert = true
            message = "EatYourself"
            
            stop()
        } else if blocks.contains(where: { $0.x == next.x && $0.y == next.y }) {
            isAlert = true
            message = "HitBlock"
            
            stop()
        } else if isOutOfBounds(next) {
            isAlert = true
            message = "OffLimits"
            
            stop()
        } else {
            if !food.contains(where: { $0.x == next.x && $0.y == next.y }) && positions.count >= minLenght {
                if positions.count > 0 {
                    positions.removeLast()
                }
            }
            
            positions.insert(next, at: 0)
            
            score += 1
            
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let size = min(geometry.size.width / CGFloat(cols+1), geometry.size.height / CGFloat(rows+1))
                
                VStack (spacing: 0) {
                    ForEach(0...rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0...cols, id: \.self) { column in
                                Rectangle()
                                    .foregroundColor(getColor(row, column))
                                    .border(.white)
                                    .frame(width: size, height: size)
                            }
                        }
                    }
                }
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        switch(value.translation.width, value.translation.height) {
                            case (...0, -30...30):
                                direction = .left
                            case (0..., -30...30):
                                direction = .right
                            case (-100...100, ...0):
                                direction = .up
                            case (-100...100, 0...):
                                direction = .down
                            default:
                                break
                        }
                    }
                )
            }
            
            Text(timer?.isValid == true ? "Jeu en cours" : "Joue batard")
            
            Button("Jouer") {
                start()
            }
            
            Button("Rejouer") {
                
            }
            
            HStack {
                Text("Score : \(score) | Meilleur score : \(maxScore)")
                Text("")
            }
        }
        .alert(isPresented: $isAlert) {
            Alert(title: Text(message ?? "Vous avez perdu"), message: Text("Score : \(score)"), dismissButton: Alert.Button.default(Text("OK")) {
                    score = 0
                }
            )
        }
    }
}

#Preview {
    SnakeView()
}
