//
//  AppDelegate.swift
//  ECCSignatureTest
//
//  Created by Danilo Campos on 11/19/19.
//  Copyright © 2019 Danilo Campos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var signatureStatusLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet var textView: NSTextView!
    
    
    //MARK: - File Handling
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        
        let extensionName = "eccsignaturetest"
        
        if filename.contains(extensionName) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filename), options: .mappedIfSafe)
                let signedMessage = try JSONDecoder().decode(SignedMessage.self, from: data)
                
                if signedMessage.validate() {
                    print("Valid signature")
                    
                    signatureStatusLabel.stringValue = "Valid signature"
                    signatureStatusLabel.textColor = NSColor(named: "Valid")
                    
                } else {
                    signatureStatusLabel.stringValue = "Could not verify signature"
                    signatureStatusLabel.textColor = NSColor(named: "Invalid")

                }
                
                dateLabel.stringValue = "Date: " + (signedMessage.uiDateString() ?? "")
                textView.string = signedMessage.originalMessage ?? ""
                
                return true
                
              } catch {
                   print("Could not read file")
              }
        }
        
        return false
    }


}

