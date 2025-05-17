import Foundation
import UIKit
import GlobalEntities
import CoreKit

// NOTE: Using UIContentConfiguration lets you reuse the same setup for UICollectionView cells, UITableView cells, and custom UIViews.
struct UserContentConfig: UIContentConfiguration {
    fileprivate let user: UserModel?
    
    init(user: UserModel? = nil) {
        self.user = user
    }
    
    func makeContentView() -> any UIView & UIContentView { UserContentView(configuration: self) }
    func updated(for state: any UIConfigurationState) -> UserContentConfig { self }
}

final class UserContentView: UIView, UIContentView {
    // MARK: Properties
    
    private let avatarSize: CGFloat = 90
    var configuration: any UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }
    
    // MARK: Declare UI
    
    private lazy var boxView                = makeBoxView()
    private lazy var avatarImgView          = makeAvatarView()
    private lazy var userNameLabel          = makeUserNameLabel()
    private lazy var profileUrlLabel        = makeProfileUrlLabel()
    private lazy var lineView               = makeSeparatorLine()
    private lazy var locationContainerView  = makeLocationContainerView()
    private lazy var locationLabel          = makeLocationLabel()
    
    // MARK: Initialize
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        setupUI()
    }
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupUI() {
        addSubview(boxView)
        boxView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupBoxUI()
    }
    
    private func setupBoxUI() {
        boxView.appAddSubviews(views: avatarImgView, userNameLabel, lineView, profileUrlLabel, locationContainerView)
        
        avatarImgView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(CGFloat.getSpacing(.medium))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(avatarSize)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImgView.snp.top)
            $0.leading.equalTo(avatarImgView.snp.trailing).offset(CGFloat.getSpacing(.medium))
            $0.trailing.equalToSuperview().offset(-CGFloat.getSpacing(.medium))
        }
       
        lineView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(CGFloat.getSpacing(.small))
            $0.leading.equalTo(userNameLabel)
            $0.trailing.equalToSuperview().offset(-CGFloat.getSpacing(.medium))
        }
        
        profileUrlLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(CGFloat.getSpacing(.small))
            $0.leading.equalTo(userNameLabel)
            $0.trailing.equalToSuperview().offset(-CGFloat.getSpacing(.medium))
        }
        
        locationContainerView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(CGFloat.getSpacing(.small))
            $0.leading.equalTo(userNameLabel)
            $0.trailing.equalToSuperview().offset(-CGFloat.getSpacing(.medium))
        }
    }
}

// MARK: - Configure

extension UserContentView {
    private func configure(configuration: UIContentConfiguration) {
        guard let config = configuration as? UserContentConfig,
              let user = config.user
        else { return }
        
        userNameLabel.text = user.name
        profileUrlLabel.text = user.profileURL?.absoluteString
        avatarImgView.setCacheImage(url: user.avatarURL)
    }
    
    public func updateCard(with detail: UserModel) {
        userNameLabel.text = detail.name
        avatarImgView.setCacheImage(url: detail.avatarURL)
        locationLabel.text = detail.location
        
        locationContainerView.isHidden = false
        profileUrlLabel.isHidden = true
    }
}

// MARK: - Making UI

private extension UserContentView {
    func makeBoxView() -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.shadowOpacity = 0.2
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        v.layer.shadowRadius = .getCornerRadius(.sm) + 2
        v.layer.cornerRadius = .getCornerRadius(.md)
        return v
    }
    
    func makeAvatarView() -> UIImageView {
        let v = UIImageView()
        v.layer.cornerRadius = avatarSize / 2
        v.contentMode = .scaleAspectFill
        v.backgroundColor = .lightGray
        v.clipsToBounds = true
        return v
    }
    
    func makeUserNameLabel() -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }
    
    func makeProfileUrlLabel() -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .systemBlue
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        lbl.numberOfLines = .zero
        return lbl
    }
    
    func makeLocationLabel() -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.textColor = .gray
        return lbl
    }
    
    func makeLocationContainerView() -> UIView {
        let imgV = UIImageView(image: UIImage(systemName: "mappin.circle"))
        imgV.tintColor = .lightGray
        
        let v = UIView()
        v.appAddSubviews(views: imgV, locationLabel)
        
        imgV.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.leading.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(imgV)
            $0.leading.equalTo(imgV.snp.trailing).offset(CGFloat.getSpacing(.xsmall))
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerY.equalTo(imgV)
        }
        
        v.isHidden = true
        return v
    }
    
    func makeSeparatorLine() -> UIView {
        let v = UIView()
        v.layer.opacity = 0.5
        v.backgroundColor = UIColor.lightGray
        v.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        return v
    }
}
