import UIKit

protocol LoadingView {
    var activityIndicator: UIActivityIndicatorView { get }
    func showLoading()
    func hideLoading()
}

extension LoadingView {
    func showLoading() {
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
        }
    }
}
