//
//  DatabaseManager.swift
//  MelbGameKeeper
//
//  Created by D K on 04.03.2025.
//

import SwiftUI
import RealmSwift

class DataBaseManager {
    static let shared = DataBaseManager()
    private var realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    // MARK: - Методы для работы с коллекциями
    
    // Добавление коллекции
    func addCollection(name: String, descriptionText: String, image: Data?, isMain: Bool = false) {
        if isMain {
            let allCollections = realm.objects(RealmCollection.self)
            try! realm.write {
                for collection in allCollections {
                    collection.isMain = false
                }
            }
        }
        
        let collection = RealmCollection(name: name, descriptionText: descriptionText, image: image, isMain: isMain)
        try! realm.write {
            realm.add(collection)
        }
    }
    
    func getMainCollection() -> RealmCollection? {
        return realm.objects(RealmCollection.self).filter("isMain == true").first
    }
    
    func getAllNonMainCollections() -> Results<RealmCollection> {
        // Ищем все коллекции, у которых isMain == false
        return realm.objects(RealmCollection.self).filter("isMain == false")
    }
    
    // Удаление коллекции
    func deleteCollection(collection: RealmCollection) {
        try! realm.write {
            realm.delete(collection.allCards)
            realm.delete(collection.wishList)
            realm.delete(collection.readyToChange)
            realm.delete(collection)
        }
    }
    
    // MARK: - Методы для работы с карточками
    
    // Добавление карточки в массив AllCards
    func addCardToAllCards(collection: RealmCollection, card: Card) {
        try! realm.write {
            collection.allCards.append(card)
        }
    }
    
    // Добавление карточки в массив WishList
    func addCardToWishList(collection: RealmCollection, card: Card) {
        try! realm.write {
            collection.wishList.append(card)
        }
    }
    
    // Добавление карточки в массив ReadyToChange
    func addCardToReadyToChange(collection: RealmCollection, card: Card) {
        try! realm.write {
            collection.readyToChange.append(card)
        }
    }
    
    // Удаление карточки из массива AllCards
    func removeCardFromAllCards(collection: RealmCollection, card: Card) {
        if let index = collection.allCards.firstIndex(where: { $0.id == card.id }) {
            try! realm.write {
                collection.allCards.remove(at: index)
              //  realm.delete(card)
            }
        }
    }
    
    // Удаление карточки из массива WishList
    func removeCardFromWishList(collection: RealmCollection, card: Card) {
        if let index = collection.wishList.firstIndex(where: { $0.id == card.id }) {
            try! realm.write {
                collection.wishList.remove(at: index)
            }
        }
    }
    
    // Удаление карточки из массива ReadyToChange
    func removeCardFromReadyToChange(collection: RealmCollection, card: Card) {
        if let index = collection.readyToChange.firstIndex(where: { $0.id == card.id }) {
            try! realm.write {
                collection.readyToChange.remove(at: index)
            }
        }
    }
    
    // Получение всех карточек из массива AllCards
    func getAllCards(from collection: RealmCollection) -> RealmSwift.List<Card> {
        return collection.allCards
    }
    
    // Получение всех карточек из массива WishList
    func getWishList(from collection: RealmCollection) -> RealmSwift.List<Card> {
        return collection.wishList
    }
    
    // Получение всех карточек из массива ReadyToChange
    func getReadyToChange(from collection: RealmCollection) -> RealmSwift.List<Card> {
        return collection.readyToChange
    }
    
    func createMOCKCollection() {
        let collection = MOCK()
        
        try! realm.write {
            realm.add(collection)
        }
    }
    
