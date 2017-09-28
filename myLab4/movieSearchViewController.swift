//
//  movieSearch.swift
//  myLab4
//
//  Created by thalia on 10/10/16.
//  Copyright © 2016 thalia. All rights reserved.
//

import UIKit

class movieSearchViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, UICollectionViewDelegateFlowLayout {
    var theData:[movie]=[]
    var theDataSecond:[movie]=[]
    var theImageCache:[UIImage]=[]
    var collectionView:UICollectionView!
    var yearArray:[Int]=[]
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var sliderValue: UISlider!
    var movieTitle: String=""
    var loading: UIActivityIndicatorView!
    var noResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupCollectionView()
        self.searchBar.delegate = self


    }
    @IBAction func yearChanged(sender: UISlider) {
        if theDataSecond.count==0 {
            return
        }
        else{
            print(yearArray.count)
            print(sender.value)
            if(sender.value>=0){
            let currentValue = yearArray[Int(round(sender.value))]
            print(currentValue)
            var filteredMovie:[movie]=[]
            for movie2 in theDataSecond{
            if let year2=Int(movie2.year){
                if year2<=currentValue{
                    filteredMovie.append(movie2)
                }
            }
            }
            theData=filteredMovie
            theImageCache.removeAll()
            cacheImages()
            }
        }
      collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSize(width: 120, height: 150)
        collectionView = UICollectionView(frame:view.frame.offsetBy(dx:0,dy:130),collectionViewLayout:layout)
        self.collectionView.backgroundColor = UIColor.clearColor();
        collectionView.registerClass(myCell.self,forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        self.collectionView.dataSource=self
        self.collectionView.delegate = self
        

        self.loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.loading.center = view.center
        //self.loading.startAnimating()
        view.addSubview(self.loading)
        
    }
    
    private func getJSON(url: String) -> JSON {
        if let nsurl = NSURL(string: url) {
            if let data = NSData(contentsOfURL: nsurl) {
                let json = JSON(data: data)
                return json
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.loading.startAnimating()
        theData.removeAll()
        theImageCache.removeAll()
        collectionView.reloadData()
        movieTitle=searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        if movieTitle.characters.count > 1{
            loadMovie()
        }
        //self.loading.stopAnimating()

    }

    func loadMovie(){
        //print("entering load")
        self.loading.startAnimating()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)){
            
            self.fetchDataForCollectionView(1)
            self.fetchDataForCollectionView(2)
            
            self.cacheImages()
      
            dispatch_async(dispatch_get_main_queue()){
                self.loading.stopAnimating()
                self.collectionView.reloadData()
                
                
            }
        }
    }
    
    func fetchDataForCollectionView(page:Int){
        
        let json = getJSON("http://www.omdbapi.com/?s=\(movieTitle)&page=\(page)&r=json")
        if(json["Search"] != nil){

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

        }
        for movie in theData{
            if let year=Int(movie.year){
                print(movie.name)
                yearArray.append(year)
            }
            else{
                print("movie\(movie.name)does not have a valid year")
            }
        }
        yearArray = yearArray.sort { $0 < $1 }
        theDataSecond=theData
        sliderValue.minimumValue=Float(0)
        sliderValue.maximumValue=Float(self.yearArray.count)-1
        

        print("First\(theData.count)")
        //cacheImages()

    }
    func cacheImages(){
        print("Second\(theData.count)")
        for item in theData{
            let url=NSURL(string: item.url)
            let data=NSData(contentsOfURL:url!)
            if data != nil{
                let image=UIImage(data:data!)
            theImageCache.append(image!)
            }
            else{
                print("image is not added")
                print("Second\(url)")
                theImageCache.append(UIImage())
            }
            
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Third\(theData.count)")
        return theData.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("enter")
        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as!myCell
        cell.backgroundColor=UIColor.orangeColor()
        cell.textLabel.text=theData[indexPath.item].name
        cell.imageView.image=theImageCache[indexPath.item]
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let detailVC = Detailed(nibName:"Detailed", bundle:nil)
        detailVC.image=theImageCache[indexPath.item]
        detailVC.name=theData[indexPath.item].name
        detailVC.released=theData[indexPath.item].year
        detailVC.score=theData[indexPath.item].score
        detailVC.rating=theData[indexPath.item].rating
        navigationController?.pushViewController(detailVC, animated: true)
        
        
    }
    


    

        


    


}
