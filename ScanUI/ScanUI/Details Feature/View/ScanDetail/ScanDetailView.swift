//
//  UploadFileView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 10/01/24.
//

import SwiftUI

public struct ScanDetailView: View {

    @Environment(\.presentationMode) var presentation

    var presenter: ScanDetailPresenter
    @ObservedObject var store: ScanDetailStore
    @State private var showingCopyConfirmView = false

    var resourceBundle: Bundle
    
    public init(store: ScanDetailStore, presenter: ScanDetailPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                switch store.state {
                case .loading(let showLoader):
                    if showLoader {
                        LoadingView()
                    }
                case .loaded(let viewModel):
                    ZStack(content: {
                        VStack {
                            makeDetailView(viewModel: viewModel)
                            
                            VStack(spacing: 5) {
                                HStack {
                                    makeMenuActions(viewModel: viewModel)
                                    Spacer()
                                }.padding(.horizontal)
                                
                                if presenter.showADBanner() {
                                    ExternalBannerView(addUnitID: presenter.getADBannerID())
                                }
                            }
                        }
                        
                        if showingCopyConfirmView {
                            FlashAlert(title: "GENERIC_COPY_CLIPBOARD_ACTION", image: Image(systemName: "checkmark.circle.fill"))
                        }
                    })
                    .navigationTitle(viewModel.scan.title)
                    .navigationBarTitleDisplayMode(.inline)
                }
                Spacer()
            }
            
            if let errorMessage = store.errorMessage {
                ErrorView(title: "GENERIC_ERROR_TITLE", description: errorMessage,
                          primaryButtonTitle: "GENERIC_RELOAD_ACTION",
                          primaryAction: {
                    Task {
                        await presenter.loadData()
                    }
                }, secondaryButtonTitle: "GENERIC_BACK_ACTION",
                          secondaryAction: {
                    presentation.wrappedValue.dismiss()
                })
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
    
    func makeDetailView(viewModel: ScanDetailViewModel) -> some View {
        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25, content: {
                
                if let image = viewModel.scan.mainImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 5))
                        .shadow(radius: 5.0)
                        .frame(maxWidth: .infinity, maxHeight: 250, alignment: .leading)
                        .padding(.vertical)
                }
                
                ChatTextView(viewModel: ChatCellViewModel(title: nil,
                                                          description: viewModel.scan.contentText,
                                                          image: nil,
                                                          backgroundColor: .prime,
                                                          position: .full,
                                                          isInLoading: false))
                Spacer(minLength: 10)
                
            }).padding()
        }
    }
    
    func makeMenuActions(viewModel: ScanDetailViewModel) -> some View {
        ShareLink(
            item: viewModel.getSharableObject(),
            preview: SharePreview(
                viewModel.getSharableObject().description,
                image: viewModel.getSharableObject().image)) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .fontWeight(.regular)
                        .frame(width: 25, height: 30)
                        .foregroundColor(.prime)
                }
    }
}

#Preview {
    
    let scan = Scan(title: "Test scan title",
                    contentText: "Lorem Ipsum è un testo segnaposto utilizzato nel settore della tipografia e della stampa. Lorem Ipsum è considerato il testo segnaposto standard sin dal sedicesimo secolo, quando un anonimo tipografo prese una cassetta di caratteri e li assemblò per preparare un testo campione. È sopravvissuto non solo a più di cinque secoli, ma anche al passaggio alla videoimpaginazione, pervenendoci sostanzialmente inalterato. Fu reso popolare, negli anni ’60, con la diffusione dei fogli di caratteri trasferibili “Letraset”, che contenevano passaggi del Lorem Ipsum, e più recentemente da software di impaginazione come Aldus PageMaker, che includeva versioni del Lorem Ipsum.", scanDate: .now,
                    mainImage: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil))
    @State var scanDetailStore = ScanDetailStore(state: .loaded(viewModel: ScanDetailViewModel(scan: scan)))
    var service = ScanDetailService(scan: scan)
    var product = ProductFeature(features: [], productID: "")

    @State var presenter = ScanDetailPresenter(delegate: scanDetailStore, service: service, currentProductFeature: product, bannerID: "12345678")
   
    return NavigationView {
        ScanDetailView(store: scanDetailStore, presenter: presenter, resourceBundle: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main)
    }
}
