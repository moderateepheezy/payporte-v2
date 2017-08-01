//
//  Options.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/31/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Options: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let position = "position"
        static let optionType = "option_type"
        static let dependenceOptionIds = "dependence_option_ids"
        static let optionId = "option_id"
        static let optionValue = "option_value"
        static let isRequired = "is_required"
        static let optionTypeId = "option_type_id"
        static let optionPrice = "option_price"
        static let optionTitle = "option_title"
    }
    
    // MARK: Properties
    public var position: String?
    public var optionType: String?
    public var dependenceOptionIds: [String]?
    public var optionId: String?
    public var optionValue: String?
    public var isRequired: String?
    public var optionTypeId: String?
    public var optionPrice: String?
    public var optionTitle: String?
    
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
        position = json[SerializationKeys.position].string
        optionType = json[SerializationKeys.optionType].string
        if let items = json[SerializationKeys.dependenceOptionIds].array { dependenceOptionIds = items.map { $0.stringValue } }
        optionId = json[SerializationKeys.optionId].string
        optionValue = json[SerializationKeys.optionValue].string
        isRequired = json[SerializationKeys.isRequired].string
        optionTypeId = json[SerializationKeys.optionTypeId].string
        optionPrice = json[SerializationKeys.optionPrice].string
        optionTitle = json[SerializationKeys.optionTitle].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = position { dictionary[SerializationKeys.position] = value }
        if let value = optionType { dictionary[SerializationKeys.optionType] = value }
        if let value = dependenceOptionIds { dictionary[SerializationKeys.dependenceOptionIds] = value }
        if let value = optionId { dictionary[SerializationKeys.optionId] = value }
        if let value = optionValue { dictionary[SerializationKeys.optionValue] = value }
        if let value = isRequired { dictionary[SerializationKeys.isRequired] = value }
        if let value = optionTypeId { dictionary[SerializationKeys.optionTypeId] = value }
        if let value = optionPrice { dictionary[SerializationKeys.optionPrice] = value }
        if let value = optionTitle { dictionary[SerializationKeys.optionTitle] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.position = aDecoder.decodeObject(forKey: SerializationKeys.position) as? String
        self.optionType = aDecoder.decodeObject(forKey: SerializationKeys.optionType) as? String
        self.dependenceOptionIds = aDecoder.decodeObject(forKey: SerializationKeys.dependenceOptionIds) as? [String]
        self.optionId = aDecoder.decodeObject(forKey: SerializationKeys.optionId) as? String
        self.optionValue = aDecoder.decodeObject(forKey: SerializationKeys.optionValue) as? String
        self.isRequired = aDecoder.decodeObject(forKey: SerializationKeys.isRequired) as? String
        self.optionTypeId = aDecoder.decodeObject(forKey: SerializationKeys.optionTypeId) as? String
        self.optionPrice = aDecoder.decodeObject(forKey: SerializationKeys.optionPrice) as? String
        self.optionTitle = aDecoder.decodeObject(forKey: SerializationKeys.optionTitle) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(position, forKey: SerializationKeys.position)
        aCoder.encode(optionType, forKey: SerializationKeys.optionType)
        aCoder.encode(dependenceOptionIds, forKey: SerializationKeys.dependenceOptionIds)
        aCoder.encode(optionId, forKey: SerializationKeys.optionId)
        aCoder.encode(optionValue, forKey: SerializationKeys.optionValue)
        aCoder.encode(isRequired, forKey: SerializationKeys.isRequired)
        aCoder.encode(optionTypeId, forKey: SerializationKeys.optionTypeId)
        aCoder.encode(optionPrice, forKey: SerializationKeys.optionPrice)
        aCoder.encode(optionTitle, forKey: SerializationKeys.optionTitle)
    }
    
}
