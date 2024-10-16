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

enum Mode: {
    case classic
    case master
    case chrono
}

enum Difficulty: Multipliers {
    case easy = Multipliers(size: 35, speed: 1.0, food: 5.0, blocks: 0.0)
    case normal = Multipliers(size: 30, speed: 0.75, food: 7.0, blocks: 0.1)
    case hard = Multipliers(size: 25, speed: 0.5, food: 10.0, blocks: 0.3)
    case extreme = Multipliers(size: 20, speed: 0.3, food: 15.0, blocks: 0.5)
}

struct Multipliers {
    var size: Int
    var speed: Float
    var food: Double
    var blocks: Double
}

struct Position {
    var x: Int
    var y: Int
}

struct SnakeView: View {
    @State var timer: Timer?

    // Game static configuration

    let minLenght: Int = 5

    // Game state configuration

    @State var rows: Int = 20
    @State var cols: Int = 20
    @State var speed: Double = 1.5

    // Game state entities

    @State var direction: Direction = .up
    @State var positions: [Position] = []
    @State var blocks:  [Position] = []
    @State var food: [Position] = []
    @State var portals: [Position] = []

    // Game scores

    @State var score: Int = 0 {
        didSet {
            if score > maxScore {
                UserDefaults.standard.setValue(score, forKey: "snake.maxScore")
                
                // Update max score & update pb flag
                maxScore = score
                isPb = true
            }
        }
    }

    @State var pb: Int = UserDefaults.standard.integer(forKey: "snake.maxScore")
    @State var isPb: Bool = false
    
    // Game alerts

    @State var isAlert: Bool = false
    @State var message: String?

    // Generator functions for blocks & food entities

    func getBlocks(_ quantity: Int) -> [Position] {
        var blocks: [Position] = []
        
        for _ in 0..<quantity {
            var position: Position
            
            repeat {
                position = Position(x: Int.random(in: 0...cols), y: Int.random(in: 0...rows))
            } while isEntity(position)

            blocks.append(position)
        }
        
        return blocks
    }

    func getFood(_ quantity: Int = 1) -> [Position] {
        var food: [Position] = []
        
        for _ in 0..<quantity {
            var position: Position
            
            repeat {
                position = Position(x: Int.random(in: 0...cols), y: Int.random(in: 0...rows))
            } while isEntity(position)
            
            food.append(position)
        }
        
        return food
    }

    // Getters for cell colors & next position cell
    
    func getColor(_ position: Position) -> Color {
        if isSnake(position) {
            return .white
        }
        
        if isBlock(position) {
            return .gray
        }
        
        if isFood(position) {
            return .red
        }

        if isPortal(position) {
            return .blue
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

    // Checkers for entities & game state

    func isSnake(_ position: Position) -> Bool {
        return positions.contains(where: { $0.x == position.x && $0.y == position.y })
    }

    func isFood(_ position: Position) -> Bool {
        return food.contains(where: { $0.x == position.x && $0.y == position.y })
    }

    func isBlock(_ position: Position) -> Bool {
        return blocks.contains(where: { $0.x == position.x && $0.y == position.y })
    }

    func isPortal(_ position: Position) -> Bool {
        return portals.contains(where: { $0.x == position.x && $0.y == position.y })
    }
    
    func isOutOfBounds(_ position: Position) -> Bool {
        return position.x < 0 || position.x > cols || position.y < 0 || position.y > rows
    }

    func isEntity(_ position: Position) -> Bool {
        return isSnake(position) || isBlock(position) || isFood(position)
    }

    func isGameOver(_ position: Position) -> Bool {
        return isSnake(position) || isBlock(position) || isOutOfBounds(position)
    }

    func isVictory() -> Bool {
        return positions.count == (cols * rows) - blocks.count
    }

    // Main game functions

    func start() {
        if timer?.isValid == true {
            timer?.invalidate()
        }

        timer = .scheduledTimer(withTimeInterval: 1 / speed, repeats: true) { _ in
            tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        
        positions = []
        blocks = []
        food = []
    }
    
    func tick() {
        guard timer?.isValid == true else {
            return
        }
            
        let next: Position = getNext()
        
        if isVictory() {
            isAlert = true
            message = "Bravo ! Vous avez gagné !"
            
            stop()
        } else if isSnake(next) {
            isAlert = true
            message = "Oups ! Vous avez mordu votre propre queue. Fin de la partie !"
            
            stop()
        } else if isBlock(next) || isOutOfBounds(next) {
            isAlert = true
            message = "Boom ! Vous avez percuté un mur ! Fin de la partie !"
            
            stop()
        } else {
            if !isFood(next) {
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
                                    .foregroundColor(getColor(Position(x: column, y: row)))
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
            
            Text(timer?.isValid == true ? "Playing" : "Waiting")
            
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
