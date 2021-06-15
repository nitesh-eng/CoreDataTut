//
//  BucketListItem+CoreDataProperties.swift
//  CoreDataTut
//
//  Created by Nitesh Mainaly on 6/15/21.
//
//

import Foundation
import CoreData


extension BucketListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BucketListItem> {
        return NSFetchRequest<BucketListItem>(entityName: "BucketListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateAdded: Date?

}

extension BucketListItem : Identifiable {

}
