//
//  VoicerViewController.swift
//  JWBestPracticeApps
//
//  Created by JWP Admin on 9/21/16.
//  Copyright © 2016 Karim Mourra. All rights reserved.
//

import UIKit
import Intents

class VoicerViewController: JWRemoteCastPlayerViewController {

    let userDefaults = UserDefaults.init(suiteName: "group.com.jwplayer.wormhole")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        INPreferences.requestSiriAuthorization { (authorizationStatus) in
            print("Authorized \(authorizationStatus)")
        }
    }

    public func handle(command: String, quantity: UInt?) {
        if command.lowercased() == "play" {
            print("playing")
            self.player.play()
        } else if command.lowercased() == "pause" {
            print("pausing")
            self.player.pause()
        } else if command.lowercased() == "seeking" {
            self.player.seek(quantity!)
        } else if command.lowercased() == "casting" {
            self.castController.disconnect()
        } else {
            let castingDevice = self.castingDeviceFrom(name: command)
            self.castController.connect(to: castingDevice)
        }
    }
    
    func castingDeviceFrom(name: String) -> JWCastingDevice? {
//        let castingDevices = self.userDefaults?.value(forKey: "castingDevices") as! [String]
        for device in self.castController.availableDevices {
            let castDevice = device as! JWCastingDevice
            if castDevice.name == name {
                return castDevice
            }
        }
        return nil
    }
    
    override func onCastingDevicesAvailable(_ devices: [JWCastingDevice]!) {
        print("onCastingDevicesAvailable")
        super.onCastingDevicesAvailable(devices)
        self.prepareCastingDevices()
    }
    
    func prepareCastingDevices() {
        var castingDevices = [String]()
        for device in self.castController.availableDevices {
            castingDevices.append((device as! JWCastingDevice).name)
        }
        /*
        let vocabulary = INVocabulary.shared()
        let orderedDevices = NSOrderedSet(array: castingDevices)
        vocabulary.setVocabularyStrings(orderedDevices, of: INVocabularyStringType.workoutActivityName)
        */
        print("\(castingDevices)")
        if castingDevices.count > 0 {
            self.userDefaults?.set(castingDevices, forKey: "castingDevices")
            self.userDefaults?.synchronize()
        }
    }
    
    override func onConnected(to device: JWCastingDevice!) {
        super.onConnected(to: device)
    }
    
    override func onCasting() {
        super.onCasting()
    }
    
    override func onCastingEnded(_ error: Error!) {
        super.onCastingEnded(error)
    }
    
    override func onCastingFailed(_ error: Error!) {
        super.onCastingFailed(error)
    }
    
    override func onDisconnected(fromCastingDevice error: Error!) {
        super.onDisconnected(fromCastingDevice: error)
        
    }
}
