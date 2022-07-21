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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
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
        print("ewfdwefwef")
    }
}

// MARK: - MainScreenViewControllerInput

extension MainScreenViewController: MainScreenViewControllerInput {
    
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        5
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
        cell.configure(with: "Cell \(indexPath.row + 1)")
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
    }
}

// MARK: - UITextFieldDelegate

extension MainScreenViewController: UITextFieldDelegate {
    
}

// MARK: - Metric

extension MainScreenViewController {
    struct Metric {
        static let standartGap: CGFloat = 16
        static let inputTextFieldHeight: CGFloat = 50
    }
}
