import Foundation

extension ProjectViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case start_date
        case end_date
        case description
        case complete

        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .start_date:
                return NSLocalizedString("Start Date", comment: "Start Date section name")
            case .end_date:
                return NSLocalizedString("End Date", comment: "End Date section name")
            case .description:
                return NSLocalizedString("Description", comment: "Date section name")
            case .complete:
                return NSLocalizedString("Complete", comment: "Complete section name")
            }
        }
    }
}
