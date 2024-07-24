//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Юрий Клеймёнов on 23/07/2024.
//

import Foundation
import CoreData

enum TrackerRecordError: Error {
    case fetchError(NSError)
    case dataConversionError
}

final class TrackerRecordStore {
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    
    func createTrackerRecord(with trackerRecord: TrackerRecord) throws {
        let trakerRecordEntity = TrackerRecordCoreData(context: context)
        trakerRecordEntity.id = trackerRecord.id
        trakerRecordEntity.date = trackerRecord.date
        
        do {
            try context.save()
        } catch let error as NSError {
            throw TrackerRecordError.fetchError(error)
        }
    }
    
    func fetchTrackerRecords() -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let trackerRecordsEntities = try context.fetch(fetchRequest)
            let trackerRecords = trackerRecordsEntities.compactMap { recordEntity ->
                TrackerRecord? in
                return TrackerRecord(from: recordEntity)
            }
            return trackerRecords
        } catch let error as NSError {
            print("❌❌❌ Не удалось получить записи выполненных трекеров: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func deleteTrackerRecord(withId id: UUID) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
            print("✅ Запись трекера с id \(id) успешно удалена")
        } catch let error as NSError {
            print("❌ Ошибка при удалении записи трекера: \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<TrackerRecordCoreData> {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
