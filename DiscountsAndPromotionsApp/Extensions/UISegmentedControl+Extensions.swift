import Combine
import UIKit

struct SegmentedControlPublisher: Publisher {
    typealias Output = Int
    typealias Failure = Never

    let control: UISegmentedControl
    let event: UIControl.Event

    init(control: UISegmentedControl, event: UIControl.Event = .valueChanged) {
        self.control = control
        self.event = event
    }

    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
        let subscription = SegmentedControlSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }

    private final class SegmentedControlSubscription<S: Subscriber>: Subscription where S.Input == Int, S.Failure == Never {
        private var subscriber: S?
        private let control: UISegmentedControl
        private let event: UIControl.Event

        init(subscriber: S, control: UISegmentedControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            control.addTarget(self, action: #selector(handleEvent), for: event)
        }

        func request(_ demand: Subscribers.Demand) {  }

        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(handleEvent), for: event)
        }

        @objc private func handleEvent() {
            guard let subscriber = subscriber else { return }
            _ = subscriber.receive(control.selectedSegmentIndex)
        }
    }
}

extension UISegmentedControl {

    func segmentPublisher() -> AnyPublisher<Int, Never> {
        return SegmentedControlPublisher(control: self, event: .valueChanged).eraseToAnyPublisher()
    }
}
