//
//  RealmManager.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 1.09.23.
//

import Foundation
import RealmSwift

class MoviesIdDataBase: Object {
   
    @Persisted var id: String
    
    convenience init(nameId: String) {
        self.init()
        self.id = nameId
    }
}
