import AVFoundation
import Combine
import Foundation

final class ScanCaptureSessionController: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var barcode: String?
    weak var coordinator: ScanFlowCoordinatorProtocol?
    private var captureSession: AVCaptureSession
    private (set) var previewLayer: AVCaptureVideoPreviewLayer

    init(coordinator: ScanFlowCoordinatorProtocol?) {
        self.coordinator = coordinator
        self.captureSession = AVCaptureSession()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    }

    func startSessionRoutine() {
        if captureSession.isRunning == false {
            let background = DispatchQueue(label: "capture_session_queue")
            background.async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }

    func stopSessionRoutine() {
        flashOff()
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
        } else {
            failed()
            return
        }

        let background = DispatchQueue(label: "capture_session_queue")
        background.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    private func failed() {
        coordinator?.scanError()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            flashOff()
            barcode = stringValue
//            viewModel.checkBarcode(code: stringValue)
        }
    }

    private func flashOff() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if device.torchMode == AVCaptureDevice.TorchMode.on {
                device.torchMode = AVCaptureDevice.TorchMode.off
//                flashButton.isSelected = false
            }

            device.unlockForConfiguration()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
