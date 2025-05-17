import UIKit
import Combine

open class BaseViewController<T: BaseViewModel>: UIViewController {
    // MARK: - Properties
    
    public let viewModel: T
    public var cancellables = Set<AnyCancellable>()

    // MARK: - Initialize
    
    public init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindViewModel()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Only cancel when this controller is being removed for good
        guard isMovingFromParent || isBeingDismissed else { return }
        viewModel.reset()
    }

    // MARK: - Setup
    open func setupUI() {
        view.backgroundColor = .white
    }

    open func setupBindViewModel() {}

    // MARK: - Methods

    public func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
