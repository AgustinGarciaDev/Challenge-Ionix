//
//  ItemCarousel.swift
//  Reddit
//
//  Created by Agustin on 10/06/2023.
//

import UIKit

class ItemCarousel: UIView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Image.imageNotification)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: Color.graphiteGray)
        label.font = UIFont(name: "Helvetica", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Sorry, there are no results for this search. Please try another phrase"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: Color.gray29)
        label.font = UIFont(name: "Helvetica", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy private var containerLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionMessageLabel)
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()

    }
    // MARK: Layout

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(containerLabelStackView)
        setupConstraints()
    }

    private func setupConstraints() {
        if let superview = superview {
                    centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
                    centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 142),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            containerLabelStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            containerLabelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            containerLabelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            containerLabelStackView.heightAnchor.constraint(equalToConstant: 115)
        ])
    }
}
