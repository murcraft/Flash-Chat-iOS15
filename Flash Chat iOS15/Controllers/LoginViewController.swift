
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextfield.text, !password.isEmpty else {
            showErrorAlert(message: "Email and password cannot be empty.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // Ensure UI updates are on the main thread
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                if let e = error {
                    let authErrorCode = AuthErrorCode(rawValue: (e as NSError).code)
                    
                    switch authErrorCode {
                    case .userNotFound:
                        strongSelf.showErrorAlert(message: "This email is not registered. Please sign up.")
                    case .wrongPassword:
                        strongSelf.showErrorAlert(message: "The password you entered is incorrect.")
                    default:
                        // For other errors (network issues, etc.)
                        strongSelf.showErrorAlert(message: "An error occurred. Please try again. \(e.localizedDescription)")
                    }
                    return
                }
                strongSelf.performSegue(withIdentifier: "LoginToChat", sender: self)
            }
        }
        
        
        /*        if let email = emailTextfield.text, let password = passwordTextfield.text {
         
         Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
         guard let strongSelf = self else { return }
         }
         }*/
        
    }
}

// MARK: - Error Handling Helper
private extension LoginViewController {
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
