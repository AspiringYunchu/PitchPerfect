//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by yunchu on 5/12/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordInProgress: UILabel!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        
        //TODO:Record the user's voice
        recordInProgress.hidden = false
        recordInProgress.text = "recording..."
        stop.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        //Setup audio session
        var session = AVAudioSession.sharedInstance();
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil , error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundVC: PlayAudioViewController = segue.destinationViewController as! PlayAudioViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //TODO1: save recorded audio
        if(flag){
            recordedAudio = RecordedAudio(title:recorder.url.lastPathComponent! , filePathUrl:recorder.url)
            
            //TODO2: transition to next view
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
   
        } else {
            println("Error")
            recordButton.enabled = true
            stop.hidden = true
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
        
        recordInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    @IBAction func pauseButton(sender: UIButton) {
        if(pauseButton.selected){
            recordInProgress.hidden = false
            recordInProgress.text = "recording..."
            pauseButton.selected = false
            audioRecorder.record()
        } else {
            recordInProgress.hidden = false
            recordInProgress.text = "Continue to Record"
            pauseButton.selected = true
            audioRecorder.pause()
            
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        stop.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        pauseButton.selected = false
        recordInProgress.text = "Tap to Record"
        recordInProgress.hidden = false
    }
}

