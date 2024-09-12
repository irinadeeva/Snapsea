//
//  ImageCell.swift
//  Snapsea
//
//  Created by Irina Deeva on 10/09/24.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    static let identifier = "PhotoCell"

    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
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

extension PhotoCell {

    func updateImage(with data: Data) {
        cardImageView.image =  UIImage(data: data) ?? UIImage()
    }

    func updateCell(with photo: Photo) {
//       cardImageView.image = UIImage(named: "tmp")
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
