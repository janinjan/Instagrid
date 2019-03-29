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
    private var tag: Int?
    
    // MARK: - Actions
    /**
     * Changing layout style at layout buttons selection
     */
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
        mainView.layoutStyle = .layout2 // start with layout 2 selected
        tapGesturesRecognizer()
        swipeGestureDirectionRecognizer()
        longPressGestureRecognizer()
    }
    
    /**
     * Get image from Photo Library
     */
    private func pickAnImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
    /**
     * Grid returns to his initial position
     */
    private func swipeLayoutSetToIdentity() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainView.transform = .identity
        })
    }
    
    /**
     * Share created grid
     */
    private func handleShare() {
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
    
    /**
     * Displays an alert message if grid is incomplete before sharing
     */
    private func alertGridIsIncomplete() {
        let alert = UIAlertController(title: "Missing picture(s)", message: "You may add picture(s) in the grid before sharing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Gestures
    private func tapGesturesRecognizer() {
        mainView.picturesCollectionImageView.forEach( { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(picturesCollectionImageViewTapped(gesture:)))) })
    }
    
    @objc private func picturesCollectionImageViewTapped(gesture: UIGestureRecognizer) {
        tag = gesture.view?.tag
        pickAnImage()
    }
    
    private func swipeGestureDirectionRecognizer() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .left]
        for direction in directions {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(mainViewSwiped(gesture:)))
            mainView.addGestureRecognizer(swipeGesture)
            swipeGesture.direction = direction
            mainView.isUserInteractionEnabled = true
        }
    }
    
    /**
     * Swipe up or left according to device orientation to share image if grid is complete
     */
    @objc private func mainViewSwiped(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if gesture.direction == .up && UIDevice.current.orientation.isPortrait {
                self.mainView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                print("swipe up")
                if self.mainView.missingPictureInGrid() {
                    self.alertGridIsIncomplete()
                    self.swipeLayoutSetToIdentity()
                } else {
                    self.handleShare()
                }
            } else if gesture.direction == .left  && UIDevice.current.orientation.isLandscape {
                self.mainView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                print("swipe left")
                if self.mainView.missingPictureInGrid() {
                    self.alertGridIsIncomplete()
                    self.swipeLayoutSetToIdentity()
                } else {
                    self.handleShare()
                }
            }
        }
    }
    
    private func longPressGestureRecognizer() {
        mainView.picturesCollectionImageView.forEach( { $0.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))) })
    }
    
    /**
     * Allow to delete picture by long press gesture on it
     */
    @objc private func longPressed(gesture: UILongPressGestureRecognizer) {
        tag = gesture.view?.tag
        guard let tag = tag else { return }
        if gesture.state == .ended { return }
        let title = "Delete Image?"
        let message = "Are you sure you want to delete this image?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.mainView.picturesCollectionImageView[tag].image = nil // delete image
            self.mainView.picturesButton[tag].isHidden = false // show picture selection button
        })
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let tag = tag else { return }
            mainView.picturesCollectionImageView[tag].image = image
            mainView.picturesButton[tag].isHidden = true // hide picture selection button after picking
        }
        dismiss(animated: true, completion: nil)
    }
}
