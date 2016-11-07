//
//  Todo.swift
//  CoreDataSample001
//
//  Created by Shinya Hirai on 2015/10/29.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

import Foundation
import CoreData

class Todo: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var saveDate: Date

}
