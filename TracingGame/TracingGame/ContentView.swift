import SwiftUI

struct ContentView: View {
    @State private var isPlaying = false

    var body: some View {
        if isPlaying {
            TracingView(isPlaying: $isPlaying)
        } else {
            VStack {
                // Game title
                Text("Tracing Game")
                    .font(.largeTitle)
                    .padding()

                // Play button
                Button(action: {
                    isPlaying = true
                }) {
                    Text("Play")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Credit line my NAME IS MUHAMMAD
                Text("By Muhammad Bokhari (19165120)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            }
        }
    }
}

// This is a Test 