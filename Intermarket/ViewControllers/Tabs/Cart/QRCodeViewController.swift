//
//  QRCodeViewController.swift
//  Intermarket
//
//  Created by Rodrigo Torres on 09/09/2021.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {

    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var qrLabel: UILabel!
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    let captureSession = AVCaptureSession()
    var isNavigationController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkPermissionCamera()
    }
    
    @IBAction func backButton(_ sender: Any) {
        backButtonAction()
    }
    
    private func backButtonAction() {
        if !isNavigationController {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    //Initial configuation
    func setConfiguration() {
        guard let captureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            //Set Input device on the capture session
            let captureMetadataInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureMetadataInput)
            
            //Initialize a AVCaptureMetadataOutput object and set it as te output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the vide preview layer and add it as a sublayer to the  viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = qrView.layer.bounds
            qrView.layer.addSublayer(videoPreviewLayer)
            
            // Start video capture
            captureSession.startRunning()
            
            
        } catch {
            print("Error")
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrView.frame = CGRect.zero
            qrLabel.text = "Codigo QR no encontrado"
        }
        
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj)
            qrView.frame = barCodeObject!.bounds
            qrLabel.text = "Producto encontrado"
            self.alertProductFounded()
                        
            if metadataObj.stringValue != nil {
                print("Worked")
            }
        }
        
        self.captureSession.stopRunning()
    }
    
    func alertProductFounded() {
        let alert = UIAlertController(title: "Producto encontrado", message: "¿Que deseas hacer?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { action in
            self.goToCart()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { action in
            self.qrLabel.text = "Escanéa el QR de un producto"
            self.captureSession.startRunning()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Check Permission Camera
    func checkPermissionCamera() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] (granted) in
                if granted {
                    print("Access Granted")
                    DispatchQueue.main.async { [weak self] in
                        self?.setConfiguration()
                    }
                }
                else {
                    print("Access Denied")
                    DispatchQueue.main.async { [weak self] in
                        self?.showAlertPermissionCamera()
                    }
                }
            }
        case .authorized:
            print("Access authorized")
            setConfiguration()
        case .denied, .restricted:
            print("Restricted")
            showAlertPermissionCamera()
        @unknown default:
            fatalError()
        }
    }
    
    func showAlertPermissionCamera() {
        let alert = UIAlertController(title: "Camera", message: "Intermarket necesita acceso a la camara para escanear el codigo QR", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Configuración", style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl) { (_) in
                }
            }
        }
        alert.addAction(settingsAction)
        present(alert, animated: true)
    }
    
    private func goToCart() {
        let storyboard = UIStoryboard(name: Identifier.TabBarStoryboard, bundle: nil)
        let tabBar = storyboard.instantiateViewController(identifier: Identifier.TabBarController) as! MainTabViewController
        tabBar.selectedIndex = 2
        self.view.window?.rootViewController = tabBar
        self.view.window?.makeKeyAndVisible()
    }
    
}
