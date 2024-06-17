//
//  TextAnalyzerView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/02/24.
//

import SwiftUI
import SummariseTranslateFeature
import OCRFeature
import OpenAIFeature

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
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.prime)
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
    let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
    let textAnalyzerStore = TextAnalyzerStore()
    let scanResult = ScanResult(stringResult: "Test result Test result Test result Test result",
                                scanDate: .now,
                                image: UIImage(named: "FakeImage",
                                               in: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main,
                                               with: nil))
    
    let openAiClient = makeOpenAIHTTPClient()
    
    let summaryClient = SummaryClient(summariseService: openAiClient)
    let trClient = TranslateClient(translateService: openAiClient)
    let idLanguage = AppleIdentificationLanguage()
    
    let service = TextAnalyzerService(summaryClient: summaryClient, identificationLanguageClient: idLanguage, translateClient: trClient, storageClient: getFakeStorage())
    
    let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedResult: scanResult, bundle: bundle)
    
    return TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
}


@MainActor
private func getFakeStorage() -> ScanStorege {
    let storeDirectory = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first!

    do {
        return try SwiftDataStore(storeURL: storeDirectory)
    } catch {
        return try! SwiftDataStore(storeURL: URL(string: "Fatal ERROR")!)
    }
}