    func MOCK() -> RealmCollection {
       let rarity = ["⚪️ Common", "🟢 Uncommon", "🔵 Rare", "🟣 Super Rare", "🔴 Ultra Rare", "⚫ Secret Rare"]
       
       let collection = RealmCollection(name: "Eclipse Chronicles", descriptionText: "A legendary set of collectible cards featuring warriors, mystics, and creatures from the edges of reality. Each character wields immense power, shaping the fate of their world through battles of magic, technology, and ancient forces.", image: UIImage(named: "artCol")?.jpegData(compressionQuality: 1), isMain: true)
  
        collection.allCards.append(Card(name: "Shadowfang Assassin", descriptionText: "Master of Silent Death – Ability: “Void Step” – Instantly teleports behind the enemy and strikes for critical damage, bypassing armor. Passive: “Shadow Cloak” – Gains invisibility for one turn if not attacked, making the next attack unavoidable.", image: UIImage(named: "1")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Mecha-Beast Titan", descriptionText: "Cybernetic Apex Predator – Ability: “Overclocked Rampage” – Doubles attack speed and power for two turns but takes self-damage due to overheating. Passive: “Nanite Regeneration” – Repairs 10% of lost health each turn if no damage is taken.", image: UIImage(named: "2")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Infernal Knight Ignis", descriptionText: "The Blazing Champion – Ability: “Molten Strike” – His greatsword erupts in lava, dealing area damage and applying burn over time. Passive: “Unyielding Fury” – Becomes stronger as health decreases, gaining +10% attack for every 25% HP lost.", image: UIImage(named: "3")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Abyssal Empress Nyx", descriptionText: "Ruler of the Void – Ability: “Cosmic Grasp” – Summons eldritch tentacles to bind enemies, reducing their attack and defense for three turns. Passive: “Endless Darkness” – Each time she defeats an enemy, she gains +5% health and permanently increases magic damage.", image: UIImage(named: "4")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Neon Samurai Akira", descriptionText: "Blade of the Future – Ability: “Lightning Slash” – Moves at the speed of light, attacking all enemies in a straight line. Passive: “Cyber Reflexes” – Has a 30% chance to dodge attacks and counter with a quick slash.", image: UIImage(named: "5")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Stormborn Dragon", descriptionText: "Emperor of Thunder – Ability: “Tempest Roar” – Unleashes a storm that deals heavy damage and stuns all opponents for one turn. Passive: “Skyborn Resilience” – Immune to all ground-based effects and gains +20% speed in stormy conditions.", image: UIImage(named: "6")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Void Reaper Thanek", descriptionText: "Harbinger of Doom – Ability: “Soul Harvest” – Every time he defeats an enemy, he absorbs their strength, permanently gaining +5% attack. Passive: “Eternal Dread” – Nearby enemies lose 10% attack power due to his presence.", image: UIImage(named: "7")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Glacial Guardian Frostbane", descriptionText: "The Frozen Sentinel – Ability: “Absolute Zero” – Freezes an enemy in solid ice for two turns, preventing any actions. Passive: “Unbreakable Ice” – Takes 30% less damage from physical attacks.", image: UIImage(named: "8")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Chrono-Warrior Zephyr", descriptionText: "Master of Time – Ability: “Temporal Slash” – Strikes an enemy, reversing time to undo their last action. Passive: “Future Sight” – At the start of each battle, can predict and evade the first attack received.", image: UIImage(named: "9")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
        collection.allCards.append(Card(name: "Cybermage Phoenix", descriptionText: "The Digital Sorcerer – Ability: “Quantum Flames” – Unleashes a burst of fire that adapts to the enemy’s weaknesses, dealing double damage against cybernetic and undead foes. Passive: “Holographic Rebirth” – If defeated, has a 50% chance to resurrect as a digital entity, returning with half health.", image: UIImage(named: "10")?.jpegData(compressionQuality: 1), rarity: rarity.randomElement()!))
       
       return collection
   }
    
    
    func deleteAll() {
        do {
                try realm.write {
                    let allCards = realm.objects(Card.self)
                    let allCollections = realm.objects(RealmCollection.self)
                    realm.delete(allCollections)
                    realm.delete(allCards)
                }
            } catch {
                print("Ошибка при удалении Card: \(error)")
            }
    }
}
