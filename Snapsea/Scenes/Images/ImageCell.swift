//
//  ImageCell.swift
//  Snapsea
//
//  Created by Irina Deeva on 10/09/24.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    
    static let identifier = "ImageCell"

    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCell {

    func updateCell() {
        cardImageView.image = UIImage(named: "tmp")
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        
        [cardImageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardImageView.heightAnchor.constraint(equalToConstant: 150),
            cardImageView.widthAnchor.constraint(equalToConstant: 150),
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
}
