import Foundation
import UIKit
import GlobalEntities
import SnapKit

// NOTE: Using UIContentConfiguration lets you reuse the same setup for UICollectionView cells, UITableView cells, and custom UIViews.

public struct EmptyContentConfig: UIContentConfiguration {
    fileprivate let message: String
    
    public init(message: String = "No data available") {
        self.message = message
    }
    
    public func makeContentView() -> any UIView & UIContentView { EmptyContentView(configuration: self) }
    public func updated(for state: any UIConfigurationState) -> EmptyContentConfig { self }
}

public final class EmptyContentView: UIView, UIContentView {
    // MARK: Properties
    
    public var configuration: any UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }
    
    // MARK: Declare UI
    
    private lazy var messageLabel = makeLabel()
    
    // MARK: Initialize
    
    public init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        setupUI()
    }
    @available(*, unavailable)
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupUI() {
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(CGFloat.getSpacing(.extraLarge))
            $0.centerX.equalToSuperview()
        }
    }
    
    public func update(with msg: String) {
        messageLabel.text = msg
    }
}

// MARK: - Configure

private extension EmptyContentView {
    func configure(configuration: UIContentConfiguration) {
        guard let config = configuration as? EmptyContentConfig else { return }
        messageLabel.text = config.message
    }
}

// MARK: - Making UI

private extension EmptyContentView {
    func makeLabel() -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.5)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.numberOfLines = .zero
        return lbl
    }
}
