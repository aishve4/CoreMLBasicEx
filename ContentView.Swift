//Using XCode SwiftUI

import SwiftUI
import CoreML

struct ContentView: View {

    let model = MobileNetV2()
    @State private var classificationLabel: String = ""
    
    let photos = ["img1", "img2", "img3"]
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            Image(photos[currentIndex])
                .resizable()
                .frame(width: 200, height: 200)
            HStack {
                Button("Back") {
                    if self.currentIndex >= self.photos.count {
                        self.currentIndex = self.currentIndex - 1
                    } else {
                        self.currentIndex = 0
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.gray)

                Button("Next") {
                    if self.currentIndex < self.photos.count - 1 {
                        self.currentIndex = self.currentIndex + 1
                    } else {
                        self.currentIndex = 0
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.gray)
            }
            
            Button("Classify") {
                // Add some more code here :)
                classifyImage()
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.green)

            Text(classificationLabel)
                .padding()
                .font(.body)
            Spacer()
        }
    }
    
    private func classifyImage() {
        let currentImageName = photos[currentIndex]
        
        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
              return
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            let result = results.map { (key, value) in
                return "\(key) = \(String(format: "%.2f", value * 100))%"
            }.joined(separator: "\n")

            self.classificationLabel = result
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14")
    }
}
