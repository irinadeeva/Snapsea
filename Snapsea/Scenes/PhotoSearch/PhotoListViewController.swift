//
//  ViewController.swift
//  Snapsea
//
//  Created by Irina Deeva on 09/09/24.
//

import UIKit

protocol PhotoListView: AnyObject, ErrorView, LoadingView {
    func fetchPhotos(_ photos: [Photo])
}

final class PhotoListViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private var hints: [String] = []
    private var query: String = ""

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

        collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.identifier)

        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .background
        return collectionView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.textColor = .textColor
        label.isHidden = true
        return label
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать в SnapSea!"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .textColor
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0
        return label
    }()

    private lazy var suggestionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.isHidden = true
        tableView.isScrollEnabled = false
        tableView.register(SuggestedHintTableViewCell.self,
                           forCellReuseIdentifier: SuggestedHintTableViewCell.identifier)
        return tableView
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
        view.backgroundColor = .background

        photosCollection.delegate = self
        photosCollection.dataSource = self

        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self

        [photosCollection,
         emptyLabel,
         suggestionsTableView,
         activityIndicator,
         welcomeLabel
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            suggestionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            suggestionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            suggestionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            photosCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photosCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.welcomeLabel.alpha = 1
        })

        setUpSearchBar()
    }

    private func setUpSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func updateSuggestions(for query: String) {
        let searchHistory = presenter.fetchHints()

        let searchResults = searchHistory.filter { item in
            item.localizedCaseInsensitiveContains(query)
        }

        self.query = query
        hints = searchResults

        suggestionsTableView.reloadData()
    }

    private func showAllSearchHistory()
    {
        let searchHistory = presenter.fetchHints()
        hints = searchHistory
        self.query = ""
        suggestionsTableView.reloadData()
    }

}

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

        let cachedImage = presenter.getCachedImage(for: photo.thumbImageURL)
        if let imageData = cachedImage {
            cell.updateImage(with: imageData)
        }

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
        coordinator?.showDetails(of: photos[indexPath.row].id)
    }
}

extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hints.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SuggestedHintTableViewCell.identifier,
            for: indexPath) as? SuggestedHintTableViewCell else {
            return UITableViewCell()
        }

        if query.isEmpty {
            cell.updateCell(with: hints[indexPath.row])
        } else {
            cell.set(term: hints[indexPath.row],
                     searchedTerm: query)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = hints[indexPath.row]
        searchController.searchBar.text = selectedSuggestion
        suggestionsTableView.isHidden = true
        presenter.fetchPhotosFor(selectedSuggestion)
    }
}

extension PhotoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        photosCollection.isHidden = false
        suggestionsTableView.isHidden = true
        
        presenter.fetchPhotosFor(text)
    }
}

extension PhotoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }

        photosCollection.isHidden = true
        suggestionsTableView.isHidden = false

        if !searchText.isEmpty {
            updateSuggestions(for: searchText)
        } else {
            showAllSearchHistory()
        }
    }
}

extension PhotoListViewController: PhotoListView {
    func fetchPhotos(_ photos: [Photo]) {
        self.photos = photos

        welcomeLabel.isHidden = true

        if self.photos.count != 0 {
            emptyLabel.isHidden = true
            suggestionsTableView.isHidden = true
            photosCollection.isHidden = false
            photosCollection.reloadData()
        } else {
            emptyLabel.isHidden = false
            suggestionsTableView.isHidden = true
            photosCollection.isHidden = true
        }
    }
}
