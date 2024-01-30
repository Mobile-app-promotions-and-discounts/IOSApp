import Combine
import Foundation

final class RecoveryStartViewModel: RecoveryStartViewModelProtocol {
    
    private(set) var dataTextFields: [DataTextField] = []
    private(set) var timeLeft: CurrentValueSubject<Int,Never>
    private(set) var isTimerEnded: PassthroughSubject<Bool, Never>
    private let textFieldsCount = 4
    
    var code: AnyPublisher<String, Never> {
        let textPublishers = dataTextFields.map { $0.text }
        
        return Publishers.CombineLatest4(textPublishers[0],
                                         textPublishers[1],
                                         textPublishers[2],
                                         textPublishers[3])
        
        .map { text1, text2, text3, text4 in
            return text1 + text2 + text3 + text4
        }
        .eraseToAnyPublisher()
    }
    
    var isCodeDone: AnyPublisher<Bool, Never> {
        let textPublishers = dataTextFields.map { $0.text }
        
        return Publishers.CombineLatest4(textPublishers[0],
                                         textPublishers[1],
                                         textPublishers[2],
                                         textPublishers[3])
        
        .map { text1, text2, text3, text4 in
            return !text1.isEmpty && !text2.isEmpty && !text3.isEmpty && !text4.isEmpty
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        self.timeLeft = CurrentValueSubject(0)
        self.isTimerEnded = PassthroughSubject<Bool, Never>()
        startTextFields()
        startTimer()
    }
    
    private func startTimer() {
        self.timeLeft.send(60)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let newTime = self.timeLeft.value - 1
            self.timeLeft.send(newTime)
            if self.timeLeft.value == 0 {
                timer.invalidate()
                self.isTimerEnded.send(true)
            }
        }
    }
    
    func sendCode() {
        self.isTimerEnded.send(false)
        startTimer()
    }
    
    func changeTextField(id: Int, text: String) {
        dataTextFields[id].text.send(text)
        print("changeTextFiel \(id), text \(text)")
    }
    
    private func startTextFields() {
        for i in 0..<textFieldsCount {
            let dataTextField = DataTextField(id: i)
            dataTextFields.append(dataTextField)
        }
    }
    
}

struct DataTextField {
    let id: Int
    private(set) var text: CurrentValueSubject<String,Never> = CurrentValueSubject("")
}
