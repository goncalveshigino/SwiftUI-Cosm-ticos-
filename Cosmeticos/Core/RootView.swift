//
//  RootView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 21/12/23.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ProductView()
                    //ProfileView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear {
            let authResult = try? AuthenticationManager.shared.getCurrentUser()
            self.showSignInView = authResult == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
