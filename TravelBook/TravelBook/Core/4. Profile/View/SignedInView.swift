//
//  ProfileView.swift
//  TravelBook
//
//  Created by ddorsat on 03.01.2026.
//

import SwiftUI

struct SignedInView: View {
    @ObservedObject var vm: ProfileViewModel
    let user: UserModel
    @State private var showSignOutConfirmation = false

    var body: some View {
        ZStack {
            Components.backgroundColor()

            ScrollView {
                VStack(alignment: .leading, spacing: Components.isProMax(16, 14)) {
                    VStack(spacing: 15) {
                        Text(user.name.prefix(2).uppercased())
                            .font(.title)
                            .foregroundStyle(.white)
                            .fontWeight(.heavy)
                            .padding(25)
                            .background(LinearGradient(colors: [.purple,
                                                                .pink.opacity(0.7)],
                                                       startPoint: .top,
                                                       endPoint: .bottom))
                            .clipShape(Circle())

                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(
                            "Путешественник с \(user.dateRegistered.customMonthYear())"
                        )
                        .font(.system(size: 14))
                        .foregroundStyle(.blackAndWhite)
                        .fontWeight(.medium)
                    }
                    .padding(22)
                    .frame(maxWidth: .infinity)
                    .backgroundWithShape(20)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("СОВЕТ ДНЯ")
                            .fontWeight(.heavy)

                        Text("""
                             "Путешествия - это не только места, которые вы посещаете, но и моменты, которые остаются с вами навсегда."
                             """)
                        .font(Components.isProMax(.callout, .footnote))
                        .italic()
                        .fontWeight(.medium)
                    }
                    .foregroundStyle(.white)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [.quoteColorOne,
                                                        .quoteColorTwo],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 15))


                    VStack(alignment: .leading, spacing: Components.isProMax(12, 10)) {
                        ProfileCellView(type: .appearance) {
                            vm.profileRoutes.append(.appearance)
                        }

                        ProfileCellView(type: .aboutApp) {
                            vm.profileRoutes.append(.aboutApp)
                        }

                        ProfileCellView(type: .logOut) {
                            showSignOutConfirmation = true
                        }
                    }
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .scrollContentBackground(.hidden)
            .alert("Выйти из аккаунта?", isPresented: $showSignOutConfirmation) {
                Button("Отмена", role: .cancel) {}
                Button("Выйти", role: .destructive) {
                    vm.signOut()
                }
            }
        }
    }
}


#Preview {
    SignedInView(vm: ProfileViewModel(authService: AuthService()), user: .mock)
}
