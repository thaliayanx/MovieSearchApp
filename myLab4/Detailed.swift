//
//  Detailed.swift
//  InClassDemo2
//
//  Created by Todd Sproull on 10/10/16.
//  Copyright © 2016 Todd Sproull. All rights reserved.
//

import UIKit

class Detailed: UIViewController {
    
    var image: UIImage!
    var name: String!
    var released:String!
    var score:String!
    var rating:String!
    var favorite:[String] = []
    
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var theLabel2: UILabel!
    @IBOutlet weak var theLabel3: UILabel!
    @IBOutlet weak var theLabel4: UILabel!
    
    @IBAction func buttonClicked(sender: AnyObject) {
        let shareText = "Checkout my latest app #coolapp"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theImage.image = image
        theLabel.text = name
        theLabel2.text = released
        theLabel3.text = score
        theLabel4.text = rating
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func favoriteClicked(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var temp:[String] = []
        if let love = defaults.arrayForKey("movie"){
            temp = love as! [String]
            var i : Int = 0
            if(temp.count == 0){
                temp.append(name)
                tabBarController?.tabBar.items?[1].badgeValue = "!"
                print(temp)
            }else{
                for index in 0 ... (temp.count-1){
                    if (name != temp[index]){
                        i = i+1
                    }
                }
                
                print(temp.count)
                
                if(i == temp.count){
                    temp.append(name)
                    let alert = UIAlertController(title: "Reminder", message: "Added to Favorite.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    let notice = tabBarController?.tabBar.items?[1].badgeValue
                    if(notice == nil){
                        tabBarController?.tabBar.items?[1].badgeValue = "!"
                    }
                }else if (temp.count != 0){
                    let alert = UIAlertController(title: "Reminder", message: "Already added to Favorite.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        } else {
            temp.append(name)
            tabBarController?.tabBar.items?[1].badgeValue = "!"
            
        }
        favorite = temp
        defaults.setObject(favorite, forKey: "movie")
        defaults.synchronize()
        //favoriteButton.alpha = 0.5
    }

    
    
}
