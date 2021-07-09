//
//  ViewController.swift
//  Movie List
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import UIKit
import Reachability
import SDWebImage
import CoreData

class ViewController: UITableViewController, AddProtocol {
    
    var movies = [MovieList]()
    var movieArray = [NSManagedObject]()
    var isReachability: Bool?
    
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi || reachability.connection == .cellular {
                self.isReachability = true
                self.downloadJSON()
                self.fetchData()
                print("Reachable via WiFi OR Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.isReachability = false
            self.fetchData()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        //reachability.stopNotifier()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReachability == false {
            return movieArray.count
        } else {
            return movies.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if isReachability == false {
            let movie = movieArray[indexPath.row]
                   
            cell.textLabel?.text = movie.value(forKey: "title") as? String
            cell.detailTextLabel?.text = movie.value(forKey: "genre") as? String
            cell.imageView?.sd_setImage(with: URL(string: (movie.value(forKey: "image") as? String)!))
        } else {
            let movie = movies[indexPath.row]
                   
            cell.textLabel?.text = movie.title
            cell.detailTextLabel?.text = movie.genre.joined(separator: ", ")
            cell.imageView?.sd_setImage(with: URL(string: movie.image))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let manageContext = appDelegate.persistentContainer.viewContext
            manageContext.delete(movieArray[indexPath.row])
            do {
                try manageContext.save()
            } catch let error {
                print(error)
            }
            movieArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(identifier: "detailsVC") as! DetailsViewController
        if isReachability == true {
            let selctedMovie = movies[indexPath.row]
            details.movie = selctedMovie
               navigationController?.pushViewController( details, animated: true)
         
        } else{
            let selctedMovie = movieArray[indexPath.row]
            details.movieCoreData = selctedMovie
               navigationController?.pushViewController( details, animated: true)
         
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        let add = self.storyboard?.instantiateViewController(identifier: "addVC") as! AddMovieViewController
        add.addProtocol = self
        navigationController?.pushViewController(add, animated: true)
    }
    
    func saveMethod(movie: MovieList) {
        coreSaved(movie: movie)
        tableView.reloadData()
    }
}

extension ViewController {
    func downloadJSON() {
        
        let url = URL(string: "https://api.androidhive.info/json/movies.json")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
 
        let task = session.dataTask(with: request) { (data, response, error) in
            do{
                let decoder = JSONDecoder()
                let jesonArray = try decoder.decode([MovieList].self, from: data!)
                for item in jesonArray
                {
                    self.movies.append(MovieList(title: item.title , image: item.image, rating: item.rating, releaseYear: item.realeseYear, genre: item.genre))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let error{
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        var managedMovie = [MovieCoreData]()
        let fetchRequest = NSFetchRequest<MovieCoreData>(entityName: "Movie")
        do {
            managedMovie = try manageContext.fetch(fetchRequest)
            for item in managedMovie {
                var itemGenre:[String]?
                if let val = item.value(forKey: "genre") {
                    itemGenre = ((val as AnyObject) as! [String])
                }
                movies.append(MovieList(title: item.value(forKey: "title") as! String , image: item.value(forKey: "image") as! String, rating: item.value(forKey: "rating") as! Float, releaseYear: item.value(forKey: "releaseYear" ) as! Int, genre: itemGenre ?? ["error"]))
            }
            movieArray = managedMovie
            self.tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    func coreSaved(movie: MovieList) {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: manageContext)
        let moviesCoreData = NSManagedObject(entity: entity!, insertInto: manageContext)
        
        moviesCoreData.setValue(movie.title, forKey: "title")
        moviesCoreData.setValue(movie.image, forKey: "image")
        moviesCoreData.setValue(movie.rating, forKey: "rating")
        moviesCoreData.setValue(movie.realeseYear, forKey: "releaseYear")
        moviesCoreData.setValue(movie.genre, forKey: "genre")
        
        do{
            try manageContext.save()
            movieArray.append(moviesCoreData)
            movies.append(MovieList(title: moviesCoreData.value(forKey: "title") as! String , image: moviesCoreData.value(forKey: "image") as! String, rating: moviesCoreData.value(forKey: "rating") as! Float, releaseYear: moviesCoreData.value(forKey: "releaseYear" ) as! Int, genre: moviesCoreData.value(forKey: "genre") as! [String]))
        }catch let error{
            print(error)
        }
    }
}
