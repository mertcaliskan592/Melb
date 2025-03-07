//
//  HomeView.swift
//  MelbGameKeeper
//
//  Created by D K on 03.03.2025.
//

import SwiftUI

extension View {
    func size() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
}

struct HomeView: View {
    
    @State private var isAddNewCollectionShown = false
    @State private var mainCollection: RealmCollection?
    @State private var otherCollections: [RealmCollection] = []
    @State private var isMainExist = false
    
    @State private var isSettingsShown = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(.bgDarkBlue)
                
                ScrollView {
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                HStack {
                                    Spacer()
                                    
                                    Button {
                                        isSettingsShown.toggle()
                                    } label: {
                                        Image(systemName: "gearshape.fill")
                                            .foregroundStyle(.semiYellow)
                                            .font(.system(size: 24, weight: .black))
                                    }
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 60)
                                }
                                .frame(width: size().width, height: 100)
                            }
                            .frame(width: size().width, height: 100)
                        
                        
                        Text("Main Collection")
                            .foregroundStyle(.white)
                            .font(.system(size: 44,weight: .thin))
                            .shadow(color: .semiYellow, radius: 5)
                            .shadow(color: .semiYellow, radius: 5)
                            .shadow(color: .semiYellow, radius: 50)
                            .shadow(color: .semiYellow, radius: 100)
                            .shadow(color: .semiYellow, radius: 200)
                            .frame(width: size().width)
                        
                        if isMainExist {
                            NavigationLink {
                                if let main = mainCollection {
                                    CollectionDetailView(collection: main) { coll in
                                        DispatchQueue.main.async {
                                            mainCollection = nil
                                            isMainExist = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            mainCollection = nil
                                            isMainExist = true
                                            DataBaseManager.shared.deleteCollection(collection: coll)
                                        }
                                    }
                                    .navigationBarBackButtonHidden()
                                    .onDisappear {
                                        getMainCollection()
                                        getOtherCollections()
                                    }
                                }
                                
                            } label: {
                                if let main = mainCollection {
                                    CollectionCell(collection: main)
                                }
                            }
                        }
                        
                        if mainCollection == nil {
                            Image("template")
                                .resizable()
                                .scaledToFill()
                                .frame(width: size().width - 40, height: 200)
                                .cornerRadius(12)
                                .blur(radius: 3.0)
                                .overlay {
                                    Text("You don't have a main collection.")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 32, weight: .thin))
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                        }
                        
                        
                        Text("Other Collections")
                            .foregroundStyle(.white)
                            .font(.system(size: 38,weight: .thin))
                            .shadow(color: .semiBlue, radius: 5)
                            .shadow(color: .semiBlue, radius: 5)
                            .shadow(color: .semiBlue, radius: 50)
                        
                        VStack {
                            ForEach(otherCollections, id: \.id) { collection in
                                NavigationLink {
                                    CollectionDetailView(collection: collection) { coll in
                                        DispatchQueue.main.async {
                                            otherCollections = []
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            DataBaseManager.shared.deleteCollection(collection: coll)
                                            getOtherCollections()
                                        }
                                       
                                    }
                                    .navigationBarBackButtonHidden()
                                    .onDisappear {
                                        getMainCollection()
                                        getOtherCollections()
                                    }
                                } label: {
                                    CollectionCell(collection: collection)
                                }
                            }
                            
                        }
                        .padding(.bottom, 150)
                        
                    }
                }
                .scrollIndicators(.hidden)
                
            }
            .overlay {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            isAddNewCollectionShown.toggle()
                        } label: {
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.darkBlue)
                                .shadow(color: .semiBlue, radius: 2)
                                .shadow(color: .semiBlue, radius: 10)
                                .overlay {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24, weight: .black))
                                        .foregroundStyle(.white)
                                }
                        }
                        .padding(10)
                    }
                }
            }
            .fullScreenCover(isPresented: $isAddNewCollectionShown) {
                AddNewCollectionView()
                    .onDisappear {
                        getMainCollection()
                        getOtherCollections()
                    }
            }
            .onAppear {
                getMainCollection()
                getOtherCollections()
            }
        }
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "init") {
                UserDefaults.standard.setValue(true, forKey: "init")
                DataBaseManager.shared.createMOCKCollection()
                getMainCollection()
            }
        }
        .fullScreenCover(isPresented: $isSettingsShown) {
            SettingsView() {
                DispatchQueue.main.async {
                    mainCollection = nil
                    isMainExist = true
                    otherCollections = []
                    DataBaseManager.shared.deleteAll()
                }
            }
        }
    }
    
    
    func getMainCollection() {
        if let collection = DataBaseManager.shared.getMainCollection() {
            isMainExist = true
            self.mainCollection = collection
        }
    }
    
    func getOtherCollections() {
        DispatchQueue.main.async {
            otherCollections = []
            let collections = Array(DataBaseManager.shared.getAllNonMainCollections())
            self.otherCollections = collections
        }
    }
}

#Preview {
    HomeView()
}
