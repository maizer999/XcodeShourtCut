//
//  HttpManager.swift
//  Mozaic
//
//  Created by Waleed Jebreen on 11/16/16.
//  Copyright © 2016 Mozaic Innovative Solutions. All rights reserved.
//

import Foundation

class HttpRestManager {

    var request = NSMutableURLRequest()

    //Mark:- Add Headers To Request
    func addHeaders(connectionType: ConnectionType){
        request.timeoutInterval = 15
        request.allHTTPHeaderFields?.removeAll()
        
        let language = Defaults.getLanguage()
        
        switch connectionType {
        case .UserId:
            let authinticationToken = SecurityManager.getAuthenticationToken(connectionType: .UserId)
            if(authinticationToken != nil){
                request.setValue(authinticationToken!, forHTTPHeaderField: ConnectionType.UserId.rawValue)
            }
            
        case .ClientId:
            let authinticationToken = SecurityManager.getAuthenticationToken(connectionType: .ClientId)
            if(authinticationToken != nil){
                request.setValue(authinticationToken!, forHTTPHeaderField: ConnectionType.ClientId.rawValue)
            }
            
        case .None:
            break
        }
        if language != 0{
            if (language != LanguageType.None.rawValue){
                request.setValue("\(language)", forHTTPHeaderField: "LANG")
            }
        }
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
    
    func addSpecialHeader(specialRequest: NSMutableURLRequest, headerValue: String, headerKey: String){
        specialRequest.setValue("\(headerValue)", forHTTPHeaderField: "\(headerKey)")
    }
    
    //Mark:- GET Request
    func get(url: String, connectionType: ConnectionType, resultHandler: @escaping (String) -> Void, errorHandler: @escaping (ErrorType) -> Void ){
        addHeaders(connectionType: connectionType)
        
        let requestUrl = checkUrl(url: url)
        if requestUrl != nil{
            request.url = requestUrl!
        }else{
            errorHandler(ErrorType.NilData)
        }
        
        request.httpMethod = "GET"
        
        startSession(sessionHandler: {jsonResult in
            resultHandler(jsonResult)
        },sessionErrorHandler: {error in
            errorHandler(error)
        })
    }
    //Mark:- POST Request
    func post(url: String, connectionType: ConnectionType, dataToPost: NSDictionary, resultHandler: @escaping (String) -> Void, errorHandler: @escaping (ErrorType) -> Void){
        addHeaders(connectionType: connectionType)
        
        let requestUrl = checkUrl(url: url)
        if requestUrl != nil{
            request.url = requestUrl!
        }else{
            errorHandler(ErrorType.NilData)
        }
        
        request.httpMethod = "POST"
        
        addToBody(data: dataToPost, bodyErrorHandler: {error in
            errorHandler(error)
        })
        
        startSession(sessionHandler: {jsonResult in
            resultHandler(jsonResult)
        },sessionErrorHandler: {error in
            errorHandler(error)
        })
    }
    
    //Mark:- PUT Request
    func put(url: String, connectionType: ConnectionType, dataToPut: NSDictionary, resultHandler: @escaping (String) -> Void, errorHandler: @escaping (ErrorType) -> Void){
        addHeaders(connectionType: connectionType)
        
        let requestUrl = checkUrl(url: url)
        if requestUrl != nil{
            request.url = requestUrl!
        }else{
            errorHandler(ErrorType.NilData)
        }
        
        request.httpMethod = "PUT"

        addToBody(data: dataToPut, bodyErrorHandler: {error in
            errorHandler(error)
        })
        
        startSession(sessionHandler: {jsonResult in
            resultHandler(jsonResult)
        },sessionErrorHandler: {error in
            errorHandler(error)
        })
    }
    //Mark:- Add Data To Request Body
    func addToBody(data: NSDictionary, bodyErrorHandler: @escaping (ErrorType) -> Void){
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions())
        } catch {
            bodyErrorHandler(.AddToBody)
        }
    }
    //Mark:- Start Http Session
    func startSession(sessionHandler: @escaping (String) -> Void, sessionErrorHandler: @escaping (ErrorType) -> Void){
        let session = URLSession.shared
        session.dataTask(with: request as URLRequest) {data, response, err in
            do {
                print("\(response)")
                if let httpResponse = response as? HTTPURLResponse{
                    if(httpResponse.statusCode == (HTTPReaponseStatusCodes.OK.rawValue)){
                        if (data != nil){
                            if let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String{
                                
                                if let errorResult = self.convertToDictionary(text: datastring){
                                    let errorsMapper = ErrorsMapper(dictionary: errorResult)
                                    if let isSucceed = errorsMapper?.isSucceeded{
                                        if isSucceed {
                                            sessionHandler(datastring)
                                        }else{
                                            sessionHandler(datastring)
                                        }
                                    }else{
                                       sessionHandler(datastring) 
                                    }
                                }else{
                                    sessionHandler(datastring)
                                }
                            }
                        }else{
                            sessionErrorHandler(.NilData)
                        }
                    }
                    else if httpResponse.statusCode == (HTTPReaponseStatusCodes.ServiceUnAvailable.rawValue){
                        sessionErrorHandler(.NotConnected)
                    }else{
                        if let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String{
                            let error = self.figureTheErrorCode(data: datastring)
                            let errorType = self.figureTheErrorType(data: error)
                            
                            sessionErrorHandler(errorType)
                        }
                        
                    }
                }else{
                    sessionErrorHandler(.NotConnected)
                }
            }
            
        }.resume()
    }
    //MARK:- Check Url
    func checkUrl(url: String) -> URL?{
        do{
            if let requestUrl = URL(string: url){
                return requestUrl
            }else{
                throw MyError.FoundNil("URLRequest")
            }
        }
        catch{
            return nil
        }
    }
    
    //MARK:- Figure Error Type
    func figureTheErrorType(data: NSDictionary) -> ErrorType{
        
        if let errorCode = data["ErrorCode"] as? Int{
            switch errorCode{
            case 0:
                return .None
            case 1:
                return .InvalidPropertyValue
            case 2:
                return .UnAuthinticatedUser
            case 3:
                return .InternalServerError
            case 4:
                return .UserDoesNotExist
            case 5:
                return .InvalidVerificationCode
            case 6:
                return .ExpiredVerificationCode
            case 7:
                return .DeviceNotActive
            case 8:
                return .ResendActivationCodePeriod
            case 9:
                return .ReferralCodeNotExist
            case 10:
                return .AlreadyEnteredReffarlCode
            case 11:
                return .SelfUserCode
            default:
                break
            }
        }
        return .None
    }
    
    func figureTheErrorCode(data: String) -> NSDictionary{
        let errorResult = convertToDictionary(text: data)!
        let errorsMapper = ErrorsMapper(dictionary: errorResult)
        var errorCode = 0
        var errorMessage = ""
        if(errorsMapper?.errors != nil){
            let errors = (errorsMapper?.errors!)!
            if(errors.count > 0){
                for error in errors{
                    errorCode = error.errorCode!
                    errorMessage = error.errorMessage!
                }
            }
        }
        let errorDic = NSMutableDictionary()
        errorDic["ErrorCode"] = errorCode
        errorDic["ErrorMessage"] = errorMessage
        
        return errorDic
    }
    
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                return dataDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return NSDictionary()
    }
    
    func convertToDictionaryArray(text: String) -> [NSDictionary]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
                return dataDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return [NSDictionary]()
    }
    
    func convertDictionaryToJSON(dictionary: NSDictionary) -> String?{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            return theJSONText
        }else{
            return nil
        }
    }
}
