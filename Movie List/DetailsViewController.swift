//
//  DetailsViewController.swift
//  Movie List
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import UIKit
import CoreData
import SDWebImage

class DetailsViewController: UIViewController {

    @IBOutlet weak var genraLaabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var ratingLabell: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var movie:MovieList?
    var movieCoreData = NSManagedObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie.title
            imageView.sd_setImage(with: URL(string: movie.image))
            ratingLabell.text = "\(movie.rating)"
            releaseYearLabel.text = "\(movie.realeseYear)"
            genraLaabel.text =  movie.genre.joined(separator: ",")
        } else {
            titleLabel.text = movieCoreData.value(forKey: "title") as? String
            imageView.sd_setImage(with: URL(string: movieCoreData.value(forKey: "image") as! String))
            if let val = movieCoreData.value(forKey: "rating") {
                ratingLabell.text = (val as AnyObject).stringValue
            }
            if let val = movieCoreData.value(forKey: "releaseYear") {
                releaseYearLabel.text = (val as AnyObject).stringValue
            }
            var itemGenre:[String]?
            if let val = movieCoreData.value(forKey: "genre") {
                itemGenre = (val as! [String])
            }
            genraLaabel.text = itemGenre![0]
        }
    }

}
