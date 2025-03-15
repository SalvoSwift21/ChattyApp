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

    @State private var isSharing = false

    public init(store: TextAnalyzerStore, presenter: TextAnalyzerPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            switch store.state {
            case .showViewModel:
                ZStack {
                    CompleteTextView
                    if showingCopyConfirmView {
                        FlashAlert(title: "GENERIC_COPY_CLIPBOARD_ACTION", image: Image(systemName: "checkmark.circle.fill"))
                    }
                    
                    if let errorState = store.errorState {
                        
                        Color
                            .scanBackground
                            .opacity(0.15)
                            .ignoresSafeArea(.all)
                            .onTapGesture {
                                Task {
                                    self.presenter.handleErrorSecondaryAction(state: errorState)
                                }
                            }
                        
                        ErrorView(title: "GENERIC_ERROR_TITLE", description: errorState.getMessage(), primaryButtonTitle: "GENERIC_TRY_AGAIN", primaryAction: {
                            presenter.handleErrorPrimaryAction(state: errorState)
                        }, secondaryButtonTitle: "GENERIC_CANCEL_TITLE", secondaryAction: {
                            presenter.handleErrorSecondaryAction(state: errorState)
                        })
                    }
                    
                }
            }
            Spacer()
        }
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
        VStack(spacing: 2) {
            if presenter.adMobIsEnabled() {
                ExternalBannerView(addUnitID: presenter.getADBannerID())
                Spacer()
            }
            
            VStack(spacing: 10) {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(store.viewModel.chatHistory, id: \.uuid) { vModel in
                        ChatTextView(viewModel: vModel)
                    }.padding()
                }
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
                                Label("GENERIC_TRANSLATE_ACTION", systemImage: "bubble.left.and.text.bubble.right")
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
                            Label("GENERIC_COPY_CLIPBOARD_ACTION", systemImage: "doc.on.doc")
                        }
                        
                        Button {
                            isSharing.toggle()
                        } label: {
                            Label("GENERIC_SHARE_ACTION", systemImage: "square.and.arrow.up")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.prime)
                    }

                    Spacer()
                    
                    Button(action: { self.isShowingAlert.toggle() }) {
                        Text("GENERIC_SAVE_ACTION")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(DefaultButtonStyle(frame: .init(width: 100, height: 35)))
                    .textFieldAlert(text: $scanName,
                                    title: "TEXT_ANALYZER_NEW_SCAN_ALERT_TITLE",
                                    okButtonTitle: "GENERIC_SAVE_ACTION",
                                    message: "TEXT_ANALYZER_NEW_SCAN_ALERT_MESSAGE",
                                    placeholder: "TEXT_ANALYZER_NEW_SCAN_ALERT_PLACEHOLDER",
                                    isShowingAlert: $isShowingAlert) {
                        presenter.addTitle(scanName)
                        self.showFoldersView.toggle()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("TEXT_ANALYZER_TITLE")
        .navigationBarTitleDisplayMode(.inline)
        .background(.mainBackground)
        .sheet(isPresented: $isSharing) {
            ShareSheet(items: store.viewModel.getSharableObject().getAnyArray())
        }
    }
    
    var FoldersView: some View {
        NavigationView {
            FoldersViewComposer.foldersComposedWith(client: presenter.getStoredService(), currentProductFeature: presenter.getCurrentProductFeature(), bannerID: presenter.getADBannerID()) { selectedFolder in
                presenter.doneButtonTapped(withFolder: selectedFolder)
                showFoldersView.toggle()
            }
            .navigationTitle("TEXT_ANALYZER_CHOOSE_FOLDER_ACTION_TITLE")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("GENERIC_CLOSE_ACTION") {
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

    let googleClient: GoogleAILLMClient = makeGoogleGeminiAIClient(modelName: AIModelType.gemini_2_0_flash.rawValue)
    
    let summaryClient = SummaryClient(summariseService: googleClient)
    let idLanguage = AppleIdentificationLanguage()
    let trClient = TranslateClient(translateService: googleClient, identificationLanguageClient: idLanguage, localeToTranslate: .current)
    
    let service = TextAnalyzerService(summaryClient: summaryClient, translateClient: trClient, storageClient: getFakeStorage())
    var currentAppProductFeature: ProductFeature = ProductFeature(features: [.complexAIModel], productID: "")

    let textAnalyzerPresenter = TextAnalyzerPresenter(delegate: textAnalyzerStore, service: service, scannedResult: scanResult, currentProductFeature: currentAppProductFeature, bannerID: "ca-app-pub-3940256099942544/2435281174", bundle: bundle)
    
    TextAnalyzerView(store: textAnalyzerStore, presenter: textAnalyzerPresenter, resourceBundle: bundle)
}
