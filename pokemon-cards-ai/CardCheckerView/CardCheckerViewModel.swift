import Foundation
import SwiftUI
import UIKit
import Vision

final class CardCheckerViewModel: ObservableObject {
    
    @Published
    var imageSelected: UIImage = UIImage(named: "test_pokemon_card")!
    
    @Published var results: String = ""
    
    var textDetectionRequest: VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest( completionHandler: { (request, error) in
            if let detectError = error as NSError? {
                print(detectError)
                return
            } else {
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                
                print(observations)
                
                let recognizedStrings = observations.compactMap { observation in
                        // Return the string of the top VNRecognizedText instance.
                        return observation.topCandidates(1).first?.string
                    }
                    
                DispatchQueue.main.async {
                    self.results = recognizedStrings[1]
                    debugPrint(recognizedStrings)
                }
              
            }
        })
        
        
        return request
    }
    
 
    
    func scanResult() {
        guard let cgImage = imageSelected.cgImage else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                        orientation: imageSelected.cgOrientation,
                                                        options: [:])
        let requests = [ textDetectionRequest]
        // Send the requests to the request handler.
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
                return
            }
        }
    }
    
    
}

extension UIImage {
    var cgOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up : return .up
        case .upMirrored: return .upMirrored
        case .down: return .down // 0th row at bottom, 0th column on right  - 180 deg rotation
        case .downMirrored : return .downMirrored// 0th row at bottom, 0th column on left   - vertical flip
        case .leftMirrored : return .leftMirrored // 0th row on left,   0th column at top
        case .right : return .right // 0th row on right,  0th column at top    - 90 deg CW
        case .rightMirrored : return .rightMirrored // 0th row on right,  0th column on bottom
        case .left : return .left // 0th row on left,   0th column at bottom - 90 deg CCW
        }
    }
}
