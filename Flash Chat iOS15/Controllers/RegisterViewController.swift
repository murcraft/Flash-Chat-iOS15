
import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextfield.text, !password.isEmpty else {
            showErrorAlert(message: "Email and password fields cannot be empty.")
            return
        }
        
        guard isValidEmail(email) else {
            showErrorAlert(message: "The email address is badly formatted.")
            return
        }

        if let passwordError = validatePassword(password) {
            showErrorAlert(message: "Password does not match the requirements:\n\n\(passwordError)")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // Ensure UI updates are on the main thread
            DispatchQueue.main.async {
                if let e = error {
                    // Check for the specific "email already in use" error code
                    if let authErrorCode = AuthErrorCode(rawValue: (e as NSError).code) {
                        if authErrorCode == .emailAlreadyInUse {
                            self.showErrorAlert(message: "This email address is already registered. Please try logging in instead.")
                            return
                        }
                    }
                    
                    self.showErrorAlert(message: e.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: "RegisterToChat", sender: self)
            }
        }
        
/*
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Failed to create user: \(error)")
                    return
                }
                self.performSegue(withIdentifier: "RegisterToChat", sender: self)
            }
        }
*/
    }
    
}

// MARK: - Validation & Error Handling Helpers
private extension RegisterViewController {
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Registration Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> String? {
        if password.count < 6 {
            return "Minimum password length is 6 characters."
        }
        if !password.contains(where: { $0.isLowercase }) {
            return "Lowercase character required."
        }
        if !password.contains(where: { $0.isUppercase }) {
            return "Uppercase character required."
        }
        if !password.contains(where: { $0.isNumber }) {
            return "Numeric character required."
        }
        if password.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil {
            return "Non-alphanumeric character required (e.g., !, @, #, $)."
        }
        return nil
    }
}
