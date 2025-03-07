//
//  AllCardsView.swift
//  MelbGameKeeper
//
//  Created by D K on 03.03.2025.
//

import SwiftUI

struct AllCardsView: View {
    
    init(collection: RealmCollection) {
        UISegmentedControl.appearance().selectedSegmentTintColor = .semiBlue
        UISegmentedControl.appearance().backgroundColor = .bgDarkBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        self.collection = collection
    }
    
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
                    
                    Text("All Cards")
                        .foregroundStyle(.white)
                        .font(.system(size: 28, weight: .thin))
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 50)
                        .shadow(color: .semiYellow, radius: 100)
                        .frame(width: size().width)
                    
                    Picker("", selection: $selectedTab) {
                        Text("Grid").tag(0)
                        Text("Cards").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                
                switch selectedTab {
                case 0:
                    GridCardsView(collection: collection, viewType: "all", cards: $cards) { card in
                        withAnimation(.linear(duration: 0.3)) {
                            cardToShow = card
                        }
                    }
                case 1:
                    TabCardsView(collection: collection, cards: $cards)
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
        cards = Array(DataBaseManager.shared.getAllCards(from: collection))
    }
}

#Preview {
    AllCardsView(collection: DataBaseManager.shared.MOCK())
}



extension UIView {
    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}
