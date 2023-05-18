//
//  ViewController.swift
//  Instagrid
//
//  Created by FrancoisDev on 24/04/2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var selectedButton: UIButton?
    var selectedImageView: UIImageView?
    var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    // How to open photo gallery iPhone swift UIImagePickerController
    // let pickerController = UIImagePickerController()
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var bottomLeftView: UIView!
    
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var select1: UIImageView!
    @IBOutlet weak var select2: UIImageView!
    @IBOutlet weak var select3: UIImageView!
    
    @IBOutlet weak var imagesContainerView: UIView!
    
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    
    @IBOutlet weak var plusTopLeft: UIImageView!
    @IBOutlet weak var plusTopRight: UIImageView!
    @IBOutlet weak var plusBottomLeft: UIImageView!
    @IBOutlet weak var plusBottomRight: UIImageView!
    
   // private var currentRadians: CGFloat = 0.0
    let portraitTransform = CGAffineTransform(rotationAngle: 0)  // 0 degrees
    let landscapeTransform = CGAffineTransform(rotationAngle: .pi * 1.5)  // 270 degrees
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration de l'imagePicker
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        // configuration pour que imageView s'ajustent les images à leur taille
        topLeftImageView.contentMode = .scaleAspectFill
        topRightImageView.contentMode = .scaleAspectFill
        bottomLeftImageView.contentMode = .scaleAspectFill
        bottomRightImageView.contentMode = .scaleAspectFill
        
        // Appeler la fonction button2IsPressed pour configurer la vue
        button2IsPressed(self)
        
        
        // Méthode 1 : for ... in
        for button in layoutButtons {
            button.setTitle("", for: .normal)
        }
        
       
        
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    @objc func orientationChanged() {
        let orientation = UIDevice.current.orientation
        let isLandscape = orientation.isLandscape
        
        if isLandscape {
            swipeLabel.text = "Swipe left to share" // Ajouter cette ligne
            swipeGestureRecognizer.direction = .left
        } else {
            swipeLabel.text = "Swipe up to share" // Ajouter cette ligne
            swipeGestureRecognizer.direction = .up
        }
        
        rotateArrowImageView(for: orientation)
    }

    
    private func rotateArrowImageView(for orientation: UIDeviceOrientation) {
            if orientation.isLandscape {
                arrowImageView.transform = landscapeTransform
                
            } else {
                      arrowImageView.transform = portraitTransform
                  }
              }
    
    
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        print("Swipe detected")
        
        let renderer = UIGraphicsImageRenderer(size: imagesContainerView.bounds.size)
        let image = renderer.image { ctx in imagesContainerView.drawHierarchy(in: imagesContainerView.bounds, afterScreenUpdates: true)
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        let orientation = UIDevice.current.orientation
        let isLandscape = orientation.isLandscape
        
        // Sauvegarder la position originale de la vue
        let originalPosition = imagesContainerView.center
        
        // Définir la translation nécessaire pour faire disparaître la vue de l'écran
        let offScreenTransform: CGAffineTransform = isLandscape ?
            CGAffineTransform(translationX: -view.bounds.width, y: 0) :
            CGAffineTransform(translationX: 0, y: -view.bounds.height)
        
        // Animer la vue pour qu'elle glisse hors de l'écran
        UIView.animate(withDuration: 0.5, animations: {
            self.imagesContainerView.transform = offScreenTransform
        }) { (completed) in
            // Présenter le UIActivityViewController après la fin de l'animation.
            self.present(activityViewController, animated: true, completion: nil)
        }

        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            // Animer la vue pour qu'elle revienne à sa place d'origine
            UIView.animate(withDuration: 0.5, animations: {
                self.imagesContainerView.transform = .identity
                self.imagesContainerView.center = originalPosition
            })
        }
    }


    
    
    
    
    @IBAction func layoutButtonIsPressed(_ sender: UIButton) {
        print("button.tag: \(sender.tag)")
        
        let integers = [1, 2, 3]
        
        print("entier sélectionné: \(integers[sender.tag])")
    }
    
    @IBAction func button1IsPressed(_ sender: Any) {
        print("button 1 IsPressed")
        // Changer le design de la vue principale
        // Afficher l'image "Selected"
        topLeftView.isHidden = true
        bottomLeftView.isHidden = false
        select1.isHidden = false
        select2.isHidden = true
        select3.isHidden = true
    }
    
    @IBAction func button2IsPressed(_ sender: Any) {
        print("button 2 IsPressed")
        topLeftView.isHidden = false
        bottomLeftView.isHidden = true
        select1.isHidden = true
        select2.isHidden = false
        select3.isHidden = true
    }
    
    @IBAction func button3IsPressed(_ sender: Any) {
        print("button 3 IsPressed")
        topLeftView.isHidden = false
        bottomLeftView.isHidden = false
        select1.isHidden = true
        select2.isHidden = true
        select3.isHidden = false
    }
    
    
    
    
    @IBAction func bottomRightImage(_ sender: UIButton) {
        print("image bas droite ou millieu IsPressed")
        selectedImageView = bottomRightImageView
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func bottomLeftImage(_ sender: UIButton) {
        print("image bas gauche IsPressed")
        selectedImageView = bottomLeftImageView
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func topRightImage(_ sender: UIButton) {
        print("image haut Droite ou millieu IsPressed")
        selectedImageView = topRightImageView
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func topLeftImage(_ sender: UIButton) {
        print("image haut gauche IsPressed")
        selectedImageView = topLeftImageView
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView?.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

    

