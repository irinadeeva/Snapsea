//
//  ViewController.swift
//  Snapsea
//
//  Created by Irina Deeva on 09/09/24.
//

import UIKit

// MARK: - Protocol
protocol PhotoListView: AnyObject, ErrorView, LoadingView {
    func fetchPhotos(_ photos: [Photo])
}

final class PhotoListViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private var photos: [Photo] = []

    private let presenter: PhotoListPresenter

    private let params: GeometricParams = GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          cellSpacing: 7)

    lazy var activityIndicator = UIActivityIndicatorView()

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        return searchController
    }()

    private lazy var photosCollection: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        collectionView.isScrollEnabled = false

        collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.identifier)

        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    init(presenter: PhotoListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension PhotoListViewController {

    private func setupUI() {
        view.backgroundColor = .white

        photosCollection.delegate = self
        photosCollection.dataSource = self

        [photosCollection, emptyLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            photosCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photosCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setUpSearchBar()
    }

    private func setUpSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifier,
            for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }

        let photo = photos[indexPath.item]
        cell.updateCell(with: photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }
                self.presenter.fetchPhotosNextPage()
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)

        return CGSize(width: cellWidth,
                      height: 170)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
}

extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showDetails()
    }
}

extension PhotoListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        presenter.findPhotosFor(text)
    }
}

extension PhotoListViewController: PhotoListView {
    func fetchPhotos(_ photos: [Photo]) {
        self.photos = photos

        if self.photos.count != 0 {
            emptyLabel.isHidden = true
            photosCollection.reloadData()
        } else {
            emptyLabel.isHidden = false
            photosCollection.isHidden = true
        }
    }
}
