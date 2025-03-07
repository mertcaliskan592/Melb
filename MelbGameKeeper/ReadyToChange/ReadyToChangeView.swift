//
//  ReadyToChangeView.swift
//  MelbGameKeeper
//
//  Created by D K on 05.03.2025.
//

import SwiftUI

struct ReadyToChangeView: View {
    @Environment(\.dismiss) var dismiss
    var collection: RealmCollection
    
    
    @State private var cards: [Card] = []
    
    @State private var selectedTab = 0
    @State private var cardToShow: Card?
    
    @State private var isShareShown = false
    @State var imageToShare: UIImage?
    @State var showImageSheet = false
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.bgSoftBlue)
            VStack {
                if selectedTab != 2 {
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.semiYellow)
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        Button {
                            selectedTab = 2
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.semiYellow)
                        }
                        .padding(.trailing)
                    }
                    
                    Text("Ready To Change")
                        .foregroundStyle(.white)
                        .font(.system(size: 28, weight: .thin))
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 50)
                        .shadow(color: .semiYellow, radius: 100)
                        .frame(width: size().width)
                }
                
                switch selectedTab {
                case 0:
                    GridCardsView(collection: collection, viewType: "change", cards: $cards) { card in
                        withAnimation(.linear(duration: 0.3)) {
                            cardToShow = card
                        }
                    }
                case 2:
                    CardsToShareView(cards: cards)
                        .onAppear {
                            if let window = UIApplication.shared.windows.first {
                                if let screenshot = window.takeScreenshot() {
                                    imageToShare = screenshot
                                    selectedTab = 0
                                    showImageSheet = true
                                } else {
                                    print("Error")
                                }
                            }
                        }
                default:
                    Text("")
                }
                
            }
        }
        .overlay {
            if let card = cardToShow {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .ignoresSafeArea()
                    CardToShowView(card: card) {
                        withAnimation(.linear(duration: 0.3)) {
                            cardToShow = nil
                        }
                    } onDelete: {
                        deleteCard()
                        prepareCards()
                    }
                }
                
            }
        }
        .onAppear {
            prepareCards()
        }
        .fullScreenCover(isPresented: $isShareShown) {
            CardsToShareView(cards: Array(DataBaseManager.shared.MOCK().allCards))
        }
        .imageShareSheet(isPresented: $showImageSheet, image: imageToShare ?? UIImage(named: "template")!)
    }
    
    
    func deleteCard() {
        let cardToDelete = cardToShow
        if let card = cardToDelete {
            DataBaseManager.shared.removeCardFromAllCards(collection: collection, card: card)
            
        }
        withAnimation(.linear(duration: 0.3)) {
            cardToShow = nil
        }
    }
    
    func prepareCards() {
        cards = []
        cards = Array(DataBaseManager.shared.getReadyToChange(from: collection))
    }
}


#Preview {
    ReadyToChangeView(collection: DataBaseManager.shared.MOCK())
}
