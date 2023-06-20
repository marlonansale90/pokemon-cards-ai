import SwiftUI
import Vision
import UIKit

struct CardCheckerView: View {
    @ObservedObject var cardCheckerViewModel: CardCheckerViewModel = CardCheckerViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(uiImage: cardCheckerViewModel.imageSelected)
            Button("Scan", action: cardCheckerViewModel.scanResult)
                .padding()
            Text(cardCheckerViewModel.results)
        }
        .padding()
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .topLeading)
    }
}

#Preview {
    CardCheckerView()
}
