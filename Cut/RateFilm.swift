//
//  RateFilm.swift
//  Cut
//
//  Created by Kyle McAlpine on 17/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct RateFilm {
    let film: Film
    let rating: Double
}

extension RateFilm: Endpoint {
    typealias SuccessData = NoSuccessData
    var url: URL { return URL(string: "http://localhost:3000/v1/ratings")! }
    var body: [String : Any] { return ["film_id" : film.id, "rating" : rating] }
    static var method: HTTPMethod { return .post }
}