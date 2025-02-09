//
//  TextAnalyzerView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/02/24.
//

import SwiftUI
import SummariseTranslateFeature
import OCRFeature
import GoogleAIFeature

public struct TextAnalyzerView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject
    private var purchaseManager: PurchaseManager

    @State private var showingCopyConfirmView = false

    var presenter: TextAnalyzerPresenter
    @ObservedObject var store: TextAnalyzerStore

    var resourceBundle: Bundle
    
    @State private var toggleIsOn = false
    @State private var showMenu = false
    @State private var opacity: Double = 0.0
    @State private var showFoldersView = false
    
    @State private var isShowingAlert: Bool = false
    @State private var scanName: String = ""

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
                ZStack {
                    CompleteTextView
                    if showingCopyConfirmView {
                        FlashAlert(title: "Copy on clipoboard", image: Image(systemName: "checkmark.circle.fill"))
                    }
                }
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
        .task {
            await presenter.getData()
        }
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
                Text("Chat history \(purchaseManager.currentAppProductFeature.productID)")
                    .font(.headline)
                ForEach(store.viewModel.chatHistory, id: \.uuid) { vModel in
                    ChatTextView(viewModel: vModel)
                }.padding(.all, 16.0)
            }
            .padding(0)
            .background(.clear)
            .defaultScrollAnchor(.bottom)

            
            HStack(alignment: .center, spacing: 10) {
                Menu {
                    
                    if presenter.transactionFeatureIsEnabled() {
                        Button(action: {
                            Task(priority: .background) {
                                await presenter.makeTranslation()
                            }
                        }) {
                            Label("Translate", systemImage: "bubble.left.and.text.bubble.right")
                        }
                    }
                    
                    Button(action: {
                        presenter.copySummary()
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.showingCopyConfirmView.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.showingCopyConfirmView.toggle()
                            }
                        })
                    }) {
                        Label("Copy to clipboard", systemImage: "doc.on.doc")
                    }
                    
                    
                    ShareLink(
                        item: store.viewModel.getSharableObject(),
                        preview: SharePreview(
                            store.viewModel.getSharableObject().description,
                            image: store.viewModel.getSharableObject().image))
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.prime)
                }

                Spacer()
                
                Button(action: { self.isShowingAlert.toggle() }) {
                    Text("Save")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 100, height: 35)))
                .textFieldAlert(text: $scanName,
                                title: "Add title to this new scan",
                                okButtonTitle: "Ok",
                                placeholder: "Scan name",
                                isShowingAlert: $isShowingAlert) {
                    presenter.addTitle(scanName)
                    self.showFoldersView.toggle()
                }
            }
            
        }
        .navigationTitle("Summary result")
        .navigationBarTitleDisplayMode(.inline)
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
                                fileData: nil)

    let googleClient: GoogleAILLMClient = makeGoogleGeminiAIClient(modelName: AIModelType.gemini_1_5_flash.rawValue)
    
    let summaryClient = SummaryClient(summariseService: googleClient)
    let idLanguage = AppleIdentificationLanguage()
    let trClient = TranslateClient(translateService: googleClient, identificationLanguageClient: idLanguage, localeToTranslate: .current)
    
    let service = TextAnalyzerService(summaryClient: summaryClient, translateClient: trClient, storageClient: getFakeStorage())
    var currentAppProductFeature: ProductFeature = ProductFeature(features: [.complexAIModel], productID: "")

    let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedResult: scanResult, currentProductFeature: currentAppProductFeature, bundle: bundle)
    
    TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
}
