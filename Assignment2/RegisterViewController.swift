import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text else {
            return
        }
        guard !username.isEmpty || !password.isEmpty || !email.isEmpty else{
            return

        }
        let parameters = ["username": username, "password": password, "email": email]
        
        guard let url = URL(string: "http://127.0.0.1:5000/api/users/register") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                      print("Error: Invalid response")
                      return
                  }
            
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? [String: Any],
                   let registerSuccess = dict["Register_Success"] as? Bool,
                   registerSuccess == true {
                    print("User registration successful")
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Success!"
                        let loginvc = (self.storyboard?.instantiateViewController(withIdentifier: "LoginVC"))!
                        self.navigationController?.pushViewController(loginvc, animated: true)
                    }

                } else {
                    print("User registration failed")
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Error!"
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
