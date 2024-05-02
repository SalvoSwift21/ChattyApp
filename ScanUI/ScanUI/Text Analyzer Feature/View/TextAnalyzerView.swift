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
    }
    
    var CompleteTextView: some View {
        ZStack(alignment: .bottomLeading) {
            TextEditor(text: $store.viewModel.text)
                .foregroundStyle(.subtitle)
                .cornerRadius(10)
                .shadow(radius: 12)
                .padding(.bottom, 100)
            
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3), {
                        opacity = opacity == 0.0 ? 1.0 : 0.0
                        showMenu.toggle()
                    })
                }) {
                    if showMenu {
                        Image(systemName: "arrow.down")
                    } else {
                        Image(systemName: "arrow.up")
                    }
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 50, height: 50)))
                
                Spacer()
                                
                CircleAnimationView(centerImage: UIImage(named: "checkmark_white", in: self.resourceBundle, with: nil) ?? UIImage(), frame: .init(width: 90, height: 90))
                    .padding(.top, 10)
                    .onTapGesture {
                        presenter.done()
                    }
            }
            
            
            // Menu a tendina
            if showMenu {
                OptionsMenu
                    .padding(0)
                    .background(Color.clear)
                    .transition(.move(edge: .bottom))
                    .offset(x: 2.5, y: showMenu ? -80 : 0)
                    .opacity(opacity)
            }
        }
        .navigationTitle("Summary result")
        .onChange(of: $store.viewModel.text.wrappedValue) {
            presenter.updateScannedText(text: store.viewModel.text)
        }
    }
    
    
    var OptionsMenu: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Button(action: {
                    Task(priority: .background) {
                        await presenter.makeTranslation()
                    }
                }) {
                    Image(systemName: "bubble.left.and.text.bubble.right")
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 45, height: 45)))
                Text("Translate")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundStyle(.prime)
            }
            
            HStack(spacing: 8) {
                Button(action: {
                    presenter.copySummary()
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 45, height: 45)))
                Text("Copy")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundStyle(.prime)
            }
            
            HStack {
                Button(action: {
                    toggleIsOn.toggle()
                }) {
                    Image(systemName: "text.justify")
                }
                .buttonStyle(DefaultButtonStyle(frame: .init(width: 45, height: 45)))
                Text("Show Origianl")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundStyle(.prime)
                .onChange(of: toggleIsOn) {
                    if toggleIsOn {
                        presenter.showOriginalSummary()
                    } else {
                        presenter.showModifyText()
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
