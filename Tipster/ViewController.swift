//
//  ViewController.swift
//  Tipster
//
//  Created by Redwan Khan on 15/09/2022.
//

import UIKit
import AlamofireImage
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    

    @IBOutlet weak var tableView: UITableView!
    var movies = [[String: Any]]()// huh? lol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 self.tableView.reloadData()
                // print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCellTableViewCell") as! MovieCellTableViewCell
        
        let movie = movies[indexPath.row]
       let title = movie["title"] as! String //casting means
        //cell.textLabel?.text = "row: \(indexPath.row)" //? is swift optionals. we will learn about this later.
        let synopsis = movie["overview"] as! String
        //cell.textLabel!.text = title
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }
            // in a storyboard application, u will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            //get the new view controller using segue.destination.
            //pass the selected object to the new view controller
            
        print("Loading up the details screen")
            
            //find the selected movie
            //below sender is the cell that was tapped
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let movie = movies[indexPath.row]
            
            // pass the selected movie to the details view controller
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
}

