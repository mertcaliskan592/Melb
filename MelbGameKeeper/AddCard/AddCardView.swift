//
//  AddCardView.swift
//  MelbGameKeeper
//
//  Created by D K on 04.03.2025.
//

import SwiftUI

struct AddCardView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var collection: RealmCollection
    var viewType: String
    
    @State private var pickerType: String?
    @State private var isPickerShown = false
    
    @State private var selectedImage: UIImage?
    @State private var isSelectionShown = false

    @State private var cardName = ""
    @State private var cardDescription = ""
    @State private var selectedRarity = "⚪️ Common"
    
    var rarity = ["⚪️ Common", "🟢 Uncommon", "🔵 Rare", "🟣 Super Rare", "🔴 Ultra Rare", "⚫ Secret Rare"]
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.bgSoftBlue)
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(.semiBlue)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    Text("New Card")
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(.semiBlue)
                        .padding(.trailing, 10)
                    
                    Spacer()
                }
                
                ScrollView {
                    //MARK: - IMAGE
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 200)
                            .cornerRadius(12)
                            .padding(.vertical)
                    } else {
                        Button {
                            withAnimation(.spring(duration: 0.2, bounce: 0, blendDuration: 0)) {
                                isSelectionShown.toggle()
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(.bgDarkBlue)
                                    .frame(width: size().width - 35, height: 170)
                                    .cornerRadius(12)
                                
                                VStack {
                                    Text("Add Image")
                                    
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 64, weight: .regular))
                                        .padding(.top)
                                }
                                .foregroundStyle(.gray)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    //MARK: - TF

                    TextField("", text: $cardName, prompt: Text("Card Name").foregroundColor(.gray), axis: .vertical)
                        .padding()
                        .background {
                            Rectangle()
                                .foregroundStyle(.bgDarkBlue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                    TextField("", text: $cardDescription, prompt: Text("Card Description").foregroundColor(.gray), axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                        .padding()
                        .background {
                            Rectangle()
                                .foregroundStyle(.bgDarkBlue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .padding(.vertical)
                    
                    Rectangle()
                        .frame(width: size().width - 35, height: 65)
                        .cornerRadius(12)
                        .foregroundStyle(.bgDarkBlue)
                        .overlay {
                            HStack {
                                Text("Rarity")
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                
                                Picker("", selection: $selectedRarity) {
                                    ForEach(rarity, id: \.self) { text in
                                        Text("\(text)")
                                    }
                                }
                                .tint(.white)
                            }
                            .padding(.horizontal)
                        }
                    
                    Button {
                        if selectedImage != nil {
                            saveCard()
                            dismiss()
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: size().width - 60, height: 65)
                                .cornerRadius(12)
                                .foregroundStyle(LinearGradient(colors: [.semiBlue, .darkBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            Text("Save")
                                .foregroundStyle(.white)
                                .font(.system(size: 24))
                        }
                    }
                    .padding(.bottom, 150)
                    .padding(.top, 35)
                    .opacity((cardName.isEmpty || selectedImage == nil) ? 0.5 : 1)
                    .disabled(cardName.isEmpty)
                    .disabled(selectedImage == nil)
                }
                .scrollIndicators(.hidden)
            }
        }
        .overlay {
            ZStack {
                Rectangle()
                    .frame(width: size().width - 80, height: 150)
                    .cornerRadius(12)
                    .foregroundStyle(.bgDarkBlue)
                    .shadow(radius: 5)
                    .shadow(radius: 25)
                    .shadow(radius: 55)
                    .shadow(radius: 100)
                    .shadow(radius: 200)
                    .overlay {
                        HStack(spacing: 30) {
                            Button {
                                withAnimation(.spring(duration: 0.2, bounce: 0, blendDuration: 0)) {
                                    isSelectionShown.toggle()
                                }
                                pickerType = "camera"
                                isPickerShown.toggle()
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(12)
                                        .foregroundStyle(.bgSoftBlue)
                                    VStack {
                                        Image(systemName: "camera")
                                            .font(.system(size: 44, weight: .regular))
                                            .foregroundStyle(.semiBlue)
                                        
                                        Text("Camera")
                                            .foregroundStyle(.semiBlue)
                                    }
                                }
                            }
                            
                            Button {
                                withAnimation(.spring(duration: 0.2, bounce: 0, blendDuration: 0)) {
                                    isSelectionShown.toggle()
                                }
                                pickerType = "library"
                                isPickerShown.toggle()
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(12)
                                        .foregroundStyle(.bgSoftBlue)
                                    VStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.system(size: 44, weight: .regular))
                                            .foregroundStyle(.semiBlue)
                                        
                                        Text("Library")
                                            .foregroundStyle(.semiBlue)
                                    }
                                }
                            }
                        }
                    }
            }
            .scaleEffect(isSelectionShown ? 1 : 0)
        }
        .sheet(item: $pickerType) { type in
            if type == "camera" {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                    .ignoresSafeArea()
            } else {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                    .ignoresSafeArea()
            }
        }
    }
    
    func saveCard() {
        if let image = selectedImage?.jpegData(compressionQuality: 1) {
            let card = Card(name: cardName, descriptionText: cardDescription, image: image, rarity: selectedRarity)
            switch viewType {
            case "all":
                DataBaseManager.shared.addCardToAllCards(collection: collection, card: card)
            case "wish":
                DataBaseManager.shared.addCardToWishList(collection: collection, card: card)
            case "change":
                DataBaseManager.shared.addCardToReadyToChange(collection: collection, card: card)
            default:
                DataBaseManager.shared.addCardToAllCards(collection: collection, card: card)
            }
        }
    }
}

//#Preview {
//    AddCardView()
//}
