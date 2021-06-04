//
//  PhotoDetailViewController.swift
//  MVCPhotoList
//
//  Created by ahmet on 5.01.2021.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {

  var imageUrl : String?
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

      if let imageURL = imageUrl {
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url)
          
        
      }

    }
    



}
