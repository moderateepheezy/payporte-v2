//
//  Payment.swift
//
//  Created by SimpuMind on 8/23/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Payment: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let iD = "_ID"
    static let paymentMethodList = "payment_method_list"
    static let fee = "fee"
    static let shippingMethodList = "shipping_method_list"
  }

  // MARK: Properties
  public var iD: String?
  public var paymentMethodList: [PaymentMethodList]?
  public var fee: Fee?
  public var shippingMethodList: [ShippingMethodList]?

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
    iD = json[SerializationKeys.iD].string
    if let items = json[SerializationKeys.paymentMethodList].array { paymentMethodList = items.map { PaymentMethodList(json: $0) } }
    fee = Fee(json: json[SerializationKeys.fee])
    if let items = json[SerializationKeys.shippingMethodList].array { shippingMethodList = items.map { ShippingMethodList(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = iD { dictionary[SerializationKeys.iD] = value }
    if let value = paymentMethodList { dictionary[SerializationKeys.paymentMethodList] = value.map { $0.dictionaryRepresentation() } }
    if let value = fee { dictionary[SerializationKeys.fee] = value.dictionaryRepresentation() }
    if let value = shippingMethodList { dictionary[SerializationKeys.shippingMethodList] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.iD = aDecoder.decodeObject(forKey: SerializationKeys.iD) as? String
    self.paymentMethodList = aDecoder.decodeObject(forKey: SerializationKeys.paymentMethodList) as? [PaymentMethodList]
    self.fee = aDecoder.decodeObject(forKey: SerializationKeys.fee) as? Fee
    self.shippingMethodList = aDecoder.decodeObject(forKey: SerializationKeys.shippingMethodList) as? [ShippingMethodList]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(iD, forKey: SerializationKeys.iD)
    aCoder.encode(paymentMethodList, forKey: SerializationKeys.paymentMethodList)
    aCoder.encode(fee, forKey: SerializationKeys.fee)
    aCoder.encode(shippingMethodList, forKey: SerializationKeys.shippingMethodList)
  }

}
