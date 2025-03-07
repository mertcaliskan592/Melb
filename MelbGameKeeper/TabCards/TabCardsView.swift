//
//  TabCardsView.swift
//  MelbGameKeeper
//
//  Created by D K on 05.03.2025.
//

import SwiftUI

struct TabCardsView: View {
    
    @State private var currentNewsIndex: Int = 0
    
    var collection: RealmCollection
    @Binding var cards: [Card]
    
    var body: some View {
        ZStack {
            GeometryReader { geomentry in
                TabView(selection: $currentNewsIndex) {
                    ForEach(0..<cards.count, id: \.self) { index in
                        TabCard(card: cards[index]) {
                            
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
}


#Preview {
    TabCardsView(collection: DataBaseManager.shared.MOCK(), cards: .constant(Array(DataBaseManager.shared.MOCK().allCards)))
        .preferredColorScheme(.dark)
}


struct TabCard: View {
    
    @State private var flip = false
    @State private var flip2 = false
    
    @State private var rotation: CGFloat = 0
    
    var card: Card
    
    @State private var imageToShow = UIImage()
    @State private var cardColor: Color = .red
    
    var onDelete: () -> ()
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
    
                    Rectangle()
                        .frame(width: size().width - 60, height: size().height / 1.5)
                        .cornerRadius(12)
                        .foregroundStyle(.bgDarkBlue)
                        .overlay {
                            VStack {
                                
                                Text("Name:")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .padding(.top, 25)
                                
                                Text(card.name)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 32, weight: .thin))

                                if !card.descriptionText.isEmpty {
                                    Text("Description:")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16, weight: .ultraLight))
                                        .padding(.top, 25)
                                    Text(card.descriptionText)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 24, weight: .thin))
                                }
                                
                                
                                Text("Rarity:")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .padding(.top, 25)
                                Text(card.rarity)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24, weight: .thin))
                                
                                Spacer()
                                
                                Button {
                                    onDelete()
                                } label: {
                                    Text("Delete")
                                        .foregroundStyle(.red)
                                }
                                .padding(.bottom, 50)
                            }
                            .scaleEffect(x: -1, y: 1)
                        }
                        .zIndex(flip2 ? 1 : 0)
                    
                    Rectangle()
                        .frame(width: size().width - 60, height: size().height / 1.5)
                        .cornerRadius(12)
                        .overlay {
                            Image(uiImage: imageToShow)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size().width - 60, height: size().height / 1.5)
                                .cornerRadius(12)
                        }
                        .shadow(color: cardColor, radius: 2)
                        .shadow(color: cardColor, radius: 20)
                }
                .rotation3DEffect(.degrees(flip ? 180: 0), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation(.spring(duration: 1)) {
                        flip.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                        withAnimation(.spring(duration: 1)) {
                            flip2.toggle()
                        }
                    }
                }
            }
        }
        .onAppear {
            prepareColor()
            prepareImage()
        }
    }
    
    
    func prepareColor() {
        
        switch card.rarity {
        case "⚪️ Common": cardColor = .white
        case "🟢 Uncommon": cardColor = .green
        case "🔵 Rare": cardColor = .blue
        case "🟣 Super Rare": cardColor = .purple
        case "🔴 Ultra Rare": cardColor = .red
        case "⚫ Secret Rare": cardColor = .white
        default:
            cardColor = .blue
        }
        
    }
    
    func prepareImage() {
        if let dataImage = card.image, let image = UIImage(data: dataImage) {
            imageToShow = image
        }
    }
}
