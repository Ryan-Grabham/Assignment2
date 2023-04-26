//
//  ViewController.swift
//  Assignment2
//
//  Created by Ryan Grabham (Student) on 19/04/2023.
//

import UIKit


class ListProjectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = UserData.shared.currentUser!.id
        
        let urlString = "http://127.0.0.1:5000/api/projects/get/byuserid?id=\(userId)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.fetchData(for: url) { (result: Result<[Project], Error>) in
            switch result {
            case .success(let results):
                self.projects.append(contentsOf: results)
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
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "allCell")
        
        let project = projects[indexPath.row]
        cell.textLabel?.text = project.name
        cell.detailTextLabel?.text = project.description
        
        return cell
        
        
        
    }
    
}
