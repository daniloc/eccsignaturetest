//
//  SignedMessage.swift
//  ECCSignatureTest
//
//  Created by Danilo Campos on 11/19/19.
//  Copyright © 2019 Danilo Campos. All rights reserved.
//

import Foundation
import CryptorECC

extension String {
    func toJSONDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}

class SignedMessage: Codable {
    
    let plaintext: String
    let signatureBase64: String
    
    var date: Date?
    var originalMessage: String?
    
    func uiDateString() -> String? {
        
        if let date = date {
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
            dateFormatter.locale = Locale.current
            dateFormatter.doesRelativeDateFormatting = true
            
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func parsePlaintext() {
        if let json = plaintext.toJSONDictionary(),
            let message = json["message"] as? String,
            let dateString = json["date"] as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            date = dateFormatter.date(from: dateString)
            originalMessage = message
        }
    }
    
    func validate() -> Bool {
        
        parsePlaintext()
        
        if let filepath = Bundle.main.path(forResource: "ec256pub", ofType: "pem"),
            let keyString = try? String(contentsOfFile: filepath) {
            
            do {
                let publicKey = try ECPublicKey(key: keyString)
                let signature = try ECSignature(asn1: Data(base64Encoded: signatureBase64)!)
                let verified = signature.verify(plaintext: plaintext, using: publicKey)
                
                if verified {
                    print("Signature is valid for provided plaintext")
                                        
                    return true
                }
                
            } catch {
                print(error)
            }
            
        }
        
        return false
    }
    
}
