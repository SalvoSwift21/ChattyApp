//
//  OnboardingView.swift
//  ScanUI
//
//  Created by Salvatore Milazzo on 05/12/23.
//

import SwiftUI

struct OnboardingView: View {
    var onboardingViewModel: OnboardingViewModel
    var resourceBundle: Bundle = .main
    var localizationBundle: Bundle = .main
    
    var body: some View {
        VStack(alignment: .center, spacing: 35) {
            Image(onboardingViewModel.image, bundle: resourceBundle)
                .frame(width: 250, height: 280, alignment: .center)
            HStack(content: {
                VStack(alignment: .leading, spacing: 10) {
                    Text(onboardingViewModel.title, bundle: localizationBundle)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(.title)
                    Text(onboardingViewModel.subtitle, bundle: localizationBundle)
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                        .foregroundStyle(.subtitle)
                }
                Spacer()
            })
        }.padding()
    }
}

#Preview {
    OnboardingView(onboardingViewModel: OnboardingViewModel(image: "onboarding 1", title: "Test Card", subtitle: "Test sub"))
}
