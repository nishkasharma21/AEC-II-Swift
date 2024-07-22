import SwiftUI
import Combine

struct VideoStreamView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        // Start the video stream
        context.coordinator.startStream(for: imageView, from: url)
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: VideoStreamView?
        var task: URLSessionDataTask?
        var data = Data()

        init(_ parent: VideoStreamView) {
            self.parent = parent
        }

        func startStream(for imageView: UIImageView, from url: URL) {
            let session = URLSession(configuration: .default)
            task = session.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, error == nil, let data = data else { return }

                self.processStream(data: data, imageView: imageView)
            }
            task?.resume()
        }

        func processStream(data: Data, imageView: UIImageView) {
            self.data.append(data)
            
            while let range = self.data.range(of: Data("\r\n--frame\r\nContent-Type: image/jpeg\r\n\r\n".utf8)) {
                let frameStartIndex = range.upperBound
                guard let frameEndIndex = self.data.range(of: Data("\r\n--frame\r\n".utf8), options: [], in: frameStartIndex..<self.data.endIndex)?.lowerBound else {
                    // If no end boundary found, we need more data
                    break
                }
                
                let frameData = self.data.subdata(in: frameStartIndex..<frameEndIndex)
                if let image = UIImage(data: frameData) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
                
                self.data.removeSubrange(..<frameEndIndex)
            }
        }

        func stopStream() {
            task?.cancel()
            task = nil
        }

        deinit {
            stopStream()
        }
    }
}
