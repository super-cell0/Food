//
//  Restaurant.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/10/11.
//

import Foundation
import CoreData

public class Restaurant: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var location: String
    @NSManaged public var phone: String
    @NSManaged public var summary: String //description
    @NSManaged public var image: Data
    @NSManaged public var isFavorite: Bool
    @NSManaged public var ratingText: String?
}

extension Restaurant {
    //回传segue的表情
        enum Rating: String {
            case awesome
            case good
            case okay
            case bad
            case terrible
            
            var image: String {
                switch self {
                case .awesome: return "love"
                case .good: return "cool"
                case .okay: return "happy"
                case .bad: return "sad"
                case .terrible: return "angry"
                }
            }
        }
    
        var rating: Rating? {
            get {
                guard let ratingText = ratingText else {
                    return nil
                }
    
                return Rating(rawValue: ratingText)
            }
    
            set {
                self.ratingText = newValue?.rawValue
            }
        }
    
}
//
//struct Restaurant: Hashable {
//
//    //回传segue的表情
//    enum Rating: String {
//        case awesome
//        case good
//        case okay
//        case bad
//        case terrible
//
//        var image: String {
//            switch self {
//            case .awesome: return "love"
//            case .good: return "cool"
//            case .okay: return "happy"
//            case .bad: return "sad"
//            case .terrible: return "angry"
//            }
//        }
//    }
//
//    var name: String = ""
//    var location: String = ""
//    var type: String = ""
//    var image: String = ""
//    var isFavorite: Bool = false
//    var phone: String = ""
//    var description: String = ""
//    var rating: Rating?
////    {
////        get {
////            guard let ratingText = ratingText else {
////                return nil
////            }
////
////            return Rating(rawValue: ratingText)
////        }
////
////        set {
////            self.ratingText = newValue?.rawValue
////        }
////    }
//}
