//
//  RealmManager.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 1.09.23.
//

import Foundation
import RealmSwift

protocol RealmManagerProtocol {
    var realm: Realm { get }
    func addMovieId(id: InfoAboutSelectMovieModel)
    func removeMovieId(id: InfoAboutSelectMovieModel)
}

class RealmManager: RealmManagerProtocol {
    
    var realm = try! Realm()
    
    func addMovieId(id: InfoAboutSelectMovieModel) {
        
        let id = MoviesIdDataBase(nameId: id.imdbID)
        do {
            try self.realm.write {
                self.realm.add(id)
            }
        } catch {
            print(error)
        }
    }
    
    func removeMovieId(id: InfoAboutSelectMovieModel) {
        let selectedId = realm.objects(MoviesIdDataBase.self)
            .filter("id == %@", id.imdbID) // Фильтруем объекты по выбранному айди
        
        do {
            try realm.write {
                if let movieToRemove = selectedId.first { // Получаем первый найденный объект
                    realm.delete(movieToRemove) // Удаляем найденный объект
                }
            }
        } catch {
            print(error)
        }
    }
}
            
        
    


