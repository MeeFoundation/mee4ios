//
//  VoiceRecognition.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 23.11.23..
//

import Speech

struct VoiceRecognitionError: Error {}

class VoiceRecognition: ObservableObject {
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = nil
    private var request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask? = nil
    @Published var isRecording: Bool = false
    @Published var text: String = ""
    private var timer: Timer?
    
    private func restartSpeechTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.stopRecording()
        })
    }
    
    private func startRecording() throws {
        isRecording = true
        request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print(error)
            throw VoiceRecognitionError()
        }
        guard let speechRecognizer = SFSpeechRecognizer() else { throw VoiceRecognitionError() }
        if !speechRecognizer.isAvailable { throw VoiceRecognitionError() }
        recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                self.text = result.bestTranscription.formattedString
                self.restartSpeechTimer()
            } else if let error = error {
                print(error)
            }
        }
    }
    
    private func stopRecording() {
        request.endAudio()
        audioEngine.stop()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        recognitionTask?.finish()
        isRecording = false
    }
    
    func requestSpeech() {
        if (isRecording) {
            stopRecording()
        } else {
            do {
                try startRecording()
            } catch {
                isRecording = false
            }
            
        }
    }
}
