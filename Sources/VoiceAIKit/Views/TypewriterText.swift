import SwiftUI

/// A view that types out phrases one character at a time with a blinking cursor.
public struct TypewriterText: View {
    let phrases: [String]
    var cursorColor: Color

    @State private var displayedText = ""
    @State private var phraseIndex = 0
    @State private var charIndex = 0
    @State private var isDeleting = false
    @State private var showCursor = true
    @State private var timer: Timer?
    @State private var cursorTimer: Timer?

    public init(phrases: [String], cursorColor: Color = Color(red: 0.655, green: 0.545, blue: 0.980).opacity(0.5)) {
        self.phrases = phrases
        self.cursorColor = cursorColor
    }

    public var body: some View {
        HStack(spacing: 0) {
            Text(displayedText)
                .font(.system(size: 13, weight: .light))
                .foregroundColor(.white.opacity(0.35))

            Rectangle()
                .fill(cursorColor)
                .frame(width: 1, height: 14)
                .opacity(showCursor ? 1 : 0)
        }
        .frame(height: 20)
        .onAppear { startCursorBlink(); startTyping() }
        .onDisappear { timer?.invalidate(); cursorTimer?.invalidate() }
    }

    private func startCursorBlink() {
        cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            showCursor.toggle()
        }
    }

    private func startTyping() {
        guard !phrases.isEmpty else { return }
        let phrase = phrases[phraseIndex]
        timer = Timer.scheduledTimer(withTimeInterval: isDeleting ? 0.02 : 0.04, repeats: true) { t in
            if isDeleting {
                if !displayedText.isEmpty {
                    displayedText.removeLast()
                } else {
                    t.invalidate()
                    isDeleting = false
                    phraseIndex = (phraseIndex + 1) % phrases.count
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { startTyping() }
                }
            } else {
                if charIndex < phrase.count {
                    displayedText.append(phrase[phrase.index(phrase.startIndex, offsetBy: charIndex)])
                    charIndex += 1
                } else {
                    t.invalidate()
                    charIndex = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        isDeleting = true
                        startTyping()
                    }
                }
            }
        }
    }
}
