//
//  TestView.swift
//  MelbGameKeeper
//
//  Created by D K on 03.03.2025.
//

import SwiftUI


struct GridCardsView: View {
    var collection: RealmCollection
    var viewType: String

    @Binding var cards: [Card]
    @State private var isCardAdditionShown = false
    
    var selectedCard: (Card) -> ()
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100)), GridItem(.adaptive(minimum: 100)), GridItem(.adaptive(minimum: 100))], spacing: 16) {
                // Кнопка "плюс"
                Button {
                    isCardAdditionShown.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .frame(width: 100, height: 140)
                        .background(RadialGradient(colors: [.darkBlue, .semiBlue], center: .center, startRadius: 100, endRadius: 0))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Карточки
                ForEach(cards, id: \.id) { card in
                    Button {
                        selectedCard(card)
                    } label: {
                        CardView(card: card)
                    }
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isCardAdditionShown) {
            AddCardView(collection: collection, viewType: viewType)
                .onDisappear {
                    getAllCards()
                }
        }
    }
    
    func getAllCards() {
        switch viewType {
        case "all":
            cards = Array(collection.allCards)
        case "wish":
            cards = Array(collection.wishList)
        case "change":
            cards = Array(collection.readyToChange)
        default:
            cards = Array(collection.allCards)

        }
        
    }
}



struct CardView: View {
    var card: Card
    
    var body: some View {
        if let imageData = card.image, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 140)
                .cornerRadius(10)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            if let rarity = card.rarity.first {
                                Text("\(rarity)")
                                    .font(.system(size: 10, weight: .thin))
                                    .padding(5)
                            }
                        }
                        
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 100, height: 40)
                            .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 0))
                            .foregroundStyle(.semiBlue.opacity(0.5))
                            .overlay {
                                Text(card.name)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20, weight: .thin))
                                    .minimumScaleFactor(0.4)
                                    .multilineTextAlignment(.center)
                            }
                    }
                }
        }
    }
}


#Preview {
    AllCardsView(collection: DataBaseManager.shared.MOCK())
}
