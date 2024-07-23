//
//  TrackerStore.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation
import CoreData

enum TrackerError: Error {
    case fetchError(NSError)
    case dataConversionError
}

final class TrackerStore {
    private let context = CoreDataStack.shared.persistentContainer.viewContext

    func createTracker(with tracker: Tracker) throws {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        let category = TrackerCategoryStore().fetchCategoriesCoreData().first(where: {$0.id == tracker.category?.id})
        trackerEntity.category = category
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = tracker.schedule
        trackerEntity.title = tracker.title
        
        do {
            try context.save()
        } catch let error as NSError {
            print("❌❌❌ Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func fetchTrackers() -> [Tracker] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let trackerEntities = try context.fetch(fetchRequest)
            let trackers = try trackerEntities.compactMap { trackerEntity -> Tracker in
                guard let tracker = Tracker(from: trackerEntity) else {
                    throw TrackerError.dataConversionError
                }
                return tracker
            }
            return trackers
        } catch let error as NSError {
            print("❌❌❌ Не удалось прочитать Tracker из БД", error.localizedDescription)
            return []
        }
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<TrackerCoreData> {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }
}
