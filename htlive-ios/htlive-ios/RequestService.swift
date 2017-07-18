//
//  RequestService.swift
//  htlive-ios
//
//  Created by Arjun Attam on 17/07/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import HyperTrack
import Alamofire

class RequestService {
    static let shared = RequestService()
    
    let baseUrl = "https://api.hypertrack.com/api/v1/"
    
    func makeHyperTrackRequest(urlSuffix:String, body:[String:Any], completionHandler: @escaping (_ error: HyperTrackError?) -> Void) {
        guard let userId = HyperTrack.getUserId() else {
            // TODO: handle no user id
            return
        }
        
        guard let token = HyperTrack.getPublishableKey() else {
            // TODO: handle no publishable key
            return
        }
        
        let url = "\(baseUrl)users/\(userId)/\(urlSuffix)/"
        let headers = ["Authorization": "token \(token)"]
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print(error)
                print(String(data: response.data!, encoding: .utf8))
            }
        }
    }
    
    func resendHyperTrackCode(completionHandler: @escaping (_ error: HyperTrackError?) -> Void) {
        makeHyperTrackRequest(urlSuffix: "send_verification", body: [:], completionHandler: completionHandler)
    }
    
    func validateHyperTrackCode(code: String, completionHandler: @escaping (_ error: HyperTrackError?) -> Void) {
        let body = ["verification_code": code]
        makeHyperTrackRequest(urlSuffix: "validate_code", body: body, completionHandler: completionHandler)
    }
}