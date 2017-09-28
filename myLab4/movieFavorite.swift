//
//  movieFavorite.swift
//  myLab4
//
//  Created by thalia on 10/10/16.
//  Copyright © 2016 thalia. All rights reserved.
//

import UIKit

class movieFavorite: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var theData: [movie] = []
    var theImageCache: [UIImage] = []
    var tableView: UITableView!
    var movieTitle = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.cacheImages()
        self.tableView.reloadData()
        tabBarController?.tabBar.items?[1].badgeValue = nil
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.setupTableView()
        self.cacheImages()
        self.tableView.reloadData()
        tabBarController?.tabBar.items?[1].badgeValue = nil
    }
    
    func fetchDataForTableView() {
        let json = getJSON("http://www.omdbapi.com/?s=\(movieTitle)")
        
        for result in json["Search"].arrayValue{
            let name = result["Title"].stringValue
            let url = result["Poster"].stringValue
            let year = result["Year"].stringValue
            let id = result["imdbID"].stringValue
            var score=""
            var rating=""
            let json2=getJSON("http://www.omdbapi.com/?i=\(id)")
            score = json2["imdbRating"].stringValue
            print("\(score)")
            rating = json2["Rated"].stringValue
            self.theData.append(movie(name: name, year: year,rating:rating, score:score, url:url, id:id))
            
        }
    
        print(theData)
        
        
    }
    
    
    private func getJSON(url: String) -> JSON {
        
        if let nsurl = NSURL(string: url){
            if let data = NSData(contentsOfURL: nsurl) {
                let json = JSON(data: data)
                return json
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    func cacheImages() {
        
        let array = NSUserDefaults.standardUserDefaults().stringArrayForKey("movie")
        if array != nil{
            movieTitle = array!
        }
        if(movieTitle.count == 0){
            let alert = UIAlertController(title: "Alert",
                                          message: "No favorite movie!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(movieTitle.count) items")
        return movieTitle.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = NSUserDefaults.standardUserDefaults().stringArrayForKey("movie")![indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            movieTitle.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(movieTitle, forKey: "movie")
        }
        
    }
    


}
