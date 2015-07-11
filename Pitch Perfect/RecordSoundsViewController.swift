//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by James Tench on 6/20/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var recordingIsPaused:Bool = false
    var restartingAudio:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // moved audio initialization here since record function
        // is also used to resume audio playback
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var recordingName = "my_audio.wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "recording"
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        restartButton.hidden = false
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        // no longer paused, reset the flag
        if recordingIsPaused {
            recordingIsPaused = false
        }
        // reset the restarting audio flag if it was set
        if restartingAudio {
            restartingAudio = false
        }
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        if !recordingIsPaused {
            pauseRecording()
            // toggle state for pause
            recordingIsPaused = !recordingIsPaused
        }
    }
    
    @IBAction func resetAudio(sender: UIButton) {
        var audioSession = AVAudioSession.sharedInstance()
        restartingAudio = true
        audioRecorder.stop()
        recordingInProgress.text = "tap to re-record"
        recordButton.enabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        stopButton.enabled = true
        pauseButton.hidden = true
        pauseButton.enabled = true
        restartButton.hidden = true
        restartButton.enabled = true
        recordButton.enabled = true
        recordingInProgress.text = "tap to record"
    }
    
    func pauseRecording() {
        var audioSession = AVAudioSession.sharedInstance()
        audioRecorder.pause()
        recordingInProgress.text = "paused - tap to resume"
        recordButton.enabled = true
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        stopButton.hidden = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsViewController:PlaySoundsViewController = segue.destinationViewController as!
                PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsViewController.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // if recording was stopped based on the reset flag, just return
        if restartingAudio {
            return
        }
        
        if(flag) {
            // Save recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            // perform segue to the next scene
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
}

