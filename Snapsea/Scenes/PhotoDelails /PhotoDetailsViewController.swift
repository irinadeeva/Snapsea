//
//  ImageDetails.swift
//  Snapsea
//
//  Created by Irina Deeva on 10/09/24.
//

import Foundation
import UIKit


// MARK: - Protocol
protocol PhotoDetailsView: AnyObject, ErrorView, LoadingView {
    func fetchPhoto(_ photo: Photo)
}

final class PhotoDetailsViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    
    var activityIndicator = UIActivityIndicatorView()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return imageView
    }()

    private lazy var textOverlayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()

    private lazy var imageDescription: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.lineBreakMode =  .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        return label
    }()

    private lazy var author: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.lineBreakMode =  .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private let presenter: PhotoDetailsPresenter
    private var loadedPhoto: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }

    init(presenter: PhotoDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoDetailsViewController {

    private func setupUI() {
        view.backgroundColor = .white

        let backButton = UIBarButtonItem(
                    image: UIImage(systemName: "chevron.left"),
                    style: .plain,
                    target: self,
                    action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton

        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(didTapShareButton)
        )
        navigationItem.rightBarButtonItem = shareButton

        [imageView, textOverlayView, imageDescription, author, activityIndicator].forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            textOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            textOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            textOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            imageDescription.topAnchor.constraint(equalTo: textOverlayView.topAnchor, constant: 8),
            imageDescription.leadingAnchor.constraint(equalTo: textOverlayView.leadingAnchor, constant: 8),
            imageDescription.trailingAnchor.constraint(equalTo: textOverlayView.trailingAnchor, constant: -8),

            author.topAnchor.constraint(equalTo: imageDescription.bottomAnchor, constant: 4),
            author.leadingAnchor.constraint(equalTo: textOverlayView.leadingAnchor, constant: 8),
            author.trailingAnchor.constraint(equalTo: textOverlayView.trailingAnchor, constant: -8),
            author.bottomAnchor.constraint(equalTo: textOverlayView.bottomAnchor, constant: -8)
        ])

    }

    @objc private func backButtonTapped() {
            coordinator?.goBack()
    }

    @objc private func didTapShareButton(_ sender: UIButton) {
        guard let imageToShare = imageView.image else {
            return
        }

        let activityViewController = UIActivityViewController(
            activityItems: [imageToShare],
            applicationActivities: nil
        )
        present(activityViewController, animated: true, completion: nil)
    }

    private func updateUI(with photo: Photo) {

        let cachedImage = presenter.getCachedImage(for: photo.smallImageURL)

        if let imageData = cachedImage {
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                    self?.imageDescription.text = photo.description
                    self?.author.text = photo.author
                }
            }
        }
    }
}

extension PhotoDetailsViewController: PhotoDetailsView {

    func fetchPhoto(_ photo: Photo) {
        loadedPhoto = photo
        if let loadedPhoto {
            updateUI(with: loadedPhoto)
        }
    }
}
