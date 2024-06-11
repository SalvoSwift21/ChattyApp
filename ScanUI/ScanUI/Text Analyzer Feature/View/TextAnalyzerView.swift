//
//  TextAnalyzerView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/02/24.
//

import SwiftUI
import Combine


public struct TextAnalyzerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var presenter: TextAnalyzerPresenter
    @ObservedObject var store: TextAnalyzerStore

    var resourceBundle: Bundle
    
    @State private var toggleIsOn = false
    @State private var showMenu = false
    @State private var opacity: Double = 0.0
    @State private var showFoldersView = false

    public init(store: TextAnalyzerStore, presenter: TextAnalyzerPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            switch store.state {
            case .loading(let showLoader):
                if showLoader {
                    LoadingView()
                }
            case .error(let message):
                ErrorView(title: "Error", description: message, primaryButtonTitle: "ok", primaryAction: {
                    print("Generic error ok")
                }, secondaryButtonTitle: nil, secondaryAction: nil)
            case .showViewModel:
                CompleteTextView
            }
            Spacer()
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(Color.mainBackground)
        .onAppear(perform: {
            presenter.getData()
        })
        .onChange(of: store.back) {
            if store.back {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .sheet(isPresented: $showFoldersView) {
            FoldersView
        }
    }
    
    var CompleteTextView: some View {
        VStack(spacing: 20.0) {
            ScrollView(.vertical, showsIndicators: false) {
                
                if let topImage = store.viewModel.topImage {
                    HStack {
                        VStack(alignment: .leading, spacing: 8.0) {
                            Text("Summury this image:")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.title)
                                .multilineTextAlignment(.leading)
                            
                            Image(uiImage: topImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 120.0)
                                .padding(5.0)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5.0)
                        
                        Spacer(minLength: 35.0)
                    }.padding()
                }
                
                HStack {
                    Spacer(minLength: 35.0)
                    VStack(alignment: .leading) {
                        Text(store.viewModel.text)
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.all, 5.0)
                    }
                    .background(Color.prime.opacity(0.7))
                    .cornerRadius(5)
                    .shadow(radius: 5.0)
                }.padding()
                
            }
            .background(.clear)
            
            HStack(alignment: .center, spacing: 15) {
                Button(action: {
                    Task(priority: .background) {
                        await presenter.makeTranslation()
                    }
                }) {
                    Image(systemName: "bubble.left.and.text.bubble.right")
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 45, height: 45)))
                
                Button(action: {
                    presenter.copySummary()
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 45, height: 45)))
            }
            
            
            HStack(alignment: .center, spacing: 10) {
                Button(action: { self.showFoldersView.toggle() }) {
                    Text("Save")
                        .fontWeight(.bold)
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 200, height: 57)))
            }
            
        }
        .navigationTitle("Summary result")
        .background(.mainBackground)
    }
    
    var FoldersView: some View {
        NavigationView {
            FoldersViewComposer.foldersComposedWith(client: presenter.getStoredService()) { selectedFolder in
                presenter.doneButtonTapped(withFolder: selectedFolder)
            }
            .navigationTitle("Choose folder")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        self.showFoldersView.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    @State var scanStore = ScanStore(state: .loading(show: false))
    
    @State var presenter = ScanPresenter(delegate: scanStore, resultOfScan: { _ in })
    
    return ScanView(store: scanStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
}
