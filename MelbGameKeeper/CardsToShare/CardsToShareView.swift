//
//  CardsToShareView.swift
//  MelbGameKeeper
//
//  Created by D K on 05.03.2025.
//

import SwiftUI

struct CardsToShareView: View {
    
    var cards: [Card]
    
    @State var imageToShare: UIImage?
    @State var isSnapshotShown = false
    @State var showImageSheet = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.bgSoftBlue)
            
            if !showImageSheet {
                VStack {
                    
                    Text("All Cards")
                        .foregroundStyle(.white)
                        .font(.system(size: 28, weight: .thin))
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 50)
                        .shadow(color: .semiYellow, radius: 100)
                        .frame(width: size().width)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100)), GridItem(.adaptive(minimum: 100)), GridItem(.adaptive(minimum: 100))], spacing: 16) {
                            ForEach(cards, id: \.id) { card in
                                CardView(card: card)
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .overlay {
            if let image = imageToShare {
                ScrollView {
                    Image(uiImage: image)
                        .onAppear {
                            showImageSheet.toggle()
                        }
                }
            }
        }
        
    }
}

#Preview {
    CardsToShareView(cards: Array(DataBaseManager.shared.MOCK().allCards))
}

struct ImageShareSheet: UIViewControllerRepresentable {
    let images: UIImage
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let activityViewController = UIActivityViewController(activityItems: [images], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension View {
    func imageShareSheet(
        isPresented: Binding<Bool>,
        image: UIImage
    ) -> some View {
        return sheet(isPresented: isPresented, content: { ImageShareSheet(images: image) } )
    }
}

