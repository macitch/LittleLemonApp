import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    // Input fields
    @Published var firstName   = ""
    @Published var lastName    = ""
    @Published var email       = ""
    @Published var phoneNumber = ""
    
    // Validation state
    @Published var showError    = false
    @Published var errorMessage: String?
    
    // Form‐validity publisher you can bind to your button’s disabled state
    @Published private(set) var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Combine all four inputs to compute overall validity
        Publishers
            .CombineLatest4($firstName, $lastName, $email, $phoneNumber)
            .map { first, last, email, phone in
                !first.trimmingCharacters(in: .whitespaces).isEmpty &&
                !last.trimmingCharacters(in: .whitespaces).isEmpty &&
                Self.isValidEmail(email) &&
                (phone.isEmpty || Self.isValidPhone(phone))
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    /// Call this when user taps “Register”
    func validate() -> Bool {
        // All required?
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
              !email.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errorMessage = "All fields are required."
            showError = true
            return false
        }
        
        // Email format
        guard Self.isValidEmail(email) else {
            errorMessage = "Invalid email address."
            showError = true
            return false
        }
        
        // Phone if provided
        if !phoneNumber.isEmpty && !Self.isValidPhone(phoneNumber) {
            errorMessage = "Invalid phone number format."
            showError = true
            return false
        }
        
        // All good
        showError = false
        errorMessage = nil
        return true
    }
    
    // MARK: – Validation helpers
    
    private static func isValidEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@", omittingEmptySubsequences: true)
        guard parts.count == 2, parts[1].contains(".") else { return false }
        return true
    }
    
    private static func isValidPhone(_ phone: String) -> Bool {
        guard phone.first == "+" else { return false }
        let digits = phone.dropFirst()
        return !digits.isEmpty && digits.allSatisfy(\.isNumber)
    }
}
