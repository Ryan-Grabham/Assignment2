import UIKit

class NewProjectViewController: UIViewController {
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    @IBOutlet weak var errorLabel: UILabel!

   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func addProjectButtonPressed(_ sender: UIButton) {
        guard let name = projectName.text, !name.isEmpty,
              let description = projectDescription.text, !description.isEmpty,
              let start_date = startDate?.date.description,
              let end_date = endDate?.date.description else {
            return
        }
        
        let parameters: [String: Any] = ["user_id": UserData.shared.currentUser?.id ?? "", "name": name, "description": description, "start_date": start_date, "end_date": end_date]

        guard let url = URL(string: "http://127.0.0.1:5000/api/projects/add") else {
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
                   let registerSuccess = dict["projectAdd_Success"] as? Bool,
                   registerSuccess == true {
                    print("New Project Added")
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Success!"
                        let menuvc = (self.storyboard?.instantiateViewController(withIdentifier: "MenuVC"))!
                        self.navigationController?.pushViewController(menuvc, animated: true)
                    }

                } else {
                    print("Failed To Add New Project ")
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
