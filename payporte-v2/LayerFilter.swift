//
//  LayerFilter.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/25/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class LayerFilter: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let attribute = "attribute"
        static let title = "title"
        static let filter = "filter"
    }
    
    // MARK: Properties
    public var attribute: String?
    public var title: String?
    public var filter: [Filter]?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        attribute = json[SerializationKeys.attribute].string
        title = json[SerializationKeys.title].string
        if let items = json[SerializationKeys.filter].array { filter = items.map { Filter(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = attribute { dictionary[SerializationKeys.attribute] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = filter { dictionary[SerializationKeys.filter] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.attribute = aDecoder.decodeObject(forKey: SerializationKeys.attribute) as? String
        self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
        self.filter = aDecoder.decodeObject(forKey: SerializationKeys.filter) as? [Filter]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(attribute, forKey: SerializationKeys.attribute)
        aCoder.encode(title, forKey: SerializationKeys.title)
        aCoder.encode(filter, forKey: SerializationKeys.filter)
    }
    
}
