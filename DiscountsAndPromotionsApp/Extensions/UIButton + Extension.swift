import UIKit
import Combine

extension UIControl {
    struct Publisher: Combine.Publisher {
        typealias Output = UIControl
        typealias Failure = Never

        private let control: UIControl
        private let controlEvents: UIControl.Event

        init(control: UIControl, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }

        func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber, control: control, event: controlEvents)
            subscriber.receive(subscription: subscription)
        }

        private final class Subscription<S: Subscriber, Control: UIControl>: Combine.Subscription where S.Input == Control, S.Failure == Failure {
            private var subscriber: S?
            private weak var control: Control?

            init(subscriber: S, control: Control, event: UIControl.Event) {
                self.subscriber = subscriber
                self.control = control
                control.addTarget(self, action: #selector(eventHandler), for: event)
            }

            func request(_ demand: Subscribers.Demand) {
                // We do not need to handle the demand
            }

            func cancel() {
                subscriber = nil
                control?.removeTarget(self, action: #selector(eventHandler), for: .allEvents)
            }

            @objc private func eventHandler() {
                _ = subscriber?.receive(control!)
            }
        }
    }

    func publisher(for events: UIControl.Event) -> UIControl.Publisher {
        return Publisher(control: self, events: events)
    }
}
