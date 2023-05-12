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
        
    
    // How to open photo gallery iPhone swift UIImagePickerController
    // let pickerController = UIImagePickerController()
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var bottomLeftView: UIView!
    @IBOutlet weak var bottomRightView: UIView!
    
    
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
        
        // Méthode 2 : forEach
        layoutButtons.forEach { button in
            button.setTitle("", for: .normal)
        }
        
        // Méthode 3 : forEach avec l'utilisation de l'opérateur $0
        layoutButtons.forEach { $0.setTitle("", for: .normal) }
        
        // [1, 2, 3].forEach { print($0) }
        
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)

        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationChanged() {
        let orientation = UIDevice.current.orientation
        if orientation.isLandscape {
            swipeGestureRecognizer.direction = .left
        } else {
            swipeGestureRecognizer.direction = .up
        }
    }
    
    @objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        print("Swipe detected")
       
        let renderer = UIGraphicsImageRenderer(size: imagesContainerView.bounds.size)
        let image = renderer.image { ctx in
            imagesContainerView.drawHierarchy(in: imagesContainerView.bounds, afterScreenUpdates: true)
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
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

    

