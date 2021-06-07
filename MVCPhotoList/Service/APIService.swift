//
//  APIService.swift
//  MVCPhotoList
//
//  Created by ahmet on 5.01.2021.
//		

import Foundation

class APIService {

    func fetchPopularPhoto( complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: Error? )->() ) {
        DispatchQueue.global().async {
          
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let photos = try! decoder.decode(Photos.self, from: data)
            complete( true, photos.photos, nil )
        }
    }
}
