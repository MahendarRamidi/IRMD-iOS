//
//  TrayAssembly+CoreDataProperties.swift
//  FDA
//
//  Created by Kaustubh on 14/08/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import Foundation
import CoreData


extension TrayAssembly {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrayAssembly> {
        return NSFetchRequest<TrayAssembly>(entityName: "TrayAssembly")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var trayId: String?

}
