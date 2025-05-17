import UIKit
import SnapKit

// MARK: - Modal

extension StatIconView {
    enum ConfigType {
        case followers
        case following
        
        var title: String {
            let dict: [Self: String] = [
                .followers: "Follower",
                .following: "Following",
            ]
            return dict[self] ?? ""
        }
        
        var iconName: String {
            let dict: [Self: String] = [
                .followers: "person.2.fill",
                .following: "person.fill",
            ]
            return dict[self] ?? ""
        }
    }
}

// MARK: - Main

final class StatIconView: UIView {
    // MARK: - Declare UI
    
    private lazy var containerView: UIView = makeContainerView()
    private lazy var iconImgView: UIImageView = makeIconImageView()
    private lazy var countingLabel: UILabel = makeCountingLabel()
    private lazy var titleLabel: UILabel = makeTitleLabel()

    // MARK: - Initial
    
    init(config: ConfigType) {
        super.init(frame: .zero)
        setupUI(with: config)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    private func setupUI(with config: ConfigType) {
        appAddSubviews(views: containerView, countingLabel, titleLabel)
        setupConstraints()
        
        iconImgView.image = UIImage(systemName: config.iconName)
        titleLabel.text = config.title
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }

        countingLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(CGFloat.getSpacing(.small))
            $0.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(countingLabel.snp.bottom).offset(CGFloat.getSpacing(.xssmall))
            $0.centerX.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configure

extension StatIconView {
    func updateCount(with count: String) {
        countingLabel.text = count
    }
}

// MARK: - Making UI

private extension StatIconView {
    func makeContainerView() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.92, alpha: 1.0) // Extra light gray
        v.layer.cornerRadius = .getCornerRadius(.md) + 4
        v.layer.masksToBounds = true
        v.addSubview(iconImgView)
        
        iconImgView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(CGFloat.getSpacing(.small))
            $0.size.equalTo(CGFloat.getSpacing(.xlarge))
        }
        return v
    }

    func makeIconImageView() -> UIImageView {
        let v = UIImageView()
        v.tintColor = .black
        v.contentMode = .scaleAspectFit
        return v
    }

    func makeCountingLabel() -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }

    func makeTitleLabel() -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }
}
