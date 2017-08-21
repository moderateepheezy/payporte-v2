//
//  States.swift
//
//  Created by SimpuMind on 8/21/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class States: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let stateId = "state_id"
    static let stateName = "state_name"
    static let stateCode = "state_code"
  }

  // MARK: Properties
  public var stateId: String?
  public var stateName: String?
  public var stateCode: String?

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
    stateId = json[SerializationKeys.stateId].string
    stateName = json[SerializationKeys.stateName].string
    stateCode = json[SerializationKeys.stateCode].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = stateId { dictionary[SerializationKeys.stateId] = value }
    if let value = stateName { dictionary[SerializationKeys.stateName] = value }
    if let value = stateCode { dictionary[SerializationKeys.stateCode] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.stateId = aDecoder.decodeObject(forKey: SerializationKeys.stateId) as? String
    self.stateName = aDecoder.decodeObject(forKey: SerializationKeys.stateName) as? String
    self.stateCode = aDecoder.decodeObject(forKey: SerializationKeys.stateCode) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(stateId, forKey: SerializationKeys.stateId)
    aCoder.encode(stateName, forKey: SerializationKeys.stateName)
    aCoder.encode(stateCode, forKey: SerializationKeys.stateCode)
  }

}
