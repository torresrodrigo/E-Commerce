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
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    var isNavigationController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermission()
    }
    
    @IBAction func backButton(_ sender: Any) {
        backButtonAction()
    }
    
    private func backButtonAction() {
        if isNavigationController == false {
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
            print("Camera device not founded")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("Error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        video.frame = qrView.layer.bounds
        qrView.layer.addSublayer(video)
        session.startRunning()
    }
    
    func requestPermission() {
        let auth = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch(auth) {
        case .denied, .notDetermined, .restricted:
            showAlert()
        case .authorized:
            proceedWithCameraAccess()
        }
    }
    
    //Permision to camera access
    func proceedWithCameraAccess(){
        AVCaptureDevice.requestAccess(for: .video) { success in
          if success {
            DispatchQueue.main.async {
                self.setConfiguration()
            }
          }
        }
      }
    
    func showAlert() {
        let alert = UIAlertController(title: "Camera", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        self.present(alert, animated: true)
    }
    
    //Executed camera
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrView.frame = CGRect.zero
            qrLabel.text = "Escanéa el QR de un producto"
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            guard let barCodeObject = video.transformedMetadataObject(for: metadataObj) else {return }
            qrView.frame = barCodeObject.bounds
            qrLabel.text = "Producto entrado"
            
            let alert = UIAlertController(title: "Producto encontrado", message: "¿Que deseas hacer?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { action in
                self.goToCart()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { action in
                self.qrLabel.text = "Escanéa el QR de un producto"
                self.session.startRunning()
            }))
            self.present(alert, animated: true, completion: nil)
            
            if metadataObj.stringValue != nil {
                print("worked")
            }
        }
        
        self.session.stopRunning()
        
    }
    
    private func goToCart() {
        let storyboard = UIStoryboard(name: Identifier.TabBarStoryboard, bundle: nil)
        let tabBar = storyboard.instantiateViewController(identifier: Identifier.TabBarController) as! MainTabViewController
        tabBar.selectedIndex = 2
        self.view.window?.rootViewController = tabBar
        self.view.window?.makeKeyAndVisible()
    }
    
}
