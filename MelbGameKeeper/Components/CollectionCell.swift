//
//  CollectionCell.swift
//  MelbGameKeeper
//
//  Created by D K on 04.03.2025.
//

import SwiftUI

struct CollectionCell: View {
    
    var collection: RealmCollection
    
    var body: some View {
        ZStack {
            if let data = collection.image, let imageData = UIImage(data: data)  {
                Image(uiImage: imageData)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size().width - 40, height: 200)
            } else {
                Image("template")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size().width - 40, height: 200)
            }
           
        }
        .frame(width: size().width - 40, height: 200)
        .cornerRadius(12)
        .overlay {
            VStack {
                Rectangle()
                    .frame(width: size().width - 40, height: 50)
                    .foregroundStyle(.semiYellow.opacity(0.7))
                    .clipShape(.rect(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12))
                    .overlay {
                        HStack {
                            Text(collection.name)
                                .foregroundStyle(.white)
                                .font(.system(size: 24, weight: .thin))
                            
                            Spacer()
                            
                            Text("x\(collection.allCards.count)")
                                .foregroundStyle(.white)
                                .font(.system(size: 24, weight: .thin))
                        }
                        .padding(.horizontal)
                    }
                
                Spacer()
            }
        }

    }
}

#Preview {
    CollectionCell(collection: RealmCollection(name: "Collection Name", descriptionText: "", image: nil, isMain: true))
}
