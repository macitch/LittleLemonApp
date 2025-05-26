/*
*  File: UserProfile.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI

struct UserProfileView: View {
    // MARK: – ViewModel & Dismiss
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss

    // MARK: – Persisted storage
    @AppStorage(kFirstName)       private var storedFirstName    = ""
    @AppStorage(kLastName)        private var storedLastName     = ""
    @AppStorage(kEmail)           private var storedEmail        = ""
    @AppStorage(kPhoneNumber)     private var storedPhoneNumber  = ""
    @AppStorage(kIsLoggedIn)      private var isLoggedIn         = false

    @AppStorage(kOrderStatuses)   private var storedOrderStatuses   = true
    @AppStorage(kPasswordChanges) private var storedPasswordChanges = true
    @AppStorage(kSpecialOffers)   private var storedSpecialOffers   = true
    @AppStorage(kNewsletter)      private var storedNewsletter      = true

    // MARK: – Local editing state for toggles
    @State private var orderStatuses   = true
    @State private var passwordChanges = true
    @State private var specialOffers   = true
    @State private var newsletter      = true

    // MARK: – Logout navigation
    @State private var isLoggedOut = false

    // MARK: – Keyboard focus
    @FocusState private var focusedField: Field?
    private enum Field: Hashable { case firstName, lastName, email, phoneNumber }

    var body: some View {
        ScrollView {
            // “Log out” nav link
            NavigationLink("", destination: OnboardingView(), isActive: $isLoggedOut)

            VStack(spacing: 24) {
                // Profile picture
                VStack(alignment: .leading, spacing: 8) {
                    Text("Avatar")
                        .onboardingTextStyle()
                    HStack(spacing: 16) {
                        Image("profile-image-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        VStack(){
                            Button("Change") { /* … */ }
                                .buttonStyle(OutlinedButtonStyle.primary)
                            Button("Remove") { /* … */ }
                                .buttonStyle(OutlinedButtonStyle.primaryReversed)
                            Spacer()
                        }
                        Spacer()
                    }
                }

                Group {
                    LabelledTextField(label: "First name",   text: $viewModel.firstName)
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .lastName }

                    LabelledTextField(label: "Last name",    text: $viewModel.lastName)
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }

                    LabelledTextField(label: "E-mail",       text: $viewModel.email,       keyboard: .emailAddress)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .phoneNumber }

                    LabelledTextField(label: "Phone number", text: $viewModel.phoneNumber, keyboard: .phonePad)
                        .focused($focusedField, equals: .phoneNumber)
                        .submitLabel(.done)
                }
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)

                // Notification toggles
                Text("Email notifications")
                    .font(.regularText())
                    .foregroundColor(.primaryColor1)
                    .padding(.top, 12)

                VStack(spacing: 12) {
                    Toggle("Order statuses",   isOn: $orderStatuses)
                    Toggle("Password changes", isOn: $passwordChanges)
                    Toggle("Special offers",   isOn: $specialOffers)
                    Toggle("Newsletter",       isOn: $newsletter)
                }
                .padding(.horizontal)


                VStack(spacing: 16) {
                    Button("Log out") {
                        // Clear all persisted data
                        storedFirstName       = ""
                        storedLastName        = ""
                        storedEmail           = ""
                        storedPhoneNumber     = ""
                        storedOrderStatuses   = false
                        storedPasswordChanges = false
                        storedSpecialOffers   = false
                        storedNewsletter      = false
                        isLoggedOut = true
                    }
                    .buttonStyle(FilledButtonStyle.yellowWide)

                    HStack(spacing: 16) {

                        Button("Discard Changes") {
                            viewModel.firstName   = storedFirstName
                            viewModel.lastName    = storedLastName
                            viewModel.email       = storedEmail
                            viewModel.phoneNumber = storedPhoneNumber

                            orderStatuses   = storedOrderStatuses
                            passwordChanges = storedPasswordChanges
                            specialOffers   = storedSpecialOffers
                            newsletter      = storedNewsletter

                            dismiss()
                        }
                        .buttonStyle(OutlinedButtonStyle.primaryReversed)

                        Button("Save changes") {
                            if viewModel.validate() {
                                storedFirstName       = viewModel.firstName
                                storedLastName        = viewModel.lastName
                                storedEmail           = viewModel.email
                                storedPhoneNumber     = viewModel.phoneNumber
                                storedOrderStatuses   = orderStatuses
                                storedPasswordChanges = passwordChanges
                                storedSpecialOffers   = specialOffers
                                storedNewsletter      = newsletter
                                dismiss()
                            }
                        }
                        .buttonStyle(OutlinedButtonStyle.primary)
                        .disabled(!viewModel.isFormValid)
                    }
                }
                .padding(.horizontal)

                if viewModel.showError, let msg = viewModel.errorMessage {
                    Text(msg)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .transition(.slide)
                }
            }
            .padding(.vertical)
        }
        .padding()
        .scrollDismissesKeyboard(.interactively)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("Personal information")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            viewModel.firstName   = storedFirstName
            viewModel.lastName    = storedLastName
            viewModel.email       = storedEmail
            viewModel.phoneNumber = storedPhoneNumber

            orderStatuses   = storedOrderStatuses
            passwordChanges = storedPasswordChanges
            specialOffers   = storedSpecialOffers
            newsletter      = storedNewsletter
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environment(\.managedObjectContext,
                         PersistenceController.preview.container.viewContext)
    }
}
