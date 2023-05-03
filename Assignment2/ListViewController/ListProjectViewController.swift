

import UIKit

private let reuseIdentifier = "Cell"

class ListProjectViewController: UICollectionViewController {
    
    var dataSource: DataSource!
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
                self.updateSnapshot()
            case .failure(let error):
                print(error)
            }
        }
        
        let listLayout = listLayout()
        
     
            collectionView.collectionViewLayout = listLayout
            
            let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
            
            dataSource = DataSource(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Project.ID) in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                
            }
            updateSnapshot()
            collectionView.dataSource = self.dataSource
        }
        
  
    
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = projects[indexPath.item].id
        pushDetailViewForProject(withId: id)
        return false
    }
    
    func pushDetailViewForProject(withId id: Project.ID) {
        let project = project(withId: id)
        let viewController = ProjectViewController(project: project)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
}

    

