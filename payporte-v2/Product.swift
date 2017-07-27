//
//  Product.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/27/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Product: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let productRegularPrice = "product_regular_price"
        static let iD = "_ID"
        static let productName = "product_name"
        static let productPrice = "product_price"
        static let productAttributes = "product_attributes"
        static let options = "options"
        static let maxQty = "max_qty"
        static let stockStatus = "stock_status"
        static let productId = "product_id"
        static let productDescription = "product_description"
        static let productImages = "product_images"
        static let productShortDescription = "product_short_description"
        static let productUrl = "product_url"
    }
    
    // MARK: Properties
    public var productRegularPrice: String?
    public var iD: String?
    public var productName: String?
    public var productPrice: String?
    public var productAttributes: [ProductAttributes]?
    public var options: [Any]?
    public var maxQty: String?
    public var stockStatus: String?
    public var productId: String?
    public var productDescription: String?
    public var productImages: [String]?
    public var productShortDescription: String?
    public var productUrl: String?
    
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
        productRegularPrice = json[SerializationKeys.productRegularPrice].string
        iD = json[SerializationKeys.iD].string
        productName = json[SerializationKeys.productName].string
        productPrice = json[SerializationKeys.productPrice].string
        if let items = json[SerializationKeys.productAttributes].array { productAttributes = items.map { ProductAttributes(json: $0) } }
        if let items = json[SerializationKeys.options].array { options = items.map { $0.object} }
        maxQty = json[SerializationKeys.maxQty].string
        stockStatus = json[SerializationKeys.stockStatus].string
        productId = json[SerializationKeys.productId].string
        productDescription = json[SerializationKeys.productDescription].string
        if let items = json[SerializationKeys.productImages].array { productImages = items.map { $0.stringValue } }
        productShortDescription = json[SerializationKeys.productShortDescription].string
        productUrl = json[SerializationKeys.productUrl].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = productRegularPrice { dictionary[SerializationKeys.productRegularPrice] = value }
        if let value = iD { dictionary[SerializationKeys.iD] = value }
        if let value = productName { dictionary[SerializationKeys.productName] = value }
        if let value = productPrice { dictionary[SerializationKeys.productPrice] = value }
        if let value = productAttributes { dictionary[SerializationKeys.productAttributes] = value.map { $0.dictionaryRepresentation() } }
        if let value = options { dictionary[SerializationKeys.options] = value }
        if let value = maxQty { dictionary[SerializationKeys.maxQty] = value }
        if let value = stockStatus { dictionary[SerializationKeys.stockStatus] = value }
        if let value = productId { dictionary[SerializationKeys.productId] = value }
        if let value = productDescription { dictionary[SerializationKeys.productDescription] = value }
        if let value = productImages { dictionary[SerializationKeys.productImages] = value }
        if let value = productShortDescription { dictionary[SerializationKeys.productShortDescription] = value }
        if let value = productUrl { dictionary[SerializationKeys.productUrl] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.productRegularPrice = aDecoder.decodeObject(forKey: SerializationKeys.productRegularPrice) as? String
        self.iD = aDecoder.decodeObject(forKey: SerializationKeys.iD) as? String
        self.productName = aDecoder.decodeObject(forKey: SerializationKeys.productName) as? String
        self.productPrice = aDecoder.decodeObject(forKey: SerializationKeys.productPrice) as? String
        self.productAttributes = aDecoder.decodeObject(forKey: SerializationKeys.productAttributes) as? [ProductAttributes]
        self.options = aDecoder.decodeObject(forKey: SerializationKeys.options) as? [Any]
        self.maxQty = aDecoder.decodeObject(forKey: SerializationKeys.maxQty) as? String
        self.stockStatus = aDecoder.decodeObject(forKey: SerializationKeys.stockStatus) as? String
        self.productId = aDecoder.decodeObject(forKey: SerializationKeys.productId) as? String
        self.productDescription = aDecoder.decodeObject(forKey: SerializationKeys.productDescription) as? String
        self.productImages = aDecoder.decodeObject(forKey: SerializationKeys.productImages) as? [String]
        self.productShortDescription = aDecoder.decodeObject(forKey: SerializationKeys.productShortDescription) as? String
        self.productUrl = aDecoder.decodeObject(forKey: SerializationKeys.productUrl) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(productRegularPrice, forKey: SerializationKeys.productRegularPrice)
        aCoder.encode(iD, forKey: SerializationKeys.iD)
        aCoder.encode(productName, forKey: SerializationKeys.productName)
        aCoder.encode(productPrice, forKey: SerializationKeys.productPrice)
        aCoder.encode(productAttributes, forKey: SerializationKeys.productAttributes)
        aCoder.encode(options, forKey: SerializationKeys.options)
        aCoder.encode(maxQty, forKey: SerializationKeys.maxQty)
        aCoder.encode(stockStatus, forKey: SerializationKeys.stockStatus)
        aCoder.encode(productId, forKey: SerializationKeys.productId)
        aCoder.encode(productDescription, forKey: SerializationKeys.productDescription)
        aCoder.encode(productImages, forKey: SerializationKeys.productImages)
        aCoder.encode(productShortDescription, forKey: SerializationKeys.productShortDescription)
        aCoder.encode(productUrl, forKey: SerializationKeys.productUrl)
    }
    
}
