//
//  RealmManager.swift
//  MonsterChat
//
//  Created by Obaro Paul on 19/06/2024.
//

import Foundation
import RealmSwift

class RealmManager:ObservableObject {
    static let instance = RealmManager()
    private init() {}  // Make the initializer private to enforce singleton usage

    // Save an object to Realm
    func saveToRealm<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
//                realm.add(object)
                realm.add(object, update: .modified)
            }
//            print("Object saved to realm")

        } catch {
            print("Error saving object to Realm: \(error)")
        }
    }

    // Delete an object from Realm
    func deleteFromRealm<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try! realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting object from Realm: \(error)")
        }
    }

    // Retrieve all objects of a specific type from Realm
    func fetchAllObjects<T: Object>(ofType type: T.Type) -> Results<T>? {
        do {
            let realm = try Realm()
            return realm.objects(type)
        } catch {
            print("Error fetching objects from Realm: \(error)")
            return nil
        }
    }
    
    // Retrieve all objects of a specific type from Realm
    func fetchChat<T: Object>(ofType type: T.Type) -> Results<T>? {
        do {
            let realm = try Realm()
            return realm.objects(type)
        } catch {
            print("Error fetching objects from Realm: \(error)")
            return nil
        }
    }

    // Update an object in Realm
    func updateInRealm<T: Object>(_ object: T, with updates: (T) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                updates(object)
            }
        } catch {
            print("Error updating object in Realm: \(error)")
        }
    }
    
    func clearRealmDatabase() {
           do {
               let realm = try Realm()
               try realm.write {
                   realm.deleteAll()
               }
               print("Realm database cleared")
           } catch {
               print("Error clearing Realm database: \(error)")
           }
       }
}
