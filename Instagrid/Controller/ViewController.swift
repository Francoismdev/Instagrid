//
//  ViewController.swift
//  Instagrid
//
//  Created by FrancoisDev on 24/04/2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   // MARK: - Proprities
    
    var imagePicker = UIImagePickerController()
    var selectedButton: UIButton?
    var selectedImageView: UIImageView?
    var swipeGestureRecognizer: UISwipeGestureRecognizer!
   
    let portraitTransform = CGAffineTransform(rotationAngle: 0)  // 0 degrees
    let landscapeTransform = CGAffineTransform(rotationAngle: .pi * 1.5)  // 270 degrees
    
    // MARK: - Outlets
    
    @IBOutlet weak var arrowImageView: UIImageView! // The arrow that indicates the direction of sliding. ** La flèche qui indique la direction de glissement.
    @IBOutlet weak var swipeLabel: UILabel! // The label that displays the sliding direction. ** Le label qui affiche la direction de glissement.
    
    @IBOutlet weak var topLeftView: UIView! //The view at the top left of the grid. ** La vue en haut à gauche de la grille.
    @IBOutlet weak var bottomLeftView: UIView! // The view at the bottom left of the grid. ** La vue en bas à gauche de la grille.
    
    @IBOutlet var layoutButtons: [UIButton]! // The buttons that allow you to choose the layout of the grid. ** Les boutons qui permettent de choisir le layout de la grille.
    
    @IBOutlet weak var select1: UIImageView! // The selection indicator for the first layout. ** L'indicateur de sélection pour le premier layout.
    @IBOutlet weak var select2: UIImageView! // The selection indicator for the second layout. ** L'indicateur de sélection pour le deuxième layout.
    @IBOutlet weak var select3: UIImageView! // The selection indicator for the third layout. ** L'indicateur de sélection pour le troisième layout.
    
    @IBOutlet weak var imagesContainerView: UIView! // The container that contains all the images in the grid. ** Le conteneur qui regroupe toutes les images de la grille.
    
    @IBOutlet weak var topLeftImageView: UIImageView! // The image at the top left of the grid. ** L'image en haut à gauche de la grille.
    @IBOutlet weak var topRightImageView: UIImageView! // The image at the top right of the grid. ** L'image en haut à droite de la grille.
    @IBOutlet weak var bottomLeftImageView: UIImageView! // The image at the bottom left of the grid. ** L'image en bas à gauche de la grille.
    @IBOutlet weak var bottomRightImageView: UIImageView! // The image at the bottom right of the grid. ** L'image en bas à droite de la grille.
    
    
    @IBOutlet weak var plusTopLeft: UIImageView! // The add image indicator at the top left of the grid. ** L'indicateur d'ajout d'image en haut à gauche de la grille.
    @IBOutlet weak var plusTopRight: UIImageView! // The add image indicator at the top right of the grid. ** L'indicateur d'ajout d'image en haut à droite de la grille.
    @IBOutlet weak var plusBottomLeft: UIImageView! // L'indicateur d'ajout d'image en haut à droite de la grille. ** L'indicateur d'ajout d'image en bas à gauche de la grille.
    @IBOutlet weak var plusBottomRight: UIImageView! // The add image indicator at the bottom right of the grid. ** L'indicateur d'ajout d'image en bas à droite de la grille.
    
 
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // MARK: - UI Setup
        
        // Configuring the imagePicker ** Configuration de l'imagePicker
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        // configuration for imageView to adjust the images to their size ** configuration pour que imageView s'ajustent les images à leur taille
        topLeftImageView.contentMode = .scaleAspectFill
        topRightImageView.contentMode = .scaleAspectFill
        bottomLeftImageView.contentMode = .scaleAspectFill
        bottomRightImageView.contentMode = .scaleAspectFill
        
        // Call the button2IsPressed function to configure the view ** Appeler la fonction button2IsPressed pour configurer la vue
        button2IsPressed(self)
        
        
        // Méthode : for ... in
        for button in layoutButtons {
            button.setTitle("", for: .normal)
        }
        
       
        
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    // MARK: - Event Handling ** Traitement des événements
    
    // rotate the image of the arrow according to the oriantation ** pivoter l'image de la fleche en fonction de l'oriantation
    
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
        // Captures the image from the imagesContainerView ** Capture l'image de la vue imagesContainerView.
        let renderer = UIGraphicsImageRenderer(size: imagesContainerView.bounds.size)
        let image = renderer.image { ctx in imagesContainerView.drawHierarchy(in: imagesContainerView.bounds, afterScreenUpdates: true)
        }
        
        // Create an activity controller to share the image ** Crée un contrôleur d'activité pour partager l'image.
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // Gets the current orientation of the device ** Obtient l'orientation actuelle de l'appareil.
        let orientation = UIDevice.current.orientation
        let isLandscape = orientation.isLandscape
        
        // Saves the original position of the view ** Sauvegarde la position originale de la vue.
        let originalPosition = imagesContainerView.center
        
        // Set translation to remove the view from the screen ** Définir la translation pour faire disparaître la vue de l'écran.
        let offScreenTransform: CGAffineTransform = isLandscape ?
            CGAffineTransform(translationX: -view.bounds.width, y: 0) :
            CGAffineTransform(translationX: 0, y: -view.bounds.height)
        
        // Animating the view to slide off the screen ** Animation la vue pour qu'elle glisse hors de l'écran.
        UIView.animate(withDuration: 0.5, animations: {
            self.imagesContainerView.transform = offScreenTransform
        }) { (completed) in
            
            // Presence of UIActivityViewController after the end of the animation ** Présention de UIActivityViewController après la fin de l'animation.
            self.present(activityViewController, animated: true, completion: nil)
        }

        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            
            // Animation of the view so that it returns to its original position ** Animation de la vue pour qu'elle revienne à sa place d'origine.
            UIView.animate(withDuration: 0.5, animations: {
                self.imagesContainerView.transform = .identity
                self.imagesContainerView.center = originalPosition
            })
        }
    }


    
    // MARK: - Actions
    
    @IBAction func layoutButtonIsPressed(_ sender: UIButton) {
        print("button.tag: \(sender.tag)")
        
        let integers = [1, 2, 3]
        
        print("entier sélectionné: \(integers[sender.tag])")
    }
    
    @IBAction func button1IsPressed(_ sender: Any) {
        print("button 1 IsPressed")
        // Hides the topLeftView and displays the bottomLeftView ** Cache la vue topLeftView et affiche la vue bottomLeftView.
        topLeftView.isHidden = true
        bottomLeftView.isHidden = false
        // Displays the select1 selector and hides the select2 and select3 selectors ** Affiche le sélecteur select1 et cache les sélecteurs select2 et select3.
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
    
    // MARK: - Image Picker Delgate
    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView?.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

    

