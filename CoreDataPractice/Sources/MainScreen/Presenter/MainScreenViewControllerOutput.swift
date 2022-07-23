//
//  MainScreenViewControllerOutput.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 21.07.2022.
//

import Foundation

protocol MainScreenViewControllerOutput: AnyObject {
    func fetchProfiles()
    func saveProfile(with name: String)
    func deleteProfile(_ profile: ProfileCardEntity)
    func changeProfile(_ profile: ProfileCard)
}
