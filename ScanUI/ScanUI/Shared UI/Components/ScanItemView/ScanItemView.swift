//
//  ScanItemView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 18/06/24.
//

import Foundation
import SwiftUI

struct ScanItemView: View {
    var resourceBundle: Bundle = .main
    var scan: Scan
    
    var showDivider: Bool = true
    var showShareButton: Bool = false
    
    @State var isSharing: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 15, content: {
                if let img = scan.mainImage {
                    Image(uiImage: img)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 60, height: 60)
                        .scaledToFill()
                        .clipShape(.rect(cornerRadius: 5.0))
                }
                
                VStack(alignment: .leading, spacing: 10, content: {
                    VStack(alignment: .leading, spacing: 5, content: {
                        Text(scan.title)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.title)
                            .lineLimit(2)
                        
                        Text("\(scan.scanDate.recentScanMode())")
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.subtitle)
                            .lineLimit(1)
                    })
                    
                    if showShareButton {
                        Button {
                            isSharing.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(.prime)
                                    .frame(width: 18, height: 18)
                                
                                Text("GENERIC_SHARE_ACTION")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.prime)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                        }
                    }

                })
                
                Spacer()
                  
            })
            
            if showDivider {
                Divider()
            }
        }
        .sheet(isPresented: $isSharing) {
            ShareSheet(items: getSharableObject(scan: scan).getAnyArray())
        }
    }
    
    fileprivate func getSharableObject(scan: Scan) -> ScanSharableModel {
        return ScanSharableModel(image: scan.mainImage, description: scan.contentText)
    }
}

#Preview {
    VStack {
        ScanItemView(resourceBundle: Bundle(identifier: "com.ariel.ScanUI") ?? .main,
                     scan: Scan(title: "Test scan title",
                                contentText: "Test conten", scanDate: .now,
                                mainImageData: UIImage(named: "default_scan", in: Bundle(identifier: "com.ariel.ScanUI"), with: nil)?.pngData()))
    }.padding()
}
