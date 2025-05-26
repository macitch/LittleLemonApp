/*
*  File: Onboarding.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI

struct OnboardingView: View {
    // MARK: – Persisted storage
    @AppStorage(kFirstName)      private var storedFirstName    = ""
    @AppStorage(kLastName)       private var storedLastName     = ""
    @AppStorage(kEmail)          private var storedEmail        = ""
    @AppStorage(kPhoneNumber)    private var storedPhoneNumber  = ""
    @AppStorage(kIsLoggedIn)     private var isLoggedIn         = false

    // MARK: – ViewModel & focus
    @StateObject private var viewModel   = OnboardingViewModel()
    @FocusState  private var focusedField: Field?
    private enum Field: Hashable { case firstName, lastName, email, phoneNumber }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Header()
                    Hero()
                        .padding()
                        .background(Color.primaryColor1)
                        .frame(maxWidth: .infinity, maxHeight: 240)

                    // Input form
                    VStack(spacing: 16) {
                        LabelledTextField(label: "First name *", text: $viewModel.firstName)
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .lastName }

                        LabelledTextField(label: "Last name *", text: $viewModel.lastName)
                            .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }

                        LabelledTextField(label: "E-mail *", text: $viewModel.email, keyboard: .emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .phoneNumber }

                        LabelledTextField(label: "Phone number", text: $viewModel.phoneNumber, keyboard: .phonePad)
                            .focused($focusedField, equals: .phoneNumber)
                            .submitLabel(.done)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)

                    if viewModel.showError, let msg = viewModel.errorMessage {
                        Text(msg)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .transition(.slide)
                    }

                    // Register button with debug prints
                    Button("Register") {
                        print("[Debug] Register tapped. \nfirstName=\(viewModel.firstName), lastName=\(viewModel.lastName), email=\(viewModel.email), phone=\(viewModel.phoneNumber)")
                        let valid = viewModel.validate()
                        print("[Debug] Validation result: \(valid)")
                        if valid {
                            print("[Debug] Validation passed, storing values...")
                            storedFirstName   = viewModel.firstName
                            storedLastName    = viewModel.lastName
                            storedEmail       = viewModel.email
                            storedPhoneNumber = viewModel.phoneNumber
                            print("[Debug] Stored: firstName=\(storedFirstName), lastName=\(storedLastName), email=\(storedEmail), phone=\(storedPhoneNumber)")
                            isLoggedIn = true
                            print("[Debug] isLoggedIn set to true")
                        } else if let error = viewModel.errorMessage {
                            print("[Debug] Validation failed with error: \(error)")
                        }
                    }
                    .buttonStyle(FilledButtonStyle.yellowWide)
                    //.disabled(!viewModel.isFormValid)
                    .padding(.horizontal)
                }.onChange(of: viewModel.isFormValid) { newVal in
                    print("[🔎] viewModel.isFormValid changed to \(newVal)")
                }
                .padding(.vertical)
            }
            .navigationTitle("Welcome")
            .navigationBarBackButtonHidden()
            .scrollDismissesKeyboard(.interactively)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                print("[Debug] OnAppear loading stored values: firstName=\(storedFirstName), lastName=\(storedLastName), email=\(storedEmail), phone=\(storedPhoneNumber)")
                viewModel.firstName   = storedFirstName
                viewModel.lastName    = storedLastName
                viewModel.email       = storedEmail
                viewModel.phoneNumber = storedPhoneNumber
                
                for family in UIFont.familyNames.sorted() {
                    print("Family: \(family)")
                    for name in UIFont.fontNames(forFamilyName: family) {
                        print("    Font: \(name)")
                    }
                }
            }
            // Programmatic navigation to Home
            .navigationDestination(isPresented: $isLoggedIn) {
                Home()
            }
        }
    }
}

// MARK: – Reusable labelled TextField

struct LabelledTextField: View {
    let label: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .onboardingTextStyle()
            TextField(label, text: $text)
                .keyboardType(keyboard)
                .textFieldStyle(.roundedBorder)
        }
    }
}

// MARK: – Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
