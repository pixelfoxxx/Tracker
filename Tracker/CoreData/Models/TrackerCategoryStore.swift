//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation
import CoreData

enum CategoryError: Error {
    case fetchError(NSError)
    case dataConversionError
}

final class TrackerCategoryStore {
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    
    func createCategory(with category: TrackerCategory) throws {
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.id = category.id
        categoryEntity.name = category.title

        do {
            try context.save()
        } catch let error as NSError {
            throw CategoryError.fetchError(error)
        }
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()

        do {
            let categoryEntities = try context.fetch(fetchRequest)
            let categories = categoryEntities.compactMap { categoryEntity -> TrackerCategory? in
                return TrackerCategory(from: categoryEntity)
            }
            return categories
        } catch let error as NSError {
            print("❌❌❌ Не удалось получить категории: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchCategoriesCoreData() -> [TrackerCategoryCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()

        do {
            let categoryEntities = try context.fetch(fetchRequest)
            return categoryEntities
        } catch let error as NSError {
            print("❌❌❌ Не удалось получить категории: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<TrackerCategoryCoreData> {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
