//
//  ViewController.swift
//  Assignment2
//
//  Created by Ryan Grabham (Student) on 19/04/2023.
//

import UIKit


class ListProjectViewController: UICollectionViewController {
    
    var dataSource: DataSource!
    var projects: [Project] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView){
            (collectionView: UICollectionView, indexPath, itemIdentifier: String ) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: <#T##IndexPath#>, item: itemIdentifier)
        }
        
        collectionView.dataSource = dataSource
        
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        
        let url = URL(string: "http://127.0.0.1:5000/api/projects/get/all")!
        URLSession.shared.fetchData(for: url) { (result: Result<[Project], Error>) in
            switch result {
            case .success(let results):
                self.projects.append(contentsOf: results)
                print(results)
                
            case .failure(let error):
                print(error)
            }
        }
       /*
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return projects.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "allCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "allCell")
            
            let project = projects[indexPath.row]
            cell.textLabel?.text = project.name
            cell.detailTextLabel?.text = project.description
            
            return cell
        }*/
    
    
}
}
