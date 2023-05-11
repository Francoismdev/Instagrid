//
//  ViewController.swift
//  Instagrid
//
//  Created by FrancoisDev on 24/04/2023.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        // Changer le design de la vue principale
        // Afficher l'image "Selected"
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
        // Changer le design de la vue principale
        // Afficher l'image "Selected"
    }
    
    
    @IBAction func bottomRightImage(_ sender: Any) {
        print("image bas droite ou millieu IsPressed")
    }
    
    
    @IBAction func bottomLeftImage(_ sender: Any) {
        print("image bas gauche IsPressed")
    }
    
   
    @IBAction func topRightImage(_ sender: Any) {
        print("image haut Droite ou millieu IsPressed")
    }
    
    
    @IBAction func topLeftImage(_ sender: Any) {
        print("image haut gauche IsPressed")
        
    }
    
    
}
