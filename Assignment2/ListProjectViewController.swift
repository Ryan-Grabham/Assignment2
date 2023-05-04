
import UIKit

class ListProjectViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    var projects: [Project] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
 
        let projectId = DataManager.shared.projectId
        let userId = UserData.shared.currentUser!.id
        print(userId)
        
        let url = URL(string: "http://127.0.0.1:5000/api/projects/get/byuserid?id=\(userId)")!
        
        URLSession.shared.fetchData(for: url) { (result: Result<[Project], Error>) in
            switch result {
            case .success(let results):
                self.projects.append(contentsOf: results)
                print(results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
    
extension ListProjectViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = projects[indexPath.row].name + " - " + projects[indexPath.row].description
        cell.detailTextLabel?.text = "Due: " + projects[indexPath.row].end_date
   
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editProjectVC = storyboard.instantiateViewController(withIdentifier: "editProjectVC") as! EditProjectViewController
        editProjectVC.project = project
        DataManager.shared.projectId = project.id
        navigationController?.pushViewController(editProjectVC, animated: true)
        
    }
}
