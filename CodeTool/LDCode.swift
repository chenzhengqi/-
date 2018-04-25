//
//  LDCode.swift
//  扫描二维码、条形码
//
//  Created by LD on 2018/4/25.
//  Copyright © 2018年 LD. All rights reserved.
//

import UIKit
import AVFoundation
class LDCode: UIViewController,AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate {
    
    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var line = UIImageView()
    typealias returnDataBlock = (String)->Void
    var returnData : returnDataBlock!
    private var zhs_timer : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubNavigtionBarView()
        
        do{
            self.device = AVCaptureDevice.default(for: AVMediaType.video)
            self.input = try AVCaptureDeviceInput(device: device)
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSession.Preset.vga640x480
            }else{
                self.session.sessionPreset = AVCaptureSession.Preset.high
            }
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            self.output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128]
            //计算中间可探测区域
            let windowSize = UIScreen.main.bounds.size
            let scanSize = CGSize(width:windowSize.width*3/4, height:windowSize.width*3/4)
            var scanRect = CGRect(x:(windowSize.width-scanSize.width)/2,
                                  y:(windowSize.height-scanSize.height)/2,
                                  width:scanSize.width, height:scanSize.height)
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x:scanRect.origin.y/windowSize.height,
                              y:scanRect.origin.x/windowSize.width,
                              width:scanRect.size.height/windowSize.height,
                              height:scanRect.size.width/windowSize.width);
            //设置可探测区域
            self.output.rectOfInterest = scanRect
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.preview.frame = self.view.bounds
            self.view.layer.insertSublayer(self.preview, at:0)
            //添加中间的探测区域绿框
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRect(x:0, y:0, width:scanSize.width,height:scanSize.height);
            self.scanRectView.center = CGPoint( x:UIScreen.main.bounds.midX,y:UIScreen.main.bounds.midY)
            self.scanRectView.layer.borderColor = UIColor.green.cgColor
            self.scanRectView.layer.borderWidth = 1
            //开始捕获
            self.session.startRunning()
        }catch _ {
            self.view.backgroundColor = .black
            //打印错误消息
            let alertController = UIAlertController(title: "提醒",message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        self.line.image = UIImage.init(named: "codeline")
        self.view.addSubview(line)
        self.openTimer()
        self.timerRuning ()
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: 0, width: KWidth, height: scanRectView.Y)
        topView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.view.layer.addSublayer(topView.layer)
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: scanRectView.Y, width: KWidth/8, height:KHeight - scanRectView.Y)
        leftView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.view.layer.addSublayer(leftView.layer)
        
        let rightView = UIView()
        rightView.frame = CGRect(x: KWidth*7/8, y: scanRectView.Y, width: KWidth/8, height:KHeight - scanRectView.Y)
        rightView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.view.layer.addSublayer(rightView.layer)
        
        let bottonView = UIView()
        bottonView.frame = CGRect(x: KWidth/8, y: scanRectView.MaxY, width: scanRectView.Width, height:KHeight - scanRectView.MaxY)
        bottonView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.view.layer.addSublayer(bottonView.layer)
        
        let label = UILabel()
        label.frame = CGRect(x: KWidth/8, y: scanRectView.MaxY, width: scanRectView.Width, height:50)
        label.text = "请将车位锁二维码放入框内、即可自助扫描"
        label.textColor = UIColor.white
        label.font = SFont(25)
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        let right:UIButton = UIButton(type:.custom)
        right.frame = CGRect(x:label.X, y:label.MaxY + H(20), width:label.Width, height:H(40))
        right.setTitle("打开手电筒", for: .normal)
        right.setTitle("关闭手电筒", for: .selected)
        right.titleLabel?.font = SFont(25)
        right.addTarget(self, action: #selector(rightClick(_ :)), for: .touchUpInside)
        self.view.addSubview(right)
    }
    
    @objc func rightClick(_ but:UIButton)  {
        but.isSelected = !but.isSelected
        self.openTorch()
    }
    
    
    //摄像头捕获
    func metadataOutput(_ output: AVCaptureMetadataOutput,didOutput metadataObjects: [AVMetadataObject],from connection: AVCaptureConnection) {
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            print(metadataObjects)
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        //输出结果
        let alertController = UIAlertController(title: "扫描结果", message: stringValue,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            self.session.startRunning()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    /** 开启定时器*/
    private func openTimer()  {
        
        self.zhs_timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerRuning), userInfo: nil, repeats: true)
    }
    /** 定时器跑起来*/
    @objc private func timerRuning () {
        
        print(self.scanRectView.X+H(5))
        print(self.scanRectView.Y)
        print(self.scanRectView.Width)
        print((self.scanRectView.Width)/960*36)
        line.frame = CGRect(x: self.scanRectView.X+H(5), y: self.scanRectView.Y, width: self.scanRectView.Width, height: (self.scanRectView.Width)/960*36)
        
        UIView.animate(withDuration: 3) {
            self.line.frame = CGRect(x: self.scanRectView.X, y: self.scanRectView.MaxY-H(5), width: self.scanRectView.Width, height: 4)
        }
    }
    
    //初始化导航栏按钮
    func setSubNavigtionBarView()  {
        self.navigationItem.title="车位锁扫描"
    }
    
    func openTorch(){
        
        guard AVCaptureDevice.default(for: .video) != nil else{
            return
        }
        if device.hasFlash && device.isTorchAvailable {
            try? device.lockForConfiguration()
            device.torchMode = device.torchMode == .off ? .on : .off
            device.unlockForConfiguration()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
