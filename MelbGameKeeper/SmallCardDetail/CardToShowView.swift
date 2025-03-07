//
//  CardToShowView.swift
//  MelbGameKeeper
//
//  Created by D K on 05.03.2025.
//

import SwiftUI

struct CardToShowView: View {
    
    @State private var flip = false
    @State private var flip2 = false
    
    @State private var rotation: CGFloat = 0
    
    var card: Card
    
    @State private var imageToShow = UIImage()
    @State private var cardColor: Color = .red
    
    var onClose: () -> ()
    var onDelete: () -> ()
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .frame(width: 600, height: 150)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [cardColor.opacity(0.01), cardColor, cardColor, cardColor.opacity(0.01)]), startPoint: .top, endPoint: .bottom))
                        .rotationEffect(.degrees(rotation))
                        .mask {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(lineWidth: 10)
                                .frame(width: size().width - 60 - 1.5, height: size().height / 1.5 - 1.5)
                        }
                    
                    Rectangle()
                        .frame(width: size().width - 60, height: size().height / 1.5)
                        .cornerRadius(12)
                        .foregroundStyle(.bgDarkBlue)
                        .overlay {
                            VStack {
                                
                                Text("Name:")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .padding(.top, 15)
                                
                                Text(card.name)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 32, weight: .thin))

                                if !card.descriptionText.isEmpty {
                                    Text("Description:")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16, weight: .ultraLight))
                                        .padding(.top, 5)
                                    Text(card.descriptionText)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 18, weight: .thin))
                                        .padding(.horizontal, 20)
                                }
                                
                                
                                Text("Rarity:")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .padding(.top, 25)
                                Text(card.rarity)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24, weight: .thin))
                                
                                
                                
                                Button {
                                    onDelete()
                                } label: {
                                    Text("Delete")
                                        .foregroundStyle(.red)
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 5)
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
                .onAppear {
                    prepareColor()
                    prepareImage()
                }
                
                
                Button {
                    onClose()
                } label: {
                    Text("Close")
                        .foregroundStyle(.red)
                }
                .padding(.top, 50)
            }
            .onAppear {
                withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
         
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

#Preview {
    CardToShowView(card: DataBaseManager.shared.MOCK().allCards.first!) {
        
    } onDelete: {
        
    }
        .preferredColorScheme(.dark)
}
