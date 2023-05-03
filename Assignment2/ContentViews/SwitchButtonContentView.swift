import UIKit

class SwitchButtonContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var isOn: Bool = false

        func makeContentView() -> UIView & UIContentView {
            return SwitchButtonContentView(self)
        }
    }

    let switchButton = UISwitch()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(switchButton)
        switchButton.addTarget(self, action: #selector(switchButtonValueChanged), for: .valueChanged)
        switchButton.tintColor = .systemPink // Set the tint color to systemPink
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        switchButton.isOn = configuration.isOn
    }

    @objc private func switchButtonValueChanged() {
        guard let configuration = configuration as? Configuration else { return }
        let newConfiguration = Configuration(isOn: switchButton.isOn)
        self.configuration = newConfiguration
    }

    // Override the layoutSubviews method to center the switchButton within the cell's bounds
    override func layoutSubviews() {
        super.layoutSubviews()
        switchButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

extension UICollectionViewListCell {
    func switchButtonConfiguration() -> SwitchButtonContentView.Configuration {
        SwitchButtonContentView.Configuration()
    }
}

