import UIKit
import Combine
import CoreKit
import GlobalEntities

class UserDetailViewController: BaseViewController<UserDetailViewModel> {
    // MARK: Declare UI
    
    private lazy var detailCardView     = makeDetailCardView()
    private lazy var emptyView          = makeEmptyView()
    private lazy var followersView      = StatIconView(config: .followers)
    private lazy var followingView      = StatIconView(config: .following)
    private lazy var blogLinkLabel      = makeBlogLinkLabel()
    
    // MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.firstLoadData()
    }
    
    // MARK: Setup
    
    override func setupUI() {
        super.setupUI()
        
        title = "User Details"
        
        let statInfoWrapper = makeHorizontalStack(views: followersView, followingView)
        let blogWrapper = makeVerticalStack(views: makeTitleLabel(with: "Blog"), blogLinkLabel)
        
        view.appAddSubviews(views: emptyView, detailCardView, statInfoWrapper, blogWrapper)
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        detailCardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(CGFloat.getSpacing(.medium))
            $0.horizontalEdges.equalToSuperview().inset(CGFloat.getSpacing(.mediumLarge))
        }
        
        statInfoWrapper.snp.makeConstraints {
            $0.top.equalTo(detailCardView.snp.bottom).offset(CGFloat.getSpacing(.xlarge))
            $0.horizontalEdges.equalTo(detailCardView).inset(CGFloat.getSpacing(.xlarge))
        }
        statInfoWrapper.distribution = .fillProportionally
        
        blogWrapper.snp.makeConstraints {
            $0.top.equalTo(statInfoWrapper.snp.bottom).offset(CGFloat.getSpacing(.extraLarge))
            $0.horizontalEdges.equalTo(detailCardView)
        }
    }
    
    override func setupBindViewModel() {
        cancellables = []
        
        viewModel.$detail
            .dropFirst()
            .first() // Call only 1 time
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                self?.updateUI(with: detail)
            }.store(in: &cancellables)
        
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }.store(in: &cancellables)
    }
}

// MARK: - Method

private extension UserDetailViewController {
    func updateUI(with detail: UserModel?) {
        guard let detail else {
            emptyView.isHidden = false
            return
        }
        detailCardView.updateCard(with: detail)
        blogLinkLabel.text = detail.blog
        
        let followersCount = detail.followers > 100 ? "100+" : "\(detail.followers)"
        followersView.updateCount(with: followersCount)
        
        let followingCount = detail.following > 10 ? "10+" : "\(detail.following)"
        followingView.updateCount(with: followingCount)
    }
}
