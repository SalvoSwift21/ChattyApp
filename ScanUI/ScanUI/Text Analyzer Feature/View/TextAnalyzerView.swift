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
        VStack(spacing: 10.0) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(store.viewModel.chatHistory, id: \.uuid) { vModel in
                    ChatTextView(viewModel: vModel)
                }.padding(.all, 16.0)
            }
            .padding(0)
            .background(.clear)
            
            
            HStack(alignment: .center, spacing: 10) {
                
                Menu {
                    Button(action: {
                        Task(priority: .background) {
                            await presenter.makeTranslation()
                        }
                    }) {
                        Label("Translate", systemImage: "bubble.left.and.text.bubble.right")
                    }
                    
                    Button(action: {
                        presenter.copySummary()
                    }) {
                        Label("Copy to clipboard", systemImage: "doc.on.doc")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.prime)
                        .frame(width: 20, height: 20)
                }

                Spacer()
                
                Button(action: { self.showFoldersView.toggle() }) {
                    Text("Save")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 100, height: 35)))
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
