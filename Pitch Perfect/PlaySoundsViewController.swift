//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by James Tench on 6/27/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        } catch {
            print(error)
        }
        
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        
        do {
           try audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch {
            print(error)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        stopButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playSoundAtRate(rate: Float32) {
        stopButton.enabled = true
        stopAllAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopButton.enabled = true
        stopAllAudio()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableReverb(wetDryMix: Float) {
        stopButton.enabled = true
        stopAllAudio()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = wetDryMix
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
        audioPlayerNode.play()
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        playSoundAtRate(1.5)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let reverbEffect:Float = 65.0 // adds some echo/reverb via wetDryMix
        playAudioWithVariableReverb(reverbEffect)
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        playSoundAtRate(0.5)
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopSoundPlayback(sender: UIButton) {
        stopAllAudio()
        stopButton.enabled = false
    }
}
