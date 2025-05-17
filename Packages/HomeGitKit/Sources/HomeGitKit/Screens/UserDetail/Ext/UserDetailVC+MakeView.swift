import CoreKit
import UIKit

extension UserDetailViewController {
    func makeEmptyView() -> EmptyContentView {
        let v = EmptyContentView(configuration: EmptyContentConfig())
        v.update(with: "Something wrong, please try again")
        v.isHidden = true
        return v
    }
    
    func makeDetailCardView() -> UserContentView {
        let detailCard = UserContentView(configuration: UserContentConfig())
        return detailCard
    }
    
    func makeTitleLabel(with title: String) -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.numberOfLines = 0
        lbl.text = title
        return lbl
    }
    
    func makeBlogLinkLabel() -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .blue
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }
    
    func makeHorizontalStack(views: UIView...) -> UIStackView {
        let v = UIStackView(arrangedSubviews: views)
        v.axis = .horizontal
        v.spacing = .getSpacing(.medium)
        return v
    }
    
    func makeVerticalStack(views: UIView...) -> UIStackView {
        let v = UIStackView(arrangedSubviews: views)
        v.axis = .vertical
        v.spacing = .getSpacing(.xmedium)
        return v
    }
}
