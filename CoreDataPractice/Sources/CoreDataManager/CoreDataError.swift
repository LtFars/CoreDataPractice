//
//  CoreDataError.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 22.07.2022.
//

import Foundation

struct CoreDataError: Codable, Error {
    var error: Int
    var message: String
}
