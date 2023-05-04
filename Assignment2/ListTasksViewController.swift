import UIKit

class ListTasksViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var projectId : Int?
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projectId = DataManager.shared.projectId!
        
        guard let id = self.projectId else { return }
        print(id)
        
        let url = URL(string: "http://127.0.0.1:5000/api/tasks/get/byprojectid?id=\(id)")
        
        URLSession.shared.fetchData(for: url!) { (result: Result<[Task], Error>) in
            switch result {
            case .success(let results):
                self.tasks.append(contentsOf: results)
            case .failure(let error):
                print(error)
                print("ERROR")
            }
            
            var projectText = ""
            self.tasks.forEach { task in
                            projectText += "Project Name: \(task.name)\n"
                            projectText += "Project Id \(task.id)\n"
                            projectText += "Due Date: \(task.due_date)\n"
                            projectText += "Description: \(task.description)\n\n"
            }
            print(projectText)
            
            DispatchQueue.main.async {
                self.textView.text = projectText
            }
           
        }

    }


}

