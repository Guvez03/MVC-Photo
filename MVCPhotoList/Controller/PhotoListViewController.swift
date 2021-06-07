//
//  ViewController.swift
//  MVCPhotoList
//
//  Created by ahmet on 5.01.2021.
//

import UIKit
import Kingfisher

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var photos : [Photo] = [Photo]()
    
    var selectedIndex : IndexPath?
    lazy var apiService: APIService = {
        return APIService()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initData()
    }
    
    func initView() {
        self.navigationItem.title = "Popular"
        
        activityIndicator.startAnimating()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initData() {

        self.apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            DispatchQueue.main.async {
                self?.photos = photos
                
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                    
                })
                self?.tableView.reloadData()
            }
        }
    }
}

extension PhotoListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let photo = self.photos[indexPath.row]
        
        cell.nameLabel.text = photo.name
        
        var descText : [String] = [String]()
        
        if let camera = photo.camera , let description = photo.description {
            descText.append(camera)
            descText.append(description)
        }
        cell.descriptionLabel.text = descText.joined(separator: " - ")
        
        let dateFormateer = DateFormatter()
        dateFormateer.dateFormat = "yyyy-MM-dd"
        cell.dateLabel.text = dateFormateer.string(from: photo.created_at)
        
        let url = URL(string: photo.image_url)
        cell.mainImageView.kf.setImage(with: url)
        
        return cell
    }
}
extension PhotoListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let photo = self.photos[indexPath.row]
        
        if photo.for_sale {
            self.selectedIndex = indexPath
            performSegue(withIdentifier: "passDetail", sender: nil)
            return indexPath
            
        }else{
            let alert = UIAlertController(title: "Not for sale", message: "This item is not for sale", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert,animated: true,completion: nil)
            return nil
        }
        
    }
    
}

extension PhotoListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetailViewController, let indexpath = self.selectedIndex {
            let photo = self.photos[indexpath.row]
            vc.imageUrl = photo.image_url
        }
    }
}

class PhotoListTableViewCell : UITableViewCell{
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}
