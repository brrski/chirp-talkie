//
//  SwiftUIView.swift
//  chirp
//
//  Created by Solomon Poku on 2023-04-28.
//

import SwiftUI
import UIKit
import AVFoundation

struct SwiftUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<SwiftUIView>) -> UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<SwiftUIView>) {
        // do nothing
    }
    
    class ViewController: UIViewController {
        var audioRecorder = try? AVAudioRecorder(url: URL(fileURLWithPath: "/dev/null"), settings: <#[String : Any]#>)
        let audioSession = AVAudioSession.sharedInstance()

        override func viewDidLoad() {
            super.viewDidLoad()
            setupAudioSession()
            setupButton()
        }

        func setupAudioSession() {
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                audioSession.requestRecordPermission { (granted) in
                    if !granted {
                        print("Microphone permission not granted")
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }

        func setupButton() {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            view.addSubview(button)
        }

        @objc func buttonPressed(sender: UIButton) {
            if audioRecorder?.isRecording == true {
                audioRecorder?.stop()
            } else {
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                do {
                    try audioSession.setActive(true)
                    audioRecorder = try AVAudioRecorder(url: URL(fileURLWithPath: "/dev/null"), settings: settings)
                    audioRecorder?.record()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }

    }
}
