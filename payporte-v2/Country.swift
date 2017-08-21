//
//  Country.swift
//
//  Created by SimpuMind on 8/21/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Country: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let countryName = "country_name"
    static let iD = "_ID"
    static let countryCode = "country_code"
    static let states = "states"
  }

  // MARK: Properties
  public var countryName: String?
  public var iD: String?
  public var countryCode: String?
  public var states: [States]?

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
    countryName = json[SerializationKeys.countryName].string
    iD = json[SerializationKeys.iD].string
    countryCode = json[SerializationKeys.countryCode].string
    if let items = json[SerializationKeys.states].array { states = items.map { States(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = countryName { dictionary[SerializationKeys.countryName] = value }
    if let value = iD { dictionary[SerializationKeys.iD] = value }
    if let value = countryCode { dictionary[SerializationKeys.countryCode] = value }
    if let value = states { dictionary[SerializationKeys.states] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.countryName = aDecoder.decodeObject(forKey: SerializationKeys.countryName) as? String
    self.iD = aDecoder.decodeObject(forKey: SerializationKeys.iD) as? String
    self.countryCode = aDecoder.decodeObject(forKey: SerializationKeys.countryCode) as? String
    self.states = aDecoder.decodeObject(forKey: SerializationKeys.states) as? [States]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(countryName, forKey: SerializationKeys.countryName)
    aCoder.encode(iD, forKey: SerializationKeys.iD)
    aCoder.encode(countryCode, forKey: SerializationKeys.countryCode)
    aCoder.encode(states, forKey: SerializationKeys.states)
  }

}
