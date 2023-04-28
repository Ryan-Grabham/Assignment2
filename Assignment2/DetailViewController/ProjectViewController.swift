//
//  ProjectViewController.swift
//  Assignment2
//
//  Created by Ryan Grabham (Student) on 28/04/2023.
//

import UIKit

class ProjectViewController: UICollectionViewController {
    var project: Project
         
    init(project: Project) {
        self.project = project
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ProjectViewController using init(project:)")
    }
    
}
