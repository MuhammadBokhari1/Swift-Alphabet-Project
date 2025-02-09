import SwiftUI

struct TracingView: View {
    @Binding var isPlaying: Bool
    @State private var currentLetter: String = "A"
    @State private var penSize: CGFloat = 10
    @State private var alphabetSize: CGFloat = 200
    @State private var drawingPaths: [Path] = []
    @State private var currentPath = Path()
    @State private var penColor: Color = .blue
    @State private var penType: PenType = .solid

    let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    // Pen types
    enum PenType: String, CaseIterable {
        case solid = "Solid"
        case dashed = "Dashed"
        case dotted = "Dotted"
    }

    var body: some View {
        VStack {
            // Top bar with Quit to Main Menu button
            HStack {
                Spacer()
                Button(action: {
                    isPlaying = false // Quit to main menu
                }) {
                    HStack {
                        Image(systemName: "house.fill") // Home icon
                        Text("Quit")
                    }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()

            // Drawing area with the letter
            ZStack {
                // Letter to trace
                Text(currentLetter)
                    .font(.system(size: alphabetSize, weight: .bold, design: .rounded))
                    .foregroundColor(.black.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Drawing paths
                ForEach(drawingPaths.indices, id: \.self) { index in
                    drawingPaths[index]
                        .strokedPath(penType.strokeStyle(lineWidth: penSize))
                        .foregroundColor(penColor)
                }

                // Current drawing path
                currentPath
                    .strokedPath(penType.strokeStyle(lineWidth: penSize))
                    .foregroundColor(penColor)
            }
            .frame(height: 300)
            .background(Color.gray.opacity(0.2))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = value.location
                        if currentPath.isEmpty {
                            currentPath.move(to: point)
                        } else {
                            currentPath.addLine(to: point)
                        }
                    }
                    .onEnded { _ in
                        drawingPaths.append(currentPath)
                        currentPath = Path()
                    }
            )

            // Sliders with icons
            VStack {
                HStack {
                    Image(systemName: "pencil.tip") // Pen size icon
                        .foregroundColor(.blue)
                    Slider(value: $penSize, in: 5...50, step: 1) {
                        Text("Pen Size")
                    }
                    Text("\(Int(penSize))")
                        .frame(width: 30, alignment: .trailing)
                }

                HStack {
                    Image(systemName: "textformat.size") // Alphabet size icon
                        .foregroundColor(.blue)
                    Slider(value: $alphabetSize, in: 100...300, step: 10) {
                        Text("Alphabet Size")
                    }
                    Text("\(Int(alphabetSize))")
                        .frame(width: 30, alignment: .trailing)
                }
            }
            .padding()

            // Pen color and type buttons
            HStack {
                // Pen color picker
                Button(action: {
                    // Cycle through colors
                    let colors: [Color] = [.blue, .red, .green, .orange, .purple]
                    if let currentIndex = colors.firstIndex(of: penColor) {
                        let nextIndex = (currentIndex + 1) % colors.count
                        penColor = colors[nextIndex]
                    }
                }) {
                    HStack {
                        Image(systemName: "paintbrush.fill") // Pen color icon
                        Text("Color")
                    }
                    .padding()
                    .background(penColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Spacer()

                // Pen type picker
                Button(action: {
                    // Cycle through pen types
                    let allTypes = PenType.allCases
                    if let currentIndex = allTypes.firstIndex(of: penType) {
                        let nextIndex = (currentIndex + 1) % allTypes.count
                        penType = allTypes[nextIndex]
                    }
                }) {
                    HStack {
                        Image(systemName: "scribble") // Pen type icon
                        Text(penType.rawValue)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()

            // Buttons: Back, Clear, Continue
            HStack {
                // Back button (goes to previous letter)
                Button(action: {
                    previousLetter()
                }) {
                    HStack {
                        Image(systemName: "arrow.left") // Back icon
                        Text("Back")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Spacer()

                // Clear button
                Button(action: {
                    drawingPaths.removeAll() // Clear the canvas
                    currentPath = Path()
                }) {
                    HStack {
                        Image(systemName: "eraser.fill") // Clear icon
                        Text("Clear")
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Spacer()

                // Continue button
                Button(action: {
                    nextLetter()
                }) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "arrow.right") // Continue icon
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    // Move to the next letter
    private func nextLetter() {
        guard let currentIndex = alphabet.firstIndex(of: Character(currentLetter)) else { return }
        let nextIndex = (currentIndex + 1) % alphabet.count
        currentLetter = String(alphabet[nextIndex])
        drawingPaths.removeAll() // Clear the drawing for the next letter
        currentPath = Path()
    }

    // Move to the previous letter
    private func previousLetter() {
        guard let currentIndex = alphabet.firstIndex(of: Character(currentLetter)) else { return }
        let previousIndex = (currentIndex - 1 + alphabet.count) % alphabet.count
        currentLetter = String(alphabet[previousIndex])
        drawingPaths.removeAll() // Clear the drawing for the previous letter
        currentPath = Path()
    }
}

// Stroke style for pen types
extension TracingView.PenType {
    func strokeStyle(lineWidth: CGFloat) -> StrokeStyle {
        switch self {
        case .solid:
            return StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
        case .dashed:
            return StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, dash: [10])
        case .dotted:
            return StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, dash: [2])
        }
    }
}
