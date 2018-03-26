//
//  ImageCaptureViewController.swift
//  FDA
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.


import UIKit
import AVFoundation

class ImageCaptureViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate
{
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    @IBOutlet weak var cameraView : UIView!
    var captureMetadataOutput : AVCaptureVideoDataOutput!
    var stillImageOutput : AVCaptureStillImageOutput!
    var sampleBufferStored: CMSampleBuffer!
    var isRightOriented : Bool = false
    var isPicTaken = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ImageCaptureViewController.orientationChanged(note:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        isPicTaken = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isPicTaken = true
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func orientationChanged(note : NSNotification)  {
        let currentOrientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation;
        
        if UIDevice.current.model.contains("Phone") || UIDevice.current.model.contains("phone"){
            
        }
        if currentOrientation == .portrait{
            videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
        }
        else{
            videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
        }
    }

 
    
    func setupCamera(){
        if !Platform.isSimulator {
            let captureDevice = frontCamera()
            do {
                let input : AnyObject! = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                
                captureSession?.addInput(input as! AVCaptureInput)
                
            }
            catch{
                print("TakeASelfieVC error: \(error)")
                return
            }
            captureMetadataOutput = AVCaptureVideoDataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            let queue = DispatchQueue(label: "myQueue")
            
            
            
            captureMetadataOutput.setSampleBufferDelegate(self, queue: queue)
            captureMetadataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable : NSNumber(value: Int32(kCVPixelFormatType_32BGRA))]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
            videoPreviewLayer?.frame = cameraView.layer.bounds
            videoPreviewLayer?.frame = self.view.bounds
            
            let currentOrientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation;
            
            if UIDevice.current.model.contains("Phone") || UIDevice.current.model.contains("phone"){
                
            }
            if currentOrientation == .portrait{
                videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
            }
            else{
                videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
            }
            videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
            cameraView.layer.addSublayer(videoPreviewLayer!)
            stillImageOutput = AVCaptureStillImageOutput()
            captureSession?.addOutput(stillImageOutput)
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            
            captureSession?.startRunning()
        }
    }
    func frontCamera() -> AVCaptureDevice{
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices!{
            if (device as! AVCaptureDevice).position == AVCaptureDevicePosition.back{
                return device as! AVCaptureDevice
            }
        }
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    }

    
    @IBAction func cameraOkBtnPressed(sender : UIButton){
        if !Platform.isSimulator {
            
            var img : UIImage = UIImage.image1(from: sampleBufferStored)
            let currentOrientation : UIInterfaceOrientation = UIApplication.shared.statusBarOrientation;
            if currentOrientation == .landscapeLeft{
                img = img.imageRotated(byDegrees: 0, mirror: false)
            }
            else{
                img = img.imageRotated(byDegrees: M_PI, mirror: false)
                
            }
            //let data = UIImageJPEGRepresentation(img, 0.2)
            
        }
        
        sender.isSelected = true
        
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!){
        sampleBufferStored = sampleBuffer
    }
    
    @IBAction func openMenu(_ sender: UIButton)
    {
       CommanMethods.openSideMenu(navigationController: navigationController!)
    }

}
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
