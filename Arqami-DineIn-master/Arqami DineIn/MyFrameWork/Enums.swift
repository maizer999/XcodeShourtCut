//
//  Enums.swift
//  Black Stone
//
//  Created by Waleed Jebreen on 7/6/17.
//  Copyright © 2017 Black Stone. All rights reserved.
//

import Foundation

enum HTTPReaponseStatusCodes :Int{
    case OK = 200
    case ServiceUnAvailable = 503
}

//MARK:- ErrorType Enum
public enum ErrorType {
    case None
    case InvalidPropertyValue
    case UnAuthinticatedUser
    case InternalServerError
    case UserDoesNotExist
    case InvalidVerificationCode
    case ExpiredVerificationCode
    case DeviceNotActive
    case ResendActivationCodePeriod
    case ReferralCodeNotExist
    case AlreadyEnteredReffarlCode
    case SelfUserCode
    case NilData
    case AddToBody
    case NotConnected
}

//MARK: - MYErrors
enum MyError: Error {
    case FoundNil(String)
}
//MARK:- Table Status Enum
public enum TableStatus: Int{
    case Available = 0
    case Occupied = 1
    case Reserved = 2
    case Service = 3
}
//MARK:- Language Enum
public enum LanguageType: Int{
    case Arabic = 1
    case English = 2
    case None = 0
}
//MARK:- Months Enum
public enum Months: Int{
    case January = 1
    case February = 2
    case March = 3
    case April = 4
    case May = 5
    case June = 6
    case July = 7
    case Augest = 8
    case September = 9
    case October = 10
    case November = 11
    case December = 12
}
//MARK:- Days Enum
public enum Days: Int{
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
}

//MARK:- ConnectionType Enum
public enum ConnectionType: String {
    case ClientId = "ClientId"
    case UserId = "UserId"
    case None
}

