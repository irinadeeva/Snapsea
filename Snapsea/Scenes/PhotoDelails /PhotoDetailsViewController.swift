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
        return imageView
    }()

    private lazy var imageDescription: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.lineBreakMode =  .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var author: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.lineBreakMode =  .byWordWrapping
        label.numberOfLines = 0
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

        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
                navigationItem.leftBarButtonItem = backButton

        [imageView, imageDescription, author, activityIndicator].forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            imageView.widthAnchor.constraint(equalToConstant: 300),

            imageDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            imageDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            author.topAnchor.constraint(equalTo: imageDescription.bottomAnchor, constant: 10),
            author.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            author.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])

    }

    @objc private func backButtonTapped() {
            coordinator?.goBack()
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
