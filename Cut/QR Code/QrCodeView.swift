//
//  QrCodeView.swift
//  Cut
//
//  Created by Kyle McAlpine on 19/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

enum QrCodeViewMode {
    case present
    case scan
    case loading
}

class QrCodeView: UIView {
    let qrCodeContainer = UIView()
    let scannerContainer = UIView()
    let imageView = UIImageView()
    let doneButton = UIButton(type: .custom)
    private let switchModeButton = UIButton(type: .custom)
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var mode: QrCodeViewMode = .present {
        didSet {
            qrCodeContainer.alpha = 1
            scannerContainer.alpha = 1
            doneButton.alpha = 1
            switchModeButton.alpha = 1
            spinner.stopAnimating()
            switch mode {
            case .present:
                bringSubview(toFront: qrCodeContainer)
                switchModeButton.setTitle("Scan", for: .normal)
            case .scan:
                bringSubview(toFront: scannerContainer)
                switchModeButton.setTitle("Show My QR", for: .normal)
            case .loading:
                UIView.animate(withDuration: 0.3, animations: {
                    self.qrCodeContainer.alpha = 0
                    self.scannerContainer.alpha = 0
                    self.doneButton.alpha = 0
                    self.switchModeButton.alpha = 0
                })
                spinner.startAnimating()
                
            }
            bringSubview(toFront: switchModeButton)
            bringSubview(toFront: doneButton)
            
        }
    }
    
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.blue, for: .normal)
        
        switchModeButton.setTitle("Scan", for: .normal)
        switchModeButton.setTitleColor(.blue, for: .normal)
        _ = switchModeButton.rx.tap.subscribe(onNext: { _ in
            self.mode = self.mode == .scan ? .present : .scan
        })
        
        qrCodeContainer.backgroundColor = .white
        
        addSubview(spinner)
        addSubview(scannerContainer)
        addSubview(qrCodeContainer)
        qrCodeContainer.addSubview(imageView)
        addSubview(doneButton)
        addSubview(switchModeButton)
        
        switchModeButton <- [
            Top(10).to(safeAreaLayoutGuide, .top),
            Leading(20)
        ]
        
        doneButton <- [
            Top().to(switchModeButton, .top),
            Trailing(20)
        ]
        
        spinner <- Center()
        
        qrCodeContainer <- Edges()
        
        scannerContainer <- Edges()
        
        imageView <- [
            CenterX(),
            CenterY(),
            Leading(30),
            Height().like(imageView, .width)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
