//
//  class SuggestedHintTableViewCell.swift
//  Snapsea
//
//  Created by Irina Deeva on 12/09/24.
//

import UIKit

class SuggestedHintTableViewCell: UITableViewCell {
    static let identifier = "SuggestionCell"

    private lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        return label
    }()

    private lazy var search: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .textColor
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .background
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(term: String, searchedTerm: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 21),
            .foregroundColor: UIColor(white: 0.56, alpha: 1.0)
        ]
        let attributedString = NSAttributedString(
            string: term.lowercased(),
            attributes: attributes
        )
        let mutableAttributedString = NSMutableAttributedString(
            attributedString: attributedString
        )
        mutableAttributedString.setBold(text: searchedTerm.lowercased())
        cellLabel.attributedText = mutableAttributedString
    }

    private func setupUI() {

        [cellLabel, search].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: search.trailingAnchor, constant: 8),
            cellLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            search.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            search.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
