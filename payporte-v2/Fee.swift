//
//  Fee.swift
//
//  Created by SimpuMind on 8/23/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Fee: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let couponCode = "coupon_code"
    static let subTotal = "sub_total"
    static let discount = "discount"
    static let v2 = "v2"
    static let condition = "condition"
    static let tax = "tax"
    static let grandTotal = "grand_total"
  }

  // MARK: Properties
  public var couponCode: String?
  public var subTotal: Int?
  public var discount: Int?
  public var v2: V2?
  public var condition: [Any]?
  public var tax: Int?
  public var grandTotal: Int?

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
    couponCode = json[SerializationKeys.couponCode].string
    subTotal = json[SerializationKeys.subTotal].int
    discount = json[SerializationKeys.discount].int
    v2 = V2(json: json[SerializationKeys.v2])
    if let items = json[SerializationKeys.condition].array { condition = items.map { $0.object} }
    tax = json[SerializationKeys.tax].int
    grandTotal = json[SerializationKeys.grandTotal].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = couponCode { dictionary[SerializationKeys.couponCode] = value }
    if let value = subTotal { dictionary[SerializationKeys.subTotal] = value }
    if let value = discount { dictionary[SerializationKeys.discount] = value }
    if let value = v2 { dictionary[SerializationKeys.v2] = value.dictionaryRepresentation() }
    if let value = condition { dictionary[SerializationKeys.condition] = value }
    if let value = tax { dictionary[SerializationKeys.tax] = value }
    if let value = grandTotal { dictionary[SerializationKeys.grandTotal] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.couponCode = aDecoder.decodeObject(forKey: SerializationKeys.couponCode) as? String
    self.subTotal = aDecoder.decodeObject(forKey: SerializationKeys.subTotal) as? Int
    self.discount = aDecoder.decodeObject(forKey: SerializationKeys.discount) as? Int
    self.v2 = aDecoder.decodeObject(forKey: SerializationKeys.v2) as? V2
    self.condition = aDecoder.decodeObject(forKey: SerializationKeys.condition) as? [Any]
    self.tax = aDecoder.decodeObject(forKey: SerializationKeys.tax) as? Int
    self.grandTotal = aDecoder.decodeObject(forKey: SerializationKeys.grandTotal) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(couponCode, forKey: SerializationKeys.couponCode)
    aCoder.encode(subTotal, forKey: SerializationKeys.subTotal)
    aCoder.encode(discount, forKey: SerializationKeys.discount)
    aCoder.encode(v2, forKey: SerializationKeys.v2)
    aCoder.encode(condition, forKey: SerializationKeys.condition)
    aCoder.encode(tax, forKey: SerializationKeys.tax)
    aCoder.encode(grandTotal, forKey: SerializationKeys.grandTotal)
  }

}
