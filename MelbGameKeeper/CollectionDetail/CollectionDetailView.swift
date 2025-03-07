//
//  CollectionDetailView.swift
//  MelbGameKeeper
//
//  Created by D K on 03.03.2025.
//

import SwiftUI

struct CollectionDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isAllCardsShown = false
    @State private var isWhishListShown = false
    @State private var isChangeShown = false
    var collection: RealmCollection
    var deletion: (RealmCollection) -> ()
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.bgSoftBlue)
            VStack {
                ZStack {
                    if let data = collection.image, let imageData = UIImage(data: data)  {
                        Image(uiImage: imageData)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size().width, height: 240)
                            .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0))
                            .ignoresSafeArea()
                            .blur(radius: 2)
                    } else {
                        Image("template")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size().width, height: 240)
                            .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0))
                            .ignoresSafeArea()
                            .blur(radius: 2)
                    }
                    
                }
                .frame(width: size().width, height: 240)
                .overlay {
                    Text(collection.name)
                        .foregroundStyle(.white)
                        .font(.system(size: 44, weight: .thin))
                        .shadow(color: .black, radius: 5)
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 5)
                        .shadow(color: .semiYellow, radius: 50)
                        .shadow(color: .semiYellow, radius: 100)
                        .shadow(color: .semiYellow, radius: 200)
                        .frame(width: size().width)
                        .padding(.bottom, 30)
                }
                .overlay {
                    VStack {
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
                                deletion(collection)
                                dismiss()
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.semiYellow)
                            }
                            .padding(.trailing)
                        }
                        
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        isAllCardsShown.toggle()
                    } label: {
                        Rectangle()
                            .frame(width: 140, height: 140)
                            .cornerRadius(12)
                            .foregroundStyle(.bgDarkBlue)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 0.5)
                                    .foregroundStyle(.semiYellow)
                                
                            }
                            .overlay {
                                VStack {
                                    Image("cardsList")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                    
                                    Text("All Cards")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20, weight: .thin))
                                }
                            }
                    }
                    
                    Spacer()
                    
                    Button {
                        isWhishListShown.toggle()
                    } label: {
                        Rectangle()
                            .frame(width: 140, height: 140)
                            .cornerRadius(12)
                            .foregroundStyle(.bgDarkBlue)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 0.5)
                                    .foregroundStyle(.semiYellow)
                                
                            }
                            .overlay {
                                VStack {
                                    Image("wishList")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                    
                                    Text("WishList")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20, weight: .thin))
                                }
                            }
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        isChangeShown.toggle()
                    } label: {
                        Rectangle()
                            .frame(width: 140, height: 140)
                            .cornerRadius(12)
                            .foregroundStyle(.bgDarkBlue)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 0.5)
                                    .foregroundStyle(.semiYellow)
                                
                            }
                            .overlay {
                                VStack {
                                    Image("changeList")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                    
                                    Text("Ready To Change")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20, weight: .thin))
                                }
                            }
                    }
                    
                    Spacer()
                }
                .padding(.top)
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isAllCardsShown) {
            AllCardsView(collection: collection)
        }
        .fullScreenCover(isPresented: $isWhishListShown) {
            WishListView(collection: collection)
        }
        .fullScreenCover(isPresented: $isChangeShown) {
            ReadyToChangeView(collection: collection)
        }
    }
}

#Preview {
    CollectionDetailView(collection: RealmCollection(name: "Name Name", descriptionText: "", image: nil)){_ in}
}
