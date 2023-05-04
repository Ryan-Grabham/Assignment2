import UIKit

class EditProjectViewController: UIViewController {

    var project: Project?
    
    @IBOutlet var projectName: UILabel!
    @IBOutlet var editName: UITextField!
    @IBOutlet var editStartDate: UIDatePicker!
    @IBOutlet var editDescription: UITextField!
    @IBOutlet var editEndDate: UIDatePicker!
    @IBOutlet var errorMsg: UILabel!
    
 
    
    let dateFormatter = DateFormatter()
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /* if segue.identifier == "TasksSegue" {
            let ViewTasksVC = segue.destination as! ViewTasksViewController
            ViewTasksVC.projectId = self.project?.id
        }*/
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          guard let project = project else {
              return
          }
          
        projectName.text = "Details for: " + project.name
        editName.text = project.name
        editDescription.text = project.description
          
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
          
          // Convert the start date string to a Date and set the UIDatePicker
          if let defaultStartDate = dateFormatter.date(from: project.start_date) {
              print("defaultStartDate: \(defaultStartDate)")
              editStartDate.setDate(defaultStartDate, animated: false)
          } else {
              print("Error: Invalid start date format")
          }
          
          // Convert the end date string to a Date and set the UIDatePicker
          if let defaultEndDate = dateFormatter.date(from: project.end_date) {
              editEndDate.setDate(defaultEndDate, animated: false)
          } else {
              print("Error: Invalid end date format")
          }

    }
    
    @IBAction func EditProject(_ sender: UIButton) {
        guard let nameUpdate = editName.text,
              let descUpdate = editDescription.text,
              let startdatepicked = editStartDate?.date,
              let enddatepicked = editEndDate?.date
        else{
            self.errorMsg.textColor = .red
            self.errorMsg.text = "Please ensure all fields are filled"
            return
        }
        
        let startdateUpdate = self.dateFormatter.string(from: startdatepicked)
        
        let enddateUpdate = self.dateFormatter.string(from: enddatepicked)
        
    
        guard let userId  = self.project?.user_id,
              let projectId  = self.project?.id else {
            print("couldn't get ids for user and project")
            return
        }
        
        let theProject = Project(id: projectId, name: nameUpdate, description: descUpdate, start_date: startdateUpdate, end_date: enddateUpdate, user_id: userId)
        
        print(theProject)
            let url = "http://127.0.0.1:5000/api/projects/update"
                
            URLSession.shared.postData(theProject, urlString: url) {(result: Result<Project, Error>) in
            switch result {
            case .success(let updatedProject):
                DispatchQueue.main.async {
                    self.project = updatedProject
                    self.errorMsg.textColor = .green
                    self.errorMsg.text = "Project updated successfully"
                    let uservc = (self.storyboard?.instantiateViewController(withIdentifier: "UserVC"))!
                    self.navigationController?.pushViewController(uservc, animated: true)
                    
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.errorMsg.textColor = .red
                    self.errorMsg.text = "Failed to update project"
                }
            }

        }



    }
}
