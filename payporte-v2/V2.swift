//
//  V2.swift
//
//  Created by SimpuMind on 8/23/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class V2: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let subtotal = "subtotal"
    static let grandTotal = "grand_total"
  }

  // MARK: Properties
  public var subtotal: Int?
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
    subtotal = json[SerializationKeys.subtotal].int
    grandTotal = json[SerializationKeys.grandTotal].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = subtotal { dictionary[SerializationKeys.subtotal] = value }
    if let value = grandTotal { dictionary[SerializationKeys.grandTotal] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.subtotal = aDecoder.decodeObject(forKey: SerializationKeys.subtotal) as? Int
    self.grandTotal = aDecoder.decodeObject(forKey: SerializationKeys.grandTotal) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(subtotal, forKey: SerializationKeys.subtotal)
    aCoder.encode(grandTotal, forKey: SerializationKeys.grandTotal)
  }

}
