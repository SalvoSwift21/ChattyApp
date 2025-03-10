//
//  SideMenuView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/10/24.
//

import Foundation
import SwiftUI

public struct SideMenu: View {
   
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    public init(isShowing: Binding<Bool>, content: AnyView, edgeTransition: AnyTransition = .move(edge: .leading)) {
        self._isShowing = isShowing
        self.content = content
        self.edgeTransition = edgeTransition
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(
                        Color.clear
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}



public struct SideMenuView: View {
    var presenter: SideMenuPresenter
    @ObservedObject var store: SideMenuStore

    var resourceBundle: Bundle
    
//    @Binding var presentSideMenu: Bool
    
    public init(store: SideMenuStore, presenter: SideMenuPresenter, resourceBundle: Bundle = .main) {
        self.store = store
        self.presenter = presenter
        self.resourceBundle = resourceBundle
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .center) {
                switch store.state {
                case .loaded(let viewModel):
                    ScrollView {
                        VStack(alignment: .leading, spacing: 42) {
                            HStack {
                                Image("side_menu_logo", bundle: resourceBundle)
                                Spacer()
                            }
                            
                            ForEach(viewModel.sections, id: \.id) { section in
                                SectionView(section: section)
                            }
                        }
                    }
                    .scrollIndicators(.never)
                }
            }
            .padding(.vertical, 100)
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width/1.5) //270
            .background(.mainBackground)
            .task {
                await presenter.loadData()
            }
            Spacer()
        }.background(.clear)
    }
    
    func SectionView(section: MenuSection) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            if let title = section.title {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundStyle(.title)
            }
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(section.rows, id: \.id) { row in
                    RowView(row: row)
                }
            }
        }
    }
    
    func RowView(row: MenuRow) -> some View {
        VStack {
            Button(action: {
                presenter.didSelectRow?(row)
            }, label: {
                HStack {
                    Image(row.imageName, bundle: resourceBundle)
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .center)
                    
                    Text(LocalizedStringKey(row.title))
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.title)
                    
                    Spacer()
                }
            })
            
            Divider()
        }
    }
}


#Preview {
    
    @State var isMenuShown = false
    @State var selectedSideMenuTab = SideMenuRowType.home
    
    return ZStack {
        create() { row in
            selectedSideMenuTab = row.rowType
            isMenuShown.toggle()
        }
    }
}


func create(didSelectRow: @escaping (MenuRow) -> Void = { _ in }) -> SideMenu {
    let bundle = Bundle.init(identifier: "com.ariel.ScanUI") ?? .main
    let menuStore = SideMenuStore()
    let menuService = LocalSideMenuService(resourceBundle: bundle)
    
    let sideMenuPresenter = SideMenuPresenter(delegate: menuStore, service: menuService, didSelectRow: didSelectRow, bundle: bundle)
    
    let menu = SideMenuView(store: menuStore, presenter: sideMenuPresenter, resourceBundle: bundle)
    return SideMenu(isShowing: .constant(true), content: AnyView(menu))
}
