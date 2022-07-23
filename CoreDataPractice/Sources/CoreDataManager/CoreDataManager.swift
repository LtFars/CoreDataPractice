//
//  CoreDataManager.swift
//  CoreDataPractice
//
//  Created by Denis Snezhko on 22.07.2022.
//

import CoreData
import UIKit

class CoreDataManager {
    
    // MARK: - Elements
    
    private let appDelegate: AppDelegate
    private let managedContext: NSManagedObjectContext
    private let entityName = "ProfileCardEntity"
    
    // MARK: - Lifecycle
    
    init() throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        self.appDelegate = appDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Public functions
    
    func fetchData() -> [ProfileCardEntity] {
        
        var data = [ProfileCardEntity]()
        let fetchRequest = NSFetchRequest<ProfileCardEntity>(entityName: entityName)
        
        do {
            data = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return data
    }
    
    
    func saveProfile(with name: String) -> ProfileCardEntity? {
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: "ProfileCardEntity",
            in: managedContext
        ), let profile = NSManagedObject(
            entity: entity,
            insertInto: managedContext
        ) as? ProfileCardEntity
        else { return nil }
        
        let allIDs = fetchData().map { $0.id }
        var id = Int32.random(in: 0...Int32.max)
        while allIDs.contains(id) {
            id = Int32.random(in: 0...Int32.max)
        }
        profile.setValue(name, forKeyPath: "name")
        profile.setValue(id, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return profile
    }
    
    func deleteProfile(
        _ id: Int32,
        completion: @escaping (Result<Bool, CoreDataError>) -> Void
    ) {
        
        let userProfile: ProfileCardEntity?
        let fetchProfile: NSFetchRequest<ProfileCardEntity> = ProfileCardEntity.fetchRequest()
        fetchProfile.predicate = NSPredicate(
            format: "id = %i",
            id as Int32
        )
        let results = try? managedContext.fetch(fetchProfile)
        userProfile = results?.first
        
        guard let userProfile = userProfile else {
            let error = CoreDataError(
                error: 4,
                message: "Current user is not exist."
            )
            completion(.failure(error))
            return
        }
        
        managedContext.delete(userProfile)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            let error = CoreDataError(
                error: 5,
                message: "Could not delete current user."
            )
            completion(.failure(error))
            return
        }
        completion(.success(true))
    }
    
    func changeProfile(
        _ profile: ProfileCard,
        completion: @escaping (Result<ProfileCardEntity, CoreDataError>) -> Void
    ) {
        
        let newProfile: ProfileCardEntity?
        let fetchProfile: NSFetchRequest<ProfileCardEntity> = ProfileCardEntity.fetchRequest()
        fetchProfile.predicate = NSPredicate(
            format: "id = %i",
            profile.id as Int32
        )
        
        let results = try? managedContext.fetch(fetchProfile)
        
        let name = profile.name
        let birthdayDate = profile.birthdayDate
        let gender = profile.gender
        
        // Проверяем количество найденых пользователей по ID
        if results?.count == 0 {
            // Если пользователей нет, то создаем нового
            newProfile = ProfileCardEntity(context: managedContext)
        } else if results?.count == 1 {
            
            // Если пользователь найден один, то проверям
            // Не занято ли имя, которое он хочет установить
            // (При условии что имя должно быть уникальное)
            // Так то у меня есть еще ID же
            
            // Подтягиваем всех пользователей с именем, которое хочет установить данный пользователь
            let fetchProfile: NSFetchRequest<ProfileCardEntity> = ProfileCardEntity.fetchRequest()
            fetchProfile.predicate = NSPredicate(
                format: "name = %@",
                name as String
            )
            let nameResults = try? managedContext.fetch(fetchProfile)
            
            // Собираем все ID пользователей с таким именем, которое наш пользователь хочет установить себе
            let ids = nameResults?.map { $0.id } ?? []
            
            // Если это не тот пользователь который мы хотим изменить или пользователей с таким именем больше нуля (имя занято) то выдаем ошибку и выходим из функции
            if !ids.contains(profile.id), ids.count > 0 {
                let error = CoreDataError(
                    error: 1,
                    message: "Current user exist already"
                )
                completion(.failure(error))
                return
            }
            
            // Если с таким имененм не нашелся, то берем нашего единственного пользователя и меняем ему профиль
            newProfile = results?.first
        } else {
            
            // Очень странная ошибка, если есть 2 и более пользователя с одинаковым ID
            // По сути такого быть не должно, но все же обработаем ее
            let error = CoreDataError(
                error: 2,
                message: "Two or more users with current ID exist already"
            )
            completion(.failure(error))
            return
        }
        
        newProfile?.setValue(name, forKeyPath: "name")
        newProfile?.setValue(birthdayDate, forKeyPath: "birthdayDate")
        newProfile?.setValue(gender, forKeyPath: "gender")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            
            // DEBUGGING
            print("Could not save. \(error), \(error.userInfo)")
            // DEBUGGING
            
            if error.code == 1630 {
                newProfile?.setValue(nil, forKeyPath: "birthdayDate")
            }
            
            let error = CoreDataError(
                error: error.code,
                message: error.localizedDescription
            )
            
            completion(.failure(error))
            return
        }
        
        if let newProfile = newProfile {
            completion(.success(newProfile))
        }
    }
}
