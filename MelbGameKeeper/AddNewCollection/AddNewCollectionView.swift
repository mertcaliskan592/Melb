//
//  AddNewCollection.swift
//  MelbGameKeeper
//
//  Created by D K on 03.03.2025.
//

import SwiftUI
extension String: Identifiable {
    public var id: String { self }
}

struct AddNewCollectionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var collectionName = ""
    @State private var collectionDesciption = ""
    @State private var isSelectionShown = false
    
    @State private var pickerType: String?
    @State private var isPickerShown = false
    
    @State private var selectedImage: UIImage?
    
    @State private var imageToSave: Data?
    
    @State private var isMain = false

    
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
                    
                    Text("New Collection")
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(.semiBlue)
                        .padding(.trailing, 20)
                    
                    Spacer()
                }
                ScrollView {
                    VStack {
                        TextField("", text: $collectionName, prompt: Text("Collection Name").foregroundColor(.gray), axis: .vertical)
                            .padding()
                            .background {
                                Rectangle()
                                    .foregroundStyle(.bgDarkBlue)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .foregroundColor(.white)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: size().width - 35, height: 170)
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
                        
                        
                        TextField("", text: $collectionDesciption, prompt: Text("Collection Description").foregroundColor(.gray), axis: .vertical)
                            .lineLimit(5, reservesSpace: true)
                            .padding()
                            .background {
                                Rectangle()
                                    .foregroundStyle(.bgDarkBlue)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .foregroundColor(.white)
                        
                        Rectangle()
                            .frame(width: size().width - 35, height: 65)
                            .foregroundStyle(.bgDarkBlue)
                            .cornerRadius(12)
                            .overlay {
                                Toggle(isOn: $isMain, label: {
                                    Text("Set as Main Collection")
                                        .foregroundStyle(.gray)
                                })
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        
                        Spacer()
                        
                        Button {
                            if !collectionName.isEmpty {
                                createCollection()
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
                        .opacity((collectionName.isEmpty || selectedImage == nil) ? 0.5 : 1)
                        .disabled(collectionName.isEmpty)
                        .disabled(selectedImage == nil)
                    }
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
    
    func createCollection() {
        if let image = selectedImage?.jpegData(compressionQuality: 1) {
            self.imageToSave = image
        }
        
        DataBaseManager.shared.addCollection(name: collectionName, descriptionText: collectionDesciption, image: imageToSave, isMain: isMain)
        
        dismiss()
    }
}

#Preview {
    AddNewCollectionView()
}

