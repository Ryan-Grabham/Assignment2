import UIKit

class NewProjectViewController: UIViewController {
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDate.datePickerMode = .date
        endDate.datePickerMode = .date
        
    }
    
    
    @IBAction func addProjectButtonPressed(_ sender: UIButton) {
        guard let name = projectName.text, !name.isEmpty,
              let description = projectDescription.text, !description.isEmpty,
              let start_date = startDate?.date,
              let end_date = endDate?.date else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedStartDate = dateFormatter.string(from: start_date)
        let formattedEndDate = dateFormatter.string(from: end_date)
        
        let parameters: [String: Any] = ["user_id": UserData.shared.currentUser?.id ?? "", "name": name, "description": description, "start_date": start_date, "end_date": end_date]
        
        let url = "http://127.0.0.1:5000/api/projects/add"
        
        
        var project = Project()
        project.name = name
        project.description = description
        project.start_date = formattedStartDate
        project.end_date = formattedEndDate
        
        URLSession.shared.postData(project, urlString: url) { (result: Result<Project, Error>) in
            switch result {
            case .success(let result):
                print(result)

                
                DispatchQueue.main.async {
                    self.errorLabel.text = "Project Added!"
                    let uservc = (self.storyboard?.instantiateViewController(withIdentifier: "UserVC"))!
                    self.navigationController?.pushViewController(uservc, animated: true)
                    
                }
                
                
            case .failure(let error):
                print("Failed To Add New Project ")
                DispatchQueue.main.async {
                    self.errorLabel.text = "Error!"
                }
                
                /*
                 do {
                 let json = try JSONSerialization.jsonObject(with: data, options: [])
                 if let dict = json as? [String: Any],
                 let addSuccess = dict["Add_Success"] as? Bool,
                 addSuccess == true {
                 print("New Project Added")
                 DispatchQueue.main.async {
                 self.errorLabel.text = "Project Added!"
                 let uservc = (self.storyboard?.instantiateViewController(withIdentifier: "UserVC"))!
                 self.navigationController?.pushViewController(uservc, animated: true)
                 
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
                 */
                
            }
        }
    }
    
}
