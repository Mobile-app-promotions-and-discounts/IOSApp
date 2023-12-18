import AVFoundation
import Combine
import Foundation

final class ScanCaptureSessionController: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var barcode: String?
    @Published var isFlashOn: Bool = false
    weak var coordinator: ScanFlowCoordinator?
    private var captureSession: AVCaptureSession
    private (set) var previewLayer: AVCaptureVideoPreviewLayer
    private let background = DispatchQueue.global()

    init(coordinator: ScanFlowCoordinator?) {
        self.coordinator = coordinator
        self.captureSession = AVCaptureSession()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    }

    func startSessionRoutine() {
        if captureSession.isRunning == false {
            background.async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }

    func pauseSessionRoutine() {
        flashOff()
    }

    func stopSessionRoutine() {
        flashOff()
        if captureSession.isRunning == true {
            background.async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
    }

    func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
            else {
//            failed()
            return
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
//            failed()
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
//            failed()
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

        background.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()

            if device.torchMode == AVCaptureDevice.TorchMode.on {
                device.torchMode = AVCaptureDevice.TorchMode.off
                isFlashOn = false
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    isFlashOn = true
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
            device.unlockForConfiguration()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    private func failed() {
        coordinator?.navigateBack()
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
        }
    }

    private func flashOff() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if device.torchMode == AVCaptureDevice.TorchMode.on {
                device.torchMode = AVCaptureDevice.TorchMode.off
            }

            device.unlockForConfiguration()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
