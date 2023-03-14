//
//  ViewController.swift
//  FlixsterAPP_API
//
//  Created by Marlvin Goremusandu on 3/13/23.
//

import UIKit

class ViewController:UIViewController, UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        
        cell.textLabel!.text = title
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies=[[String:Any]]()
    override func viewDidAppear(_ animated: Bool) {        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource=self
//        tableView.delegate = self
        // Do any additional setup after loading the view.
        // Create a URL for the request
        // In this case, the custom search URL you created in in part 1
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!

        // Use the URL to instantiate a request
        let request = URLRequest(url: url)

        // Create a URLSession using a shared instance and call its dataTask method
        // The data task method attempts to retrieve the contents of a URL based on the specified URL.
        // When finished, it calls it's completion handler (closure) passing in optional values for data (the data we want to fetch), response (info about the response like status code) and error (if the request was unsuccessful)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            // Handle any errors
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                return
            }

            // Make sure we have data
            guard let data = data else {
                print("❌ Data is nil")
                return
            }

            // The `JSONSerialization.jsonObject(with: data)` method is a "throwing" function (meaning it can throw an error) so we wrap it in a `do` `catch`
            // We cast the resultant returned object to a dictionary with a `String` key, `Any` value pair.
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                //print(jsonDictionary)
                self!.movies = jsonDictionary["results"] as! [[String: Any]]
                print(self!.movies)
            } catch {
                print("❌ Error parsing JSON: \(error.localizedDescription)")
                return
            }
        }

        // Initiate the network request
        task.resume()
    }


}


