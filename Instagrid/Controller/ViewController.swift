//
//  ViewController.swift
//  Instagrid
//
//  Created by FrancoisDev on 24/04/2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var arrowImageView: UIImageView! 
    @IBOutlet weak var swipeLabel: UILabel!
    
    // Views of the gridView
    @IBOutlet weak var gridView: UIView!
    @IBOutlet var gridViewImageViews: [UIImageView]!
    @IBOutlet var gridViewButtons: [UIButton]!
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var bottomLeftView: UIView!
    
    // Views of the layoutView
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet var selectLayoutImageViews: [UIImageView]!
    
    // MARK: - Properties
    
    private var imagePicker = UIImagePickerController()
    private var selectedButton: UIButton?
    private var selectedImageView: UIImageView?
    private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    private let portraitTransform = CGAffineTransform(rotationAngle: 0)  // 0 degrees
    private let landscapeTransform = CGAffineTransform(rotationAngle: .pi * 1.5)  // 270 degrees
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Actions
    
    @IBAction func imageViewHasBeenTapped(_ sender: UIButton) {
        selectedImageView = gridViewImageViews[sender.tag]
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func layoutButtonHasBeenTapped(_ sender: UIButton) {
        let selectedButtonTag = sender.tag
        
        // Update selected layout image view
        selectLayoutImageViews.forEach {
            $0.isHidden = true
        }
        
        selectLayoutImageViews[selectedButtonTag].isHidden = false
        
        // Update grid layout
        switch selectedButtonTag {
        case 0:
            topLeftView.isHidden = true
            bottomLeftView.isHidden = false
        case 1:
            topLeftView.isHidden = false
            bottomLeftView.isHidden = true
        case 2:
            topLeftView.isHidden = false
            bottomLeftView.isHidden = false
        default: break
        }
    }
}

// MARK: - Common Methods

extension ViewController {
    
    private func setUpViews() {
        // Configuring the imagePicker ** Configuration de l'imagePicker
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        // configuration for imageView to adjust the images to their size
        for imageView in gridViewImageViews {
            imageView.contentMode = .scaleAspectFill
        }
        
        // Set title to empty for all the buttons
        [gridViewButtons, layoutButtons].forEach { buttons in
            for button in buttons {
                button.setTitle("", for: .normal)
            }
        }
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // rotate the image of the arrow according to the oriantation
    
    @objc func orientationChanged() {
        let orientation = UIDevice.current.orientation
        let isLandscape = orientation.isLandscape
        
        if isLandscape {
            swipeLabel.text = "Swipe left to share"
            swipeGestureRecognizer.direction = .left
        } else {
            swipeLabel.text = "Swipe up to share"
            swipeGestureRecognizer.direction = .up
        }
        
        if orientation.isLandscape {
            arrowImageView.transform = landscapeTransform
        } else {
            arrowImageView.transform = portraitTransform
        }
    }
}

// MARK: - Convenience Methods

extension ViewController {
    
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        // Captures the image from the imagesContainerView
        let renderer = UIGraphicsImageRenderer(size: gridView.bounds.size)
        let image = renderer.image { ctx in gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        }
        
        // Create an activity controller to share the image
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // Gets the current orientation of the device
        let orientation = UIDevice.current.orientation
        let isLandscape = orientation.isLandscape
        
        // Saves the original position of the view
        let originalPosition = gridView.center
        
        // Set translation to remove the view from the screen
        let offScreenTransform: CGAffineTransform = isLandscape ?
        CGAffineTransform(translationX: -view.bounds.width, y: 0) :
        CGAffineTransform(translationX: 0, y: -view.bounds.height)
        
        // Animating the view to slide off the screen
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = offScreenTransform
        }) { (completed) in
            
            // Presence of UIActivityViewController after the end of the animation
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            
            // Animation of the view so that it returns to its original position
            UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = .identity
                self.gridView.center = originalPosition
            })
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView?.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
