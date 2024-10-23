//
//  PreferencesView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 23/10/24.
//

import Foundation
import SwiftUI


public struct PreferencesView: View {
    
    var presenter: PreferencePresenter
    @ObservedObject var store: PreferenceStore

    var resourceBundle: Bundle

    
    public init(store: PreferenceStore, presenter: PreferencePresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            switch store.state {
            case .unowned:
                EmptyView()
            case .error(let message):
                ErrorView(title: "Error", description: message, primaryButtonTitle: "Try with another file", primaryAction: {
                    Task {
                        await presenter.loadData()
                    }
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .loaded(let viewModel):
                ScrollView {
                    Group {
                        Section {
                            VStack(alignment: .leading, spacing: 20, content: {
                                ForEach(viewModel.chooseAISection.avaibleAI, id: \.id) { ai in
                                    Button {
                                        presenter.saveAIPreferencereType(ai)
                                    } label: {
                                        AiCell(model: ai, isSelected: viewModel.selectedAI == ai.aiType)
                                    }
                                }
                            })
                        } header: {
                            VStack(alignment: .leading, spacing: 5.0) {
                                Text("Scegli il tuo modello di AI")
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.title)
                                
                                Text("Qui potrai scegliere quale modello di AI vuoi utilizzare per fare riassunti e/o traduzioni")
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                                    .foregroundStyle(.subtitle)
                            }
                        }.padding()

                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Button {
                                presenter.menuButton()
                            } label: {
                                Image("menu_icon", bundle: resourceBundle)
                            }
                        }
                    }
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(.clear)
        .task {
            await presenter.loadData()
        }
    }
    
    @ViewBuilder
    func AiCell(model: AIPreferenceModel, isSelected: Bool) -> some View {
        HStack(alignment: .top) {
            Image(model.imageName, bundle: resourceBundle)
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
            
            VStack(alignment: .leading, spacing: 3, content: {
                Text(model.title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                
                Text(model.aiType.getDescription())
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(.subtitle)
            })
            
            Spacer()
        }
        .padding()
        .background(.white)
        .clipShape(.buttonBorder)
        .overlay(
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(.prime.opacity(0.5), lineWidth: isSelected ? 1 : 0)
        )
        .shadow(color: isSelected ? .prime.opacity(0.5) : .gray.opacity(0.4), radius: 8.0, x: 0.0, y: 0.0)
    }
}

#Preview {
    @State var preferenceStore = PreferenceStore()
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    var service = LocalAIPreferencesService(resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, userDefault: UserDefaults.standard)

    @State var presenter = PreferencePresenter(delegate: preferenceStore, service: service, menuButton: { }, updatePreferences: { })
    
    return NavigationView {
        PreferencesView(store: preferenceStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
            .navigationTitle("Preferences")
    }
}
