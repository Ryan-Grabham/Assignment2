import UIKit

extension ListProjectViewController {
    @objc func didPressDoneButton(_ sender: ProjectDoneButton) {
        guard let id = sender.id else { return }
        completeProject(withId: id)
    }
}

