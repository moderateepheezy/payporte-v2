//
//  ShippingMethodList.swift
//
//  Created by SimpuMind on 8/23/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ShippingMethodList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sMethodCode = "s_method_code"
    static let sMethodFee = "s_method_fee"
    static let sMethodSelected = "s_method_selected"
    static let sMethodName = "s_method_name"
    static let sMethodTitle = "s_method_title"
    static let sMethodId = "s_method_id"
  }

  // MARK: Properties
  public var sMethodCode: String?
  public var sMethodFee: Int?
  public var sMethodSelected: Bool? = false
  public var sMethodName: String?
  public var sMethodTitle: String?
  public var sMethodId: String?

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
    sMethodCode = json[SerializationKeys.sMethodCode].string
    sMethodFee = json[SerializationKeys.sMethodFee].int
    sMethodSelected = json[SerializationKeys.sMethodSelected].boolValue
    sMethodName = json[SerializationKeys.sMethodName].string
    sMethodTitle = json[SerializationKeys.sMethodTitle].string
    sMethodId = json[SerializationKeys.sMethodId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = sMethodCode { dictionary[SerializationKeys.sMethodCode] = value }
    if let value = sMethodFee { dictionary[SerializationKeys.sMethodFee] = value }
    dictionary[SerializationKeys.sMethodSelected] = sMethodSelected
    if let value = sMethodName { dictionary[SerializationKeys.sMethodName] = value }
    if let value = sMethodTitle { dictionary[SerializationKeys.sMethodTitle] = value }
    if let value = sMethodId { dictionary[SerializationKeys.sMethodId] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.sMethodCode = aDecoder.decodeObject(forKey: SerializationKeys.sMethodCode) as? String
    self.sMethodFee = aDecoder.decodeObject(forKey: SerializationKeys.sMethodFee) as? Int
    self.sMethodSelected = aDecoder.decodeBool(forKey: SerializationKeys.sMethodSelected)
    self.sMethodName = aDecoder.decodeObject(forKey: SerializationKeys.sMethodName) as? String
    self.sMethodTitle = aDecoder.decodeObject(forKey: SerializationKeys.sMethodTitle) as? String
    self.sMethodId = aDecoder.decodeObject(forKey: SerializationKeys.sMethodId) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(sMethodCode, forKey: SerializationKeys.sMethodCode)
    aCoder.encode(sMethodFee, forKey: SerializationKeys.sMethodFee)
    aCoder.encode(sMethodSelected, forKey: SerializationKeys.sMethodSelected)
    aCoder.encode(sMethodName, forKey: SerializationKeys.sMethodName)
    aCoder.encode(sMethodTitle, forKey: SerializationKeys.sMethodTitle)
    aCoder.encode(sMethodId, forKey: SerializationKeys.sMethodId)
  }

}
