//
//  PermissionRequestView.swift
//  Reddit
//
//  Created by Agustin on 08/06/2023.
//

import UIKit

enum TypePermission {
    case location
    case notification
    case camera
}

protocol DelegatePermissionsRequest {
    func nextView(with indexPage: Int)
}

final class PermissionsRequestViewController: UIViewController, Alertable {

    // MARK: Lifecycle
    let page: Pages
    var delegate: DelegatePermissionsRequest?
    let cameraPermissionManager = CameraPermissionManager.shared
    let notificationPermissionManager = NotificationPermissionManager.shared
    let locationPermissionManager = LocationPermissionManager.shared

    init(with page: Pages) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI Elements

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: page.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = page.title
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: Color.graphiteGray)
        label.font = UIFont(name: "Helvetica", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionMessageLabel: UILabel = {
        let label = UILabel()
        label.text = page.description
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
        button.setTitle("Enable", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = getGraddiantColor()
        button.addTarget(self, action: #selector(validatePermission), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 40
        button.addTarget(self, action: #selector(self.nextStep), for: .touchUpInside)
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

    // MARK: User Interaction

    @objc private func validatePermission() {
        switch page.type {
        case .location:
            requestLocationPermission()
            return
        case .notification:
            requestNotificationPermission()
            return
        case .camera:
            requestCameraPermission()
            return
        }
    }

    @objc private func nextStep() {
        self.delegate?.nextView(with: page.index)
    }
}

// MARK: Camara

extension PermissionsRequestViewController {

    private func requestLocationPermission() {
        locationPermissionManager.requestLocationPermission { [weak self ] autorizationStatus in
            guard let self = self else {return}
            switch autorizationStatus {
            case .restricted, .denied:
                self.showModal(title: "Background Location Access Disabled", message: "In order to show the location weather forecast, please open this app's settings and set location access to 'While Using'.")
                return
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                self.showModal(title: "Do you want to change your settings?", message: "This could affect your experience in the app.")
                return
            case .notDetermined:
                self.delegate?.nextView(with: page.index)
                return
            @unknown default:
                break
            }
        }
    }

    private func requestNotificationPermission() {
        notificationPermissionManager.requestNotificationPermission {
            [weak self] granted, isFirstInit  in
            guard let self = self else {return}

            if isFirstInit != nil {
                self.delegate?.nextView(with: page.index)
                return
            }
            if granted {
                self.showModal(title: "Do you want to change your settings?", message: "This could affect your experience in the app.")
            } else {
                self.showModal(title: "Background Notification Access Disabled", message: "In order to show the location weather forecast, please open this app's settings and set location access to 'While Using'.")
            }
        }
    }

    private func requestCameraPermission() {
        cameraPermissionManager.requestCameraPermission { [weak self] granted, statusPermission  in
            guard let self = self else {return}

            if statusPermission != nil {
                self.delegate?.nextView(with: page.index)
                return
            }

            if granted {
                self.showModal(title: "Do you want to change your settings?", message: "This could affect your experience in the app.")

            } else {
                self.showModal(title: "Background Camera Access Disabled", message: "In order to show the location weather forecast, please open this app's settings and set location access to 'While Using'.")
            }
        }
    }
}

extension PermissionsRequestViewController {

    func showModal(title: String, message: String) {
        // TODO: Reutilizable alert
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { [weak self] _ in
//            guard let self = self else {return}
//            self.delegate?.nextView(with: page.index)
//            self.openConfigurations()
//        }))
//        self.present(alertController, animated: true, completion: nil)
        
        showAlert(title: title, message: message) { [weak self] _ in
            guard let self = self else {return}
            self.delegate?.nextView(with: page.index)
            self.openConfigurations()
        }
    }

}

extension PermissionsRequestViewController {
    private func openConfigurations() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    private func getGraddiantColor() -> UIColor? {
        let gradientStartColor = UIColor(red: 1.0, green: 0.537, blue: 0.376, alpha: 1.0)
        let gradientEndColor = UIColor(red: 1.0, green: 0.384, blue: 0.647, alpha: 1.0)
        let startPoint = CGPoint(x: 0.0, y: 0.0)
        let endPoint = CGPoint(x: 1.0, y: 1.0)

        let gradientColor = UIColor.gradientColor(startColor: gradientStartColor, endColor: gradientEndColor, startPoint: startPoint, endPoint: endPoint)

        return gradientColor
    }
}
