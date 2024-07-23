import SwiftUI
import WebKit
import AVFoundation

struct CustomWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

class AudioPlayer: ObservableObject {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    init() {
        startStreaming()
    }
    
    func startStreaming() {
        guard let url = URL(string: "http://172.20.10.2:8000/audio") else { return }
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}





