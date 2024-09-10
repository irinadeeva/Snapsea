//
//  ViewController.swift
//  Snapsea
//
//  Created by Irina Deeva on 09/09/24.
//

import UIKit

final class ViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private let params: GeometricParams = GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          cellSpacing: 7)

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        return searchController
    }()

    private lazy var nftsCollection: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        collectionView.isScrollEnabled = false

        collectionView.register(
            ImageCell.self,
            forCellWithReuseIdentifier: ImageCell.identifier)

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


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        setupUI()
    }
}

extension ViewController {

    private func setupUI() {
        view.backgroundColor = .white

        nftsCollection.delegate = self
        nftsCollection.dataSource = self

        [nftsCollection, emptyLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            nftsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setUpSearchBar()
    }

    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.identifier,
            for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }

        cell.updateCell()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
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

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
    }
}
