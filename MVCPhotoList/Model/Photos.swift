//
//  Photos.swift
//  MVCPhotoList
//
//  Created by ahmet on 5.01.2021.
//

import Foundation

struct Photos:Codable{
  let photos : [Photo]
}

struct Photo:Codable {
  let id: Int
  let name: String
  let description: String?
  let created_at: Date
  let image_url: String
  let for_sale: Bool
  let camera: String?
}
