//
//  ViewController.swift
//  CustomVCPresentationTransitions
//
//  Created by Радим Гасанов on 22/05/2019.
//  Copyright © 2019 Халу. All rights reserved.
//
import UIKit

let herbs = HerbModel.all()

class ViewController: UIViewController {
    
    var listView = UIScrollView()
    var bgImage = UIImageView()
    var selectedImage = UIImageView()
    let transition = PopAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createBgImage(bgImage)
        createListView(listView)
        transition.dismissCompletion = {
            self.selectedImage.isHidden = false
        }
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createBgImage(_ imageView: UIImageView) {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        imageView.image = UIImage(named: "bg")
        imageView.alpha = 0.8
        view.addSubview(imageView)
    }
    func createListView(_ scrollView: UIScrollView) {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        scrollView.frame = CGRect(x: 10, y: viewHeight * 0.60 , width: viewWidth, height: viewHeight * 0.39)
        scrollView.contentMode = .scaleToFill
        view.addSubview(scrollView)
        if listView.subviews.count < herbs.count {
            listView.viewWithTag(0)?.tag = 1000 //prevent confusion when looking up images
            setupList()
        }
    }
    func setupList() {
        for i in herbs.indices {
            //create image view
            let imageView  = UIImageView(image: UIImage(named: herbs[i].image))
            imageView.tag = i
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 20.0
            imageView.layer.masksToBounds = true
            print("\(herbs[i].image) - \(imageView.frame)")
            listView.addSubview(imageView)
            //attach tap detector
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        }
        listView.backgroundColor = UIColor.clear
        positionListItems()
    }
    //position all images inside the list
    func positionListItems() {
        let listHeight = listView.frame.height
        let itemHeight: CGFloat = listHeight * 1.33
        let aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let itemWidth: CGFloat = itemHeight / aspectRatio
        let horizontalPadding: CGFloat = 10.0
        
        for i in herbs.indices {
            let imageView = listView.viewWithTag(i) as! UIImageView
            imageView.frame = CGRect(
                x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding, y: 0.0,
                width: itemWidth, height: itemHeight)
        }
        listView.contentSize = CGSize(
            width: CGFloat(herbs.count) * (itemWidth + horizontalPadding) + horizontalPadding,
            height:  0)
    }
    //MARK: Actions
    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        selectedImage = (tap.view as? UIImageView)!
        let index = tap.view!.tag
        let selectedHerb = herbs[index]
        let herbDetails = HerbDetailsViewController()
        herbDetails.herb = selectedHerb
        herbDetails.transitioningDelegate = self
        present(herbDetails, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.bgImage.alpha = (size.width>size.height) ? 0.25 : 0.55
            self.positionListItems()
        }, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = (selectedImage.superview?.convert(selectedImage.frame, to: nil))!
        transition.presenting = true
        selectedImage.isHidden = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
