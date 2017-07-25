//
//  Layerednavigation.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/25/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Layerednavigation: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let layerFilter = "layer_filter"
    }
    
    // MARK: Properties
    public var layerFilter: [LayerFilter]?
    
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
        if let items = json[SerializationKeys.layerFilter].array { layerFilter = items.map { LayerFilter(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = layerFilter { dictionary[SerializationKeys.layerFilter] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.layerFilter = aDecoder.decodeObject(forKey: SerializationKeys.layerFilter) as? [LayerFilter]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(layerFilter, forKey: SerializationKeys.layerFilter)
    }
    
}
