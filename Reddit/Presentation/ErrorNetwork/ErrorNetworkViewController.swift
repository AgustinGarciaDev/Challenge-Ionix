//
//  ErrorNetworkViewController.swift
//  Reddit
//
//  Created by Agustin on 12/06/2023.
//

import UIKit

protocol ErrorNetworkProtocol: AnyObject{
    func retryRed()
}

class ErrorNetworkViewController: UIViewController {
    
    weak var delegate: ErrorNetworkProtocol?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Image.imageError)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Connection error"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: Color.graphiteGray)
        label.font = UIFont(name: "Helvetica", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops! Network issues. Please check your connection and try again."
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
    
    private lazy var nextStepButton: UIButton = {
        let button = UIButton()
        button.setTitle("RETRY", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = getGraddiantColor()
        button.addTarget(self, action: #selector(retryConection), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("OPEN WEBSITE", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 40
        button.addTarget(self, action: #selector(openWeb), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        view.addSubview(imageView)
        view.addSubview(containerLabelStackView)
        view.addSubview(nextStepButton)
        view.addSubview(cancelButton)
    }
    
    // MARK: Layout
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 142),
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            containerLabelStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            containerLabelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            containerLabelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            containerLabelStackView.heightAnchor.constraint(equalToConstant: 115),
            
            nextStepButton.topAnchor.constraint(equalTo: containerLabelStackView.bottomAnchor, constant: 10),
            nextStepButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            nextStepButton.heightAnchor.constraint(equalToConstant: 50),
            nextStepButton.widthAnchor.constraint(equalToConstant: 195),
            
            cancelButton.topAnchor.constraint(equalTo: nextStepButton.bottomAnchor, constant: 20),
            cancelButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    @objc private func retryConection() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.retryRed()
        }
    }
    
    @objc private func openWeb() {
        openSafariURL(webUrl: "https://www.reddit.com/r/chile/new/")
    }
}
