//
//  MainScreenViewControllerInput.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import Foundation

protocol MainScreenViewControllerInput: AnyObject {
    func updateEntireTable(with profiles: [ProfileCardEntity])
    func update(with profile: ProfileCardEntity)
    func showError(_ error: CoreDataError)
}
