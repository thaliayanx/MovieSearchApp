//
//  movie.swift
//  myLab4
//
//  Created by thalia on 10/10/16.
//  Copyright © 2016 thalia. All rights reserved.
//

import Foundation

class movie{
    var id: String
    var name: String
    var year: String
    var rating: String
    var score: String
    var url: String
    
    init(name: String, year: String, rating: String, score: String, url: String, id: String){
        self.name = name
        self.year = year
        self.url = url
        self.rating = rating
        self.score = score
        self.id = id
    }
}