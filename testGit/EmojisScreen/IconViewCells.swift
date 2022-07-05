//
//  IconViewCells.swift
//  testGit
//
//  Created by Kristina on 05.07.2022.
//

import UIKit

final class IconViewCells: UICollectionViewCell {
    static let identifier = "iconCell"
    
    let imageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        configureIcon()
        setImageConstraints()
    }
    
    func configureIcon() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    func setUpIcon(url: String) {
        downloadImage(from: URL(string: url)!)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
                let image = self?.imageView.image
                let ratio = ((self?.imageView.frame.width)!) / image!.size.width
                let newHeight = image!.size.width * ratio;
                self?.imageView.frame = CGRect(origin: .zero, size: CGSize(width: newHeight, height: newHeight))
                
                self?.contentView.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setImageConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
    }
}
