//
//  ListProjectViewController+DataSource.swift
//  Assignment2
//
//  Created by Ryan Grabham (Student) on 26/04/2023.
//

import UIKit

extension ListProjectViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
        let project = Project.sampleData[indexPath.item]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = project.name
        contentConfiguration.secondaryText = project.description
        cell.contentConfiguration = contentConfiguration
    }
}
