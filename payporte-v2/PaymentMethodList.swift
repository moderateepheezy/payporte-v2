//
//  PaymentMethodList.swift
//
//  Created by SimpuMind on 8/23/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class PaymentMethodList: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let content = "content"
    static let title = "title"
    static let showType = "show_type"
    static let paymentMethod = "payment_method"
  }

  // MARK: Properties
  public var content: String?
  public var title: String?
  public var showType: Int?
  public var paymentMethod: String?

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
    content = json[SerializationKeys.content].string
    title = json[SerializationKeys.title].string
    showType = json[SerializationKeys.showType].int
    paymentMethod = json[SerializationKeys.paymentMethod].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = content { dictionary[SerializationKeys.content] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = showType { dictionary[SerializationKeys.showType] = value }
    if let value = paymentMethod { dictionary[SerializationKeys.paymentMethod] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.content = aDecoder.decodeObject(forKey: SerializationKeys.content) as? String
    self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
    self.showType = aDecoder.decodeObject(forKey: SerializationKeys.showType) as? Int
    self.paymentMethod = aDecoder.decodeObject(forKey: SerializationKeys.paymentMethod) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(content, forKey: SerializationKeys.content)
    aCoder.encode(title, forKey: SerializationKeys.title)
    aCoder.encode(showType, forKey: SerializationKeys.showType)
    aCoder.encode(paymentMethod, forKey: SerializationKeys.paymentMethod)
  }

}
