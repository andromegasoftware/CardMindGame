//
//  SoundManager.swift
//  Card Game
//
//  Created by kadir yapar on 18.9.2021.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audiPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    func playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        //determine which sound effect we want to play
        switch effect {
            case .flip:
                soundFileName = "cardflip"
        
            case .shuffle:
                soundFileName = "shuffle"
            
            case .match:
                soundFileName = "dingcorrect"
            
            case .nomatch:
                soundFileName = "dingwrong"
        }
        
        //get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Cound not find sound file \(soundFileName) in the bundle")
            return
        }
        
        //create a URL object from this string path
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        //create audio player object
        do {
            audiPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            //play the sound
            audiPlayer?.play()
        } catch  {
            print("Could not create the audio object for sound file: \(soundFileName)")
        }
        
        
    }
    
}
