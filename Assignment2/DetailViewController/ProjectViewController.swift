import UIKit

class ProjectViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var project: Project
    private var dataSource: DataSource!
    
    init(project: Project) {
        self.project = project
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ProjectViewController using init(project:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("Project", comment: "Project view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            updateSnapshotForEditing()
        } else {
            let urlString = "http://127.0.0.1:5000/api/projects/update/\(project.id)"
            URLSession.shared.putData(project, urlString: urlString) { (result: Result<Project, Error>) in
                print(result)
            }
            updateSnapshotForViewing()
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        
        switch (section, row) {
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.start_date, .editableDate(let start_date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: start_date)
        case (.end_date, .editableDate(let end_date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: end_date)
        case (.description, .editableText(let description)):
            cell.contentConfiguration = textConfiguration(for: cell, with: description)
        case (.complete, .editableSwitch(let isOn)):
            cell.contentConfiguration = switchConfiguration(for: cell, with: isOn)
        default:
            print("Unexpected combination: section = \(section), row = \(row)")
            fatalError("Unexpected combination of section and row.")
        }
    //  cell.tintcolor = .systemPink
    }

    
    private func updateSnapshotForEditing() {
            var snapshot = Snapshot()
            snapshot.appendSections([.title, .start_date, .end_date, .description, .complete])
            
            snapshot.appendItems([.header(Section.title.name), .editableText(project.name)], toSection: .title)
            snapshot.appendItems([.header(Section.start_date.name), .editableDate(project.start_date)], toSection: .start_date)
            snapshot.appendItems([.header(Section.end_date.name), .editableDate(project.end_date)], toSection: .end_date)
        snapshot.appendItems([.header(Section.description.name), .editableText(project.description)], toSection: .description)
            snapshot.appendItems([.header(Section.complete.name), .editableSwitch(project.isComplete)], toSection: .complete)
            dataSource.apply(snapshot)
        
    }
    
    private func prepareForViewing()
    
    func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([Row.title, Row.start_date, Row.end_date, Row.description, Row.complete], toSection: .view)
        dataSource.apply(snapshot)
    }

    private func section(for indexPath: IndexPath) -> Section {
            let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
            guard let section = Section(rawValue: sectionNumber) else {
                fatalError("Unable to find matching section")
            }
            return section
        }


    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([Row.title, Row.description, Row.start_date, Row.end_date], toSection: .view)
        dataSource.apply(snapshot)
    }
    





}
