//
//  HerbDetailsViewController.swift
//  CustomVCPresentationTransitions
//
//  Created by Радим Гасанов on 22/05/2019.
//  Copyright © 2019 Халу. All rights reserved.
//

import UIKit

class HerbDetailsViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var bgImage = UIImageView()
    var containerView = UIView()
    var titleView = UILabel()
    var descriptionView = UITextView()
    var licenseButton = UIButton()
    var authorButton = UIButton()
    var herb: HerbModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBgImage(bgImage)
        createContainerView(containerView: containerView,
                            label: titleView,
                            textView: descriptionView,
                            licenseButton: licenseButton,
                            authorButton: authorButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bgImage.image = UIImage(named: herb.image)
        titleView.text = herb.name
        descriptionView.text = herb.description
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
    }
    
    func createContainerView(containerView: UIView, label: UILabel, textView: UITextView, licenseButton: UIButton, authorButton: UIButton) {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        //containerView
        containerView.frame = CGRect(x: 0, y: viewHeight / 2, width: viewWidth, height: viewHeight / 2)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(containerView)
        //label
        label.frame = CGRect(x: 0, y: 20, width: viewWidth, height: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36)
        containerView.addSubview(label)
        //textView
        textView.frame = CGRect(x: 0, y: 50, width: viewWidth - 50, height: 200)
        textView.center.x = containerView.center.x
        textView.textAlignment = .justified
        textView.backgroundColor = UIColor.clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        containerView.addSubview(textView)
        //licenseButton
        licenseButton.frame = CGRect(x: 10, y: containerView.bounds.height - 40,
                                     width: 150, height: 30)
        licenseButton.setTitle("Image license", for: .normal)
        licenseButton.setTitleColor(.white, for: .normal)
        licenseButton.setTitleColor(.black, for:  .highlighted)
        licenseButton.addTarget(self, action: #selector(licenseButtonTapped),
                                for: .touchUpInside)
        containerView.addSubview(licenseButton)
        //authorButton
        authorButton.frame = CGRect(x: containerView.bounds.width - 160,
                                    y: containerView.bounds.height - 40,
                                    width: 150, height: 30)
        authorButton.setTitle("Image author", for: .normal)
        authorButton.setTitleColor(.white, for: .normal)
        authorButton.setTitleColor(.black, for:  .highlighted)
        authorButton.addTarget(self, action: #selector(authorButtonTapped),
                               for: .touchUpInside)
        containerView.addSubview(authorButton)
        
    }
    
    func createBgImage(_ imageView: UIImageView) {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        view.addSubview(imageView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func actionClose(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @objc func licenseButtonTapped(){
        //UIApplication.shared.openURL(URL(string: herb!.license)!)
        let myUrl = String(herb!.license)
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @objc func authorButtonTapped(){
        //UIApplication.shared.openURL(URL(string: herb!.credit)!)
        let myUrl = String(herb!.credit)
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

