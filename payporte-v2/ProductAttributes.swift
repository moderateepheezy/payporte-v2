//
//  ProductAttributes.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/27/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ProductAttributes: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let title = "title"
        static let value = "value"
    }
    
    // MARK: Properties
    public var title: String?
    public var value: String?
    
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
        title = json[SerializationKeys.title].string
        value = json[SerializationKeys.value].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = value { dictionary[SerializationKeys.value] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
        self.value = aDecoder.decodeObject(forKey: SerializationKeys.value) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: SerializationKeys.title)
        aCoder.encode(value, forKey: SerializationKeys.value)
    }
    
}
