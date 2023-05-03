import UIKit

extension ProjectViewController {
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration{
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration{
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration{
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with dateString: String) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = dateFormatter.date(from: dateString) {
            contentConfiguration.date = date
            print(date)
            
        } else {
            print("Invalid date string: \(dateString)")
            
        }
        return contentConfiguration
        
    }
    
    func textConfiguration(for cell: UICollectionViewListCell, with text: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = text
        return contentConfiguration
        }
    
    func switchConfiguration(for cell: UICollectionViewListCell, with isOn: Bool) -> SwitchButtonContentView.Configuration {
        var contentConfiguration = cell.switchButtonConfiguration()
        contentConfiguration.isOn = isOn
        return contentConfiguration
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
}
