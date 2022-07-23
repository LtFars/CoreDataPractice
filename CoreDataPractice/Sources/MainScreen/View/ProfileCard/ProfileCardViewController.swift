//
//  ProfileCardViewController.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import UIKit

class ProfileCardViewController: UIViewController {
    
    // MARK: - Elements
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let image = UIImage(named: "profilePlaceholder")
        imageView.image = image
        imageView.layer.cornerRadius = Metric.userImageViewHeight / 2
        return imageView
    }()
    
    private lazy var fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full name"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Birthday '01.01.2004'"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var sexTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Genders"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let fullnameTextFieldSeparator = UIView.separator(color: .gray)
    let birthdayTextFieldSeparator = UIView.separator(color: .gray)
    let sexTextFieldSeparator = UIView.separator(color: .gray)
    
    private var profile: ProfileCardEntity?
    var saveProfile: ((ProfileCard) -> Void)?
    
    // MARK: - Lifecycle
    
    convenience init(profile: ProfileCardEntity) {
        self.init(nibName:nil, bundle:nil)
        self.profile = profile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        
        setupTopButtons(action: #selector(editAction))
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        fullnameTextField.delegate = self
        birthdayTextField.delegate = self
        sexTextField.delegate = self
        hideKeyboardWhenTappedAround()
        setupProfile()
    }
    
    private func setupHierarchy() {
        view.addSubview(userImageView)
        view.addSubview(fullnameTextField)
        view.addSubview(fullnameTextFieldSeparator)
        view.addSubview(birthdayTextField)
        view.addSubview(birthdayTextFieldSeparator)
        view.addSubview(sexTextField)
        view.addSubview(sexTextFieldSeparator)
    }
    
    private func setupLayout() {
        
        fullnameTextField.pinToSides(to: view)
        birthdayTextField.pinToSides(to: view)
        sexTextField.pinToSides(to: view)
        
        fullnameTextFieldSeparator.pinSeparator(to: fullnameTextField)
        birthdayTextFieldSeparator.pinSeparator(to: birthdayTextField)
        sexTextFieldSeparator.pinSeparator(to: sexTextField)

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.userImageViewTopOffset),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: Metric.userImageViewHeight),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor),
            
            fullnameTextField.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            fullnameTextField.heightAnchor.constraint(equalToConstant: Metric.fullnameTextFieldHeight),

            birthdayTextField.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor, constant: Metric.standartGap),
            birthdayTextField.heightAnchor.constraint(equalTo: fullnameTextField.heightAnchor),
            
            sexTextField.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: Metric.standartGap),
            sexTextField.heightAnchor.constraint(equalTo: fullnameTextField.heightAnchor)
        ])
    }
    
    private func setupProfile() {
        
        title = profile?.name == nil
        ? "User Profile"
        : profile?.name
        
        fullnameTextField.text = profile?.name
        sexTextField.text = profile?.gender
        birthdayTextField.text?.removeAll()
        
        guard let date = profile?.birthdayDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd.MM.yyyy"
        birthdayTextField.text = dateFormatter.string(from: date)
    }
    
    // MARK: - Actions
    
    @objc private func editAction() {
        guard let button = self.navigationItem.rightBarButtonItem?.customView as? UIButton else {
            return
        }
        
        if button.titleLabel?.text == "Edit" {
            button.setTitle("Save", for: .normal)
            fullnameTextField.isUserInteractionEnabled = true
            birthdayTextField.isUserInteractionEnabled = true
            sexTextField.isUserInteractionEnabled = true
            return
        }
        
        button.setTitle("Edit", for: .normal)
        fullnameTextField.isUserInteractionEnabled = false
        birthdayTextField.isUserInteractionEnabled = false
        sexTextField.isUserInteractionEnabled = false
        
        guard let name = fullnameTextField.text,
              !name.isEmpty,
              let id = profile?.id else { return }
        
        var birthdayDate: Date?
        if let dateStr = birthdayTextField.text {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = dateFormatter.date(from: dateStr)
            birthdayDate = date
        }
        
        let gender = sexTextField.text
        
        let profile = ProfileCard(
            name: name,
            id: id,
            birthdayDate: birthdayDate,
            gender: gender
        )
        
        saveProfile?(profile)
    }
}

// MARK: - ProfileCardViewControllerInput

extension ProfileCardViewController: ProfileCardViewControllerInput {
    func refreshProfileCard(by profile: ProfileCardEntity?) {
        if let profile = profile {
            self.profile = profile
        }
        setupProfile()
    }
}

// MARK: - UITextFieldDelegate

extension ProfileCardViewController: UITextFieldDelegate {}

// MARK: - Metric

extension ProfileCardViewController {
    struct Metric {
        static let standartGap: CGFloat = 16
        static let userImageViewTopOffset: CGFloat = 40
        static let userImageViewHeight: CGFloat = 250
        static let fullnameTextFieldHeight: CGFloat = 50
    }
}
