//
//  SettingsView.swift
//  MelbGameKeeper
//
//  Created by D K on 03.03.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isAlertShown = false
    @State private var isContactShown = false
    @State private var isPrivacyShown = false
    
    var completion: () -> ()
    
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
                    
                    Text("Settings")
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(.semiBlue)
                        .padding(.trailing, 30)
                    
                    Spacer()
                }
                
                ScrollView {
                    Button {
                        isContactShown.toggle()
                    } label: {
                        Rectangle()
                            .frame(width: size().width - 40, height: 67)
                            .cornerRadius(12)
                            .foregroundStyle(.bgDarkBlue)
                            .overlay {
                                HStack {
                                    Image(systemName: "envelope.fill")
                                        
                                    
                                    Text("Send Feedback")
                                }
                                .foregroundStyle(.semiBlue)
                            }
                    }
                    
                    Button {
                        isPrivacyShown.toggle()
                    } label: {
                        Rectangle()
                            .frame(width: size().width - 40, height: 67)
                            .cornerRadius(12)
                            .foregroundStyle(.bgDarkBlue)
                            .overlay {
                                HStack {
                                    Image(systemName: "lock.doc.fill")
                                        
                                    
                                    Text("Privacy Policy")
                                    
                                }
                                .foregroundStyle(.semiBlue)
                            }
                    }
                    .padding(.vertical)
                    
                    Button {
                        isAlertShown.toggle()
                    } label: {
                        Rectangle()
                            .frame(width: size().width - 40, height: 67)
                            .cornerRadius(12)
                            .foregroundStyle(.bgDarkBlue)
                            .overlay {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        
                                    
                                    Text("Delete All Data")
                                }
                                .foregroundStyle(.red)
                            }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .alert("Are you sure? ", isPresented: $isAlertShown) {
            Button {
                
            } label: {
                Text("No")
            }
            
            Button {
                dismiss()
                completion()
            } label: {
                Text("Yes")
                    .foregroundStyle(.red)
            }
        } message: {
            Text("All data will be deleted")
        }
        .sheet(isPresented: $isPrivacyShown) {
            PrivacyPolicyWrapper(privacyURL: "")
                .presentationDetents([.height(size().height / 1.15)])
        }
        .sheet(isPresented: $isContactShown) {
            PrivacyPolicyWrapper(privacyURL: "")
                .presentationDetents([.height(size().height / 1.15)])
        }
    }
}

#Preview {
    SettingsView(){}
}
