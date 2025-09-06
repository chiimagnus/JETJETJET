import SwiftUI

struct RecordingStatusBarView: View {
    let isRecording: Bool

    @State private var isBlinking = false
    
    var body: some View {
        NavigationHeaderView(titleType: .jetting)
    }
}

#Preview {
    VStack(spacing: 20) {
        RecordingStatusBarView(isRecording: true)
        RecordingStatusBarView(isRecording: false)
    }
    .preferredColorScheme(.dark)
    .padding()
}
