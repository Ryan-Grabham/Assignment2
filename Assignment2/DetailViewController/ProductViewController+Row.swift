import UIKit

extension ProjectViewController {
    enum Row: Hashable {
        case header(String)
        case start_date
        case description
        case end_date
        case title
        case complete
        case editableDate(String)
        case editableText(String?)
        case editableSwitch(Bool)
        
        var imageName: String? {
            switch self {
            case .start_date: return "calendar.badge.clock"
            case .description: return "info.circle"
            case .end_date: return "calendar.badge.minus"
            case .complete: return "checkmark.circle"
            default: return nil
            }
        }

        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }

        var textStyle: UIFont.TextStyle {
            switch self {
            case .title: return .headline
            default: return .subheadline
            }
        }
    }
}
