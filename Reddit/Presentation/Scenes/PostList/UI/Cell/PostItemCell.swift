//
//  PostItemCell.swift
//  Reddit
//
//  Created by Agustin on 09/06/2023.
//

import UIKit

class PostItemCell: UITableViewCell {

    // MARK: UI Elements

    lazy var postImageView: UIImageView  = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFit
        return image
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: Color.graphiteGray)
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: Color.graphiteGray)
        label.font = UIFont(name: "Helvetica", size: 15)
        label.numberOfLines = 0
        label.text = "100"
        return label
    }()

    lazy var numberCommentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: Color.graphiteGray)
        label.font = UIFont(name: "Helvetica", size: 10)
        label.numberOfLines = 0
        label.text = "10"
        return label
    }()

    lazy var commentIconView: UIImageView  = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Image.commentIcon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy private var containerCommentView: UIView = {
        let view = UIView()
        view.addSubview(numberCommentLabel)
        view.addSubview(commentIconView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy private var iconArrowUpImage: UIImageView = {
        let image = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate)
        let iconImage = UIImageView(image: image)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.tintColor = .gray
        return iconImage
    }()

    lazy private var iconArrowDownImage: UIImageView = {
        let image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        let iconImage = UIImageView(image: image)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.tintColor = .gray
        return iconImage
    }()

    lazy private var containerScoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(iconArrowUpImage)
        stackView.addArrangedSubview(scoreLabel)
        stackView.addArrangedSubview(iconArrowDownImage)
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy private var containerViewCell: UIView = {
        let view = UIView()
        view.addSubview(postImageView)
        view.addSubview(containerScoreStackView)
        view.addSubview(titleLabel)
        view.addSubview(containerCommentView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.16
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        builHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fill(with post: PostData) {
        titleLabel.text = post.title
        scoreLabel.text = String(post.score ?? 0)
        numberCommentLabel.text = String(post.numberComments ?? 0)
        updatePosterImage(url: post.urlOvrridenByDest ?? "")
    }

    private func updatePosterImage(url: String) {
        postImageView.imageFromURL(urlString: url)
    }

    // MARK: Layout
    private func builHierarchy() {
        addSubview(containerViewCell)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image post
            postImageView.heightAnchor.constraint(equalToConstant: 209),
            postImageView.topAnchor.constraint(equalTo: containerViewCell.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: containerViewCell.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: containerViewCell.trailingAnchor),

            // Score
            containerScoreStackView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            containerScoreStackView.leadingAnchor.constraint(equalTo: containerViewCell.leadingAnchor, constant: 10),
            containerScoreStackView.widthAnchor.constraint(equalToConstant: 50),

            // Title

            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerScoreStackView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerViewCell.trailingAnchor, constant: -10),

            // Comment

            commentIconView.topAnchor.constraint(equalTo: containerCommentView.topAnchor),
            commentIconView.leadingAnchor.constraint(equalTo: containerCommentView.leadingAnchor),
            commentIconView.centerYAnchor.constraint(equalTo: containerCommentView.centerYAnchor),

            numberCommentLabel.topAnchor.constraint(equalTo: containerCommentView.topAnchor),
            numberCommentLabel.leadingAnchor.constraint(equalTo: commentIconView.trailingAnchor, constant: 10),
            numberCommentLabel.centerYAnchor.constraint(equalTo: containerCommentView.centerYAnchor),

            containerCommentView.bottomAnchor.constraint(equalTo: containerViewCell.bottomAnchor, constant: -16),
            containerCommentView.leadingAnchor.constraint(equalTo: containerScoreStackView.trailingAnchor, constant: 10),

            // Container
            containerViewCell.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerViewCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerViewCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerViewCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
