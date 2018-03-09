//
//  RunningWallet.swift
//  iOS-Reload
//
//  Created by Matthew Li on 2018-03-08.
//  Copyright © 2018 matthewli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RunningWallet: NSObject {
    var url: String
    var address: String
    
    init(nodeUrl: String, walletAddress: String) {
        url = nodeUrl
        address = walletAddress
    }
    
    func getHeight(completion: @escaping (_ height: UInt64?, _ error: Error?) -> Void ) {
        
        let parameters: Parameters = [
            "jsonrpc": "2.0",
            "method": "getblockcount",
            "params": "[]",
            "id": 1
        ]
        
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters).responseJSON { response in
                            self.logResponse(response)
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                print("JSON: \(json)")
                                if let height = json["result"].uInt64 {
                                    completion(height, nil)
                                } else {
                                    completion(nil, nil)
                                }

                            case .failure(let error):
                                print(error)
                                completion(nil, error)
                            }
        }
    }
    
    func getBalance(completion: @escaping (_ assetBalances: Dictionary<String, Double>?, _ error: Error?) -> Void ) {
        let parameters: Parameters = [
            "jsonrpc": "2.0",
            "method": "getaccountstate",
            "params": "[\"\(address)\"]",
            "id": 1
        ]
        
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters).responseJSON { response in
                            self.logResponse(response)
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                print("JSON: \(json)")
                                if let balances = json["result"]["balances"].array {
                                    var assetBalances = [String: Double]()
                                    for asset in balances {
                                        if let name = asset["asset"].string, let balance = asset["value"].string {
                                            assetBalances[name] = Double(balance)
                                        }
                                    }
                                    completion(assetBalances, nil)
                                } else {
                                    completion(nil, nil)
                                }
                                
                            case .failure(let error):
                                print(error)
                                completion(nil, error)
                            }
        }
    }

    func sendAsset(_ assetId: String, amount: Double, to address: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void ) {
        let parameters: Parameters = [
            "jsonrpc": "2.0",
            "method": "sendtoaddress",
            "params": "[\"" + assetId + "\",\"" + address + "\",\(amount)]",
            "id": 1
        ]
        
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters).responseJSON { response in
                            self.logResponse(response)
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                print("JSON: \(json)")
                                if json["result"]["txid"].string != nil {
                                    completion(true, nil)
                                } else {
                                    completion(false, nil)
                                }
                                
                            case .failure(let error):
                                print(error)
                                completion(false, error)
                            }
        }
    }

    func logResponse(_ response: DataResponse<Any>) {
        print("Request: \(String(describing: response.request))")
        print("Response: \(String(describing: response.response))")
        print("Error: \(String(describing: response.error))")
    }

}
