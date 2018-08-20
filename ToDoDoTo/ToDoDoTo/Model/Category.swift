//
//  Category.swift
//  ToDoDoTo
//
//  Created by Admin on 19.08.2018.
//  Copyright © 2018 MaximMasov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
