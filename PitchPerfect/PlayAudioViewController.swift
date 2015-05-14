//
//  PlayAudioViewController.swift
//  PitchPerfect
//
//  Created by yunchu on 5/12/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {
    @IBOutlet weak var reverb: UIButton!
    var slowMovie:AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var avaudioengine: AVAudioEngine!
    var audiofile: AVAudioFile!
    var audioreverb: AVAudioUnitReverb!
    override func viewDidLoad() {
        super.viewDidLoad()

        slowMovie = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        slowMovie.enableRate = true
        avaudioengine = AVAudioEngine()
        audiofile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        // Do any additional setup after loading the view.
    }
    func playAudioWithReverb () {
        slowMovie.stop()
        avaudioengine.stop()
        avaudioengine.reset()
        
        var audioPlayNode = AVAudioPlayerNode()
        avaudioengine.attachNode(audioPlayNode)
        var reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 100
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        avaudioengine.attachNode(reverb)
        avaudioengine.connect(audioPlayNode, to: reverb, format: nil)
        avaudioengine.connect(reverb, to: avaudioengine.outputNode, format: nil)
        audioPlayNode.scheduleFile(audiofile, atTime: nil, completionHandler: nil)
        avaudioengine.startAndReturnError(nil)
        audioPlayNode.play()
    }
    func playAudioWithVariablePitch (pitch: Float) {
        slowMovie.stop()
        avaudioengine.stop()
        avaudioengine.reset()
        
        var audioPlayNode = AVAudioPlayerNode()
        avaudioengine.attachNode(audioPlayNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        avaudioengine.attachNode(changePitchEffect)
        
        avaudioengine.connect(audioPlayNode, to: changePitchEffect, format: nil)
        avaudioengine.connect(changePitchEffect, to: avaudioengine.outputNode, format: nil)
        audioPlayNode.scheduleFile(audiofile, atTime: nil, completionHandler: nil)
        avaudioengine.startAndReturnError(nil)
        audioPlayNode.play()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowPlay(sender: UIButton) {
        avaudioengine.stop()
        avaudioengine.reset()
        slowMovie.currentTime = 0.0
        slowMovie.rate = 0.5
        slowMovie.play()
    }

    @IBAction func fastPlay(sender: UIButton) {
        avaudioengine.stop()
        avaudioengine.reset()
        slowMovie.currentTime = 0.0
        slowMovie.rate = 1.5
        slowMovie.play()
    }
    @IBAction func stopAudio(sender: UIButton) {
        slowMovie.stop()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func reverbAudio(sender: UIButton) {
        playAudioWithReverb()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
