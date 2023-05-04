import UIKit

class ProjectViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //callAPI()
        decodeAPI(forUserId: UserData.shared.currentUser!.id)
        
        
    }
    
    func callAPI()
    {
        guard let url = URL(string: "http://127.0.0.1:5000/api/projects/get/all") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
            
        if let data = data , let string = String(data: data, encoding: .utf8) {
                print(string)
            }
            
        }
        task.resume()
    }
    
    func decodeAPI(forUserId userId: Int){
        guard let url = URL(string: "http://localhost:5000/api/projects/get/byuserid?id=\(userId)") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()
            
            var projectText : String = ""
            if let data = data {
                do {
                    
                    let tasks = try decoder.decode([Projects].self, from: data)
                    
                    tasks.forEach { project in
                                    projectText += "Project Name: \(project.name)\n"
                                    projectText += "Project Id \(project.id)\n"
                                    projectText += "Start Date: \(project.start_date) |  End Date: \(project.end_date)\n"
                                    projectText += "User Id \(project.user_id)\n"
                                    projectText += "Description: \(project.description)\n\n"
                    }
                    print(projectText)
                    
                    DispatchQueue.main.async {
                        self.addText(TextToWrite: projectText)
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        
    }
    
    func addText(TextToWrite: String){
        textView.text = TextToWrite
    }
    
    struct Projects:Codable{
        let description: String
        let end_date : String
        let id : Int
        let name : String
        let start_date : String
        let user_id : Int
    }
}
