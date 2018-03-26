//
//  B+CoreDataProperties.swift
//  FDA
//
//  Created by Kaustubh on 14/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import Foundation
import CoreData


extension B {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<B> {
        return NSFetchRequest<B>(entityName: "B")
    }
}
