//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Abdalah on 3/29/19.
//  Copyright © 2019 Abdalah. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate{
    
    var audioRecorder:AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
//    func setButtons(forRecording recording: Bool) {
//        stopRecordingButton.isEnabled = recording
//        recordButton.isEnabled = !recording
//        recordingLabel.text = recording ? "Recording in progress" : "Tap to record"
//    }
    enum PlayingState {
        case playing
        case notplaying
    }
    func setButtons(_ forRecording :PlayingState){
        switch(forRecording)
        {
        case .playing:
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        case .notplaying:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
            
        }
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        setButtons(.playing)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
       setButtons(.notplaying)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
        else{
            print("recording was not successful ")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
   
}

