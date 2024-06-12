//
//  ChatTextView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 09/06/24.
//

import SwiftUI


struct ChatTextView: View {
    
    var viewModel: ChatCellViewModel
    
    var body: some View {
        switch viewModel.position {
        case .left:
            HStack(spacing: nil, content: {
                ChatView
                Spacer(minLength: 35.0)
            })
        case .right:
            HStack(spacing: nil, content: {
                Spacer(minLength: 35.0)
                ChatView
            })
        }
    }
    
    var ChatView: some View {
        VStack(alignment: .leading) {
            if let title = viewModel.title {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.title)
                    .multilineTextAlignment(.leading)
            }
            
            
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 120.0)
            }
            
            if let description = viewModel.description {
                Text(description)
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(viewModel.backgroundColor)
        .cornerRadius(5)
        .shadow(radius: 5.0)
    }
}

#Preview {
    ScrollView {
        
        ChatTextView(viewModel: ChatCellViewModel(title: "Summury text",
                                                  description: nil,
                                                  image: UIImage(named: "FakeImage", in: Bundle.init(identifier: "com.ariel.ScanUI") ?? .main, with: nil),
                                                  backgroundColor: .white,
                                                  position: .left))
        
        
        ChatTextView(viewModel: ChatCellViewModel(title: nil,
                                                  description: "But I must explain to you how all this mistaken idea of denouncing pleasure and praisingmely painful. Nor again is there toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?",
                                                  image: nil,
                                                  backgroundColor: .prime.opacity(0.7),
                                                  position: .right))
    }
    .padding()
    .background(.white)
}
