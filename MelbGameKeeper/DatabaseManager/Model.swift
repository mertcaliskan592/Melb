//
//  Model.swift
//  MelbGameKeeper
//
//  Created by D K on 04.03.2025.
//

import Foundation
import RealmSwift

class Card: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var descriptionText: String
    @Persisted var image: Data?
    @Persisted var rarity: String
    
    convenience init(name: String, descriptionText: String, image: Data?, rarity: String) {
        self.init()
        self.name = name
        self.descriptionText = descriptionText
        self.image = image
        self.rarity = rarity
    }
}

class RealmCollection: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var descriptionText: String
    @Persisted var image: Data?
    @Persisted var isMain: Bool = false 
    @Persisted var allCards: List<Card>
    @Persisted var wishList: List<Card>
    @Persisted var readyToChange: List<Card>
    
    convenience init(name: String, descriptionText: String, image: Data?, isMain: Bool = false) {
        self.init()
        self.name = name
        self.descriptionText = descriptionText
        self.image = image
        self.isMain = isMain
    }
}


