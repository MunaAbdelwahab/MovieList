//
//  AddMovieViewController.swift
//  Movie List
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import UIKit
import CoreData

class AddMovieViewController: UIViewController {
    
    var addProtocol:AddProtocol?
    
    @IBOutlet weak var genraTextField: UITextField!
    @IBOutlet weak var releaseYearTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let addMovie = MovieList(title: titleTextField.text!, image: "https://miro.medium.com/max/1120/0*ckAOzr7BW6fhFeGK.jpg", rating: Float(rateTextField.text!) ?? 0.0, releaseYear: Int (releaseYearTextField.text!)!, genre: [genraTextField.text!])
        
        addProtocol?.saveMethod(movie: addMovie)
        self.navigationController?.popViewController(animated: true)
    }
}
