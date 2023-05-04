import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var dueDateField: UIDatePicker!
    @IBOutlet var errorLabel: UILabel!
    
    var projectId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Project ID")
        self.projectId = DataManager.shared.projectId!
        print(self.projectId)
        
    }
    
    
    @IBAction func addTask(_ sender: Any) {
        //Need to pass in a name, description, due date, status and a project id.
        guard let name = nameField.text, !name.isEmpty,
              let description = descriptionField.text, !description.isEmpty,
              let due_date = dueDateField?.date.description
              else {
            return
        }
        
        guard let id = self.projectId else { return }
        print(id)
        let parameters: [String: Any] = ["project_id": id , "name": name, "description": description, "due_date": due_date, "status": "In Progress"]
        guard let url = URL(string: "http://127.0.0.1:5000/api/tasks/add") else {
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
                    let addSuccess = dict["Add_Success"] as? Bool,
                    addSuccess == true {
                    print("New Task Added")
                    
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Task Added!"
                        let taskVC = (self.storyboard?.instantiateViewController(withIdentifier: "taskVC"))!
                        self.navigationController?.pushViewController(taskVC, animated: true)
                    }
                    
                } else {
                    print("Failed To Add New Task ")
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
