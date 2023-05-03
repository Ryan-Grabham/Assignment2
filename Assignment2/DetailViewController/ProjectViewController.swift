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
        case(_, .header(let title)):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = title
            cell.contentConfiguration = contentConfiguration
        case (.view, _):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = text(for:row)
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguration.image = row.image
            cell.contentConfiguration = contentConfiguration
        default:
            fatalError("Unexpected combination of section and row")
        }
    //  cell.tintcolor = .systemPink
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .start_date: return "Start date: \(project.start_date)"
        case .description: return project.description
        case .end_date: return "End date: \(project.end_date)"
        case .complete: return project.isComplete ? "Complete" : "In progress"
        case .title: return project.name
        default: return nil
        }
    }
    
    private func updateSnapshotForEditing() {
            var snapshot = Snapshot()
            snapshot.appendSections([.title, .start_date, .end_date, .description, .complete])
            
            snapshot.appendItems([.header(Section.title.name)], /*.editableText(project.name)],*/ toSection: .title)
            snapshot.appendItems([.header(Section.start_date.name)], /*.editableDate(project.start_date)],*/ toSection: .start_date)
            snapshot.appendItems([.header(Section.end_date.name)], /*.editableDate(project.end_date)],*/ toSection: .end_date)
            snapshot.appendItems([.header(Section.description.name)], /*.editableText(project.description)],*/ toSection: .description)
            snapshot.appendItems([.header(Section.complete.name)], /*.editableSwitch(project.isComplete)],*/ toSection: .complete)
            dataSource.apply(snapshot)
        
    }
    
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
