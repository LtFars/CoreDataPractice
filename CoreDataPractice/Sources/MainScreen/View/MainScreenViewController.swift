//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    // MARK: - Elements
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Print your name here"
        textField.layer.cornerRadius = 8
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.layer.cornerRadius = 8
        let offset = Metric.standartGap
        let insets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
        tableView.separatorInset = insets
        tableView.register(MainScreenTableViewCell.self,
                           forCellReuseIdentifier: MainScreenTableViewCell.identifier)
        return tableView
    }()
    
    var presenter: MainScreenViewControllerOutput?
    private var profiles = [ProfileCardEntity]()
    private var profileCard: ProfileCardViewControllerInput?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        presenter?.fetchProfiles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileCard = nil
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        title = "Users"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    private func setupHierarchy() {
        view.addSubview(inputTextField)
        view.addSubview(confirmButton)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        
        inputTextField.pinToSides(to: view)
        confirmButton.pinToSides(to: view)
        tableView.pinToSides(to: view, gap: 0)
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputTextField.heightAnchor.constraint(equalToConstant: Metric.inputTextFieldHeight),
            
            confirmButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: Metric.standartGap),
            confirmButton.heightAnchor.constraint(equalTo: inputTextField.heightAnchor),
            
            tableView.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: Metric.standartGap),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metric.standartGap)
        ])
    }
    
    // MARK: - Actions
    
    @objc func confirmAction() {
        
        guard let name = inputTextField.text,
              !name.isEmpty else { return }
        
        let existedProfiles = profiles.compactMap { $0.name }
        let isDouplicate = existedProfiles.contains(name)
        
        if !isDouplicate {
            presenter?.saveProfile(with: name)
        } else {
            let message = "Current user exist already"
            showErrorAlert(title: "Error", message: message)
        }
    }
}

// MARK: - MainScreenViewControllerInput

extension MainScreenViewController: MainScreenViewControllerInput {
    
    func updateEntireTable(with profiles: [ProfileCardEntity]) {
        self.profiles = profiles
        tableView.reloadData()
    }
    
    func update(with profile: ProfileCardEntity) {
        let existedProfile = profiles.first(where: { $0.id == profile.id })
        if let existedProfile = existedProfile {
            existedProfile.name = profile.name
            existedProfile.birthdayDate = profile.birthdayDate
            existedProfile.gender = profile.gender
        } else {
            profiles.append(profile)
        }
        profileCard?.refreshProfileCard(by: profile)
        tableView.reloadData()
    }
    
    func showError(_ error: CoreDataError) {
        showErrorAlert(title: "Error", message: error.message)
        profileCard?.refreshProfileCard(by: nil)
    }
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        profiles.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainScreenTableViewCell.identifier,
            for: indexPath
        ) as? MainScreenTableViewCell else {
            return UITableViewCell()
        }
        let profile = profiles[indexPath.row]
        let name = profile.name ?? ""
        cell.configure(with: name)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainScreenViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let profile = profiles[indexPath.row]
        let viewController = ProfileCardViewController(profile: profile)
        viewController.saveProfile = { profile in
            self.presenter?.changeProfile(profile)
        }
        profileCard = viewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let profile = profiles[indexPath.row]
        
        let delete = UIContextualAction(
            style: .destructive,
            title: String()
        ) { (_, _, completion) in
            self.presenter?.deleteProfile(profile)
            completion(true)
        }
        
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
     
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

// MARK: - UITextFieldDelegate

extension MainScreenViewController: UITextFieldDelegate {}

// MARK: - Metric

extension MainScreenViewController {
    struct Metric {
        static let standartGap: CGFloat = 16
        static let inputTextFieldHeight: CGFloat = 50
    }
}
