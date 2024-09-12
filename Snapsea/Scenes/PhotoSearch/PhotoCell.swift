//
//  ImageCell.swift
//  Snapsea
//
//  Created by Irina Deeva on 10/09/24.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    static let identifier = "PhotoCell"

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private var textOverlayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()

    private var dataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.lineBreakMode =  .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoCell {

    func updateImage(with data: Data) {
        imageView.image =  UIImage(data: data) ?? UIImage()
    }
    func updateCell(with photo: Photo) {
        descriptionLabel.text = photo.description
        dataLabel.text = photo.createdDate
    }

    private func setupUI() {
        contentView.backgroundColor = .white

        [imageView, textOverlayView, dataLabel, descriptionLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),

            textOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            textOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            textOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            dataLabel.topAnchor.constraint(equalTo: textOverlayView.topAnchor, constant: 4),
            dataLabel.leadingAnchor.constraint(equalTo: textOverlayView.leadingAnchor, constant: 4),
            dataLabel.trailingAnchor.constraint(equalTo: textOverlayView.trailingAnchor, constant: -4),
            dataLabel.bottomAnchor.constraint(equalTo: textOverlayView.bottomAnchor, constant: -4),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
        ])
    }
}
