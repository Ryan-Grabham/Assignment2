//
//  ProjectListViewController+DataSource.swift
//  Assignment2
//
//  Created by Ryan Grabham (Student) on 03/05/2023.
//

import UIKit

extension ListProjectViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Project.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int,  Project.ID>
    
    var projectCompletedValue: String {
        NSLocalizedString("Completed", comment: "Project Completed Value")
    }
    var projectNotCompletedValue: String {
        NSLocalizedString("Not Completed", comment: "Project Not Completed Value")
    }
    
    func updateSnapshot(reloading ids: [Project.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(projects.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Project.ID){
        let project = project(withId: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = project.name
        contentConfiguration.secondaryText = project.isComplete ? "Complete" : "In progress"
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(
            forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: project)
        doneButtonConfiguration.tintColor = #colorLiteral(red: 0.6932216883, green: 0.6982113123, blue: 0.998565495, alpha: 1)
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: project)]
        cell.accessibilityValue = project.isComplete ? projectCompletedValue : projectNotCompletedValue
        cell.accessories = [.customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = #colorLiteral(red: 0.9354767203, green: 0.9454274774, blue: 1, alpha: 1)
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    func project(withId id: Project.ID) -> Project {
        let index = projects.indexOfProject(withId: id)
        return projects[index]
    }
    
    func updateProject(_ project: Project) {
        let index = projects.indexOfProject(withId: project.id)
        projects[index] = project
    }
    
    func completeProject(withId id: Project.ID) {
        var project = project(withId: id)
        project.isComplete.toggle()
        updateProject(project)
        updateSnapshot(reloading: [id])
        
        let urlString = "http://127.0.0.1:5000/api/projects/update/\(project.id)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(project) else {
            print("Unable to encode project to JSON")
            return
        }
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let updatedProject = try? jsonDecoder.decode(Project.self, from: data) else {
                print("Unable to decode updated project")
                return
            }
            
            print("Updated project: \(updatedProject)")
        }
        
        task.resume()
    }
    
    
    private func doneButtonAccessibilityAction(for project: Project) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle Completion", comment: "Project Done Button Accessibility Label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in self?.completeProject(withId: project.id)
            return true
        }
        return action
    }
    
    private func doneButtonConfiguration(for project: Project)
    -> UICellAccessory.CustomViewConfiguration
    {
        let symbolName = project.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ProjectDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = project.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(
            customView: button, placement: .leading(displayed: .always))
    }
}
