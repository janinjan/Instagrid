//
//  ViewController.swift
//  Instagrid
//
//  Created by Janin Culhaoglu on 06/03/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var mainView: LayoutView!
    @IBOutlet weak var swipeLayout: UIStackView!
    @IBOutlet var layoutsButton: [UIButton]!
    
    // MARK: - Properties
    private var swipeGesture = UISwipeGestureRecognizer()
    var tag: Int?
    
    // MARK: - Actions
    @IBAction func layoutButtonsTapped(_ sender: UIButton) {
        layoutsButton.forEach({ $0.isSelected = false })
        sender.isSelected = true
        switch sender.tag {
        case 0:
            mainView.layoutStyle = .layout1
        case 1:
            mainView.layoutStyle = .layout2
        case 2:
            mainView.layoutStyle = .layout3
        default:
            break
        }
    }
    
    @IBAction func picturesButtonsTapped(_ sender: UIButton) {
        tag = sender.tag
        pickAnImage()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layoutStyle = .layout2
        tapGesturesRecognizer()
        swipeGestureDirectionRecognizer()
    }
    
    private func pickAnImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func swipeLayoutSetToIdentity() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainView.transform = .identity
        })
    }
    
    func handleShare() {
        UIGraphicsBeginImageContextWithOptions(mainView.frame.size, mainView.isOpaque, 0.0)
        mainView.drawHierarchy(in: mainView.bounds, afterScreenUpdates: true)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        mainView.layer.render(in: context)
        guard let imageToShare = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, success: Bool, returnedItems: [Any]?, error: Error?) in
            if success || !success {
                self.swipeLayoutSetToIdentity()
            }
        }
    }
    
    // MARK: - Gestures
    func tapGesturesRecognizer() {
        mainView.picturesCollectionImageView.forEach( { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(picturesCollectionImageViewTapped(gesture:)))) })
    }
    
    @objc func picturesCollectionImageViewTapped(gesture: UIGestureRecognizer) {
        tag = gesture.view?.tag
        pickAnImage()
    }
    
    func swipeGestureDirectionRecognizer() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .left]
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewSwiped(gesture:)))
            mainView.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            mainView.isUserInteractionEnabled = true
        }
    }
    
    @objc func mainViewSwiped(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if gesture.direction == .up && UIDevice.current.orientation.isPortrait {
                self.mainView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                print("swipe up")
                self.handleShare()
            } else if gesture.direction == .left && UIDevice.current.orientation.isLandscape {
                self.mainView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                print("swipe left")
                self.handleShare()
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let tag = tag else { return }
            mainView.picturesCollectionImageView[tag].image = image
            mainView.picturesButton[tag].isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
}
