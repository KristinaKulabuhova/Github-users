//
//  UsersCell.swift
//  testGit
//
//  Created by Kristina on 05.07.2022.
//

import UIKit

final class UsersViewCell: UITableViewCell {
    
    static let identifier = "usersCell"
    
    var avatarImageView = UIImageView()
    var loginTitleLable = UILabel()
    var idSubtitleLable = UILabel()
    var stackLableView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(avatarImageView)
        addSubview(stackLableView)
        
        configureImageView()
        configureStackLabel()
        setImageConstraints()
        setStackContraints()
    }
    
    func setUpData(login: String, id: String, avatar_url: String) {
        loginTitleLable.text = login
        idSubtitleLable.text = id
        downloadImage(from: URL(string: avatar_url)!)
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.avatarImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.clipsToBounds = true
    }
    
    func configureLoginTitle() {
        loginTitleLable.numberOfLines = 1
        loginTitleLable.font = UIFont.systemFont(ofSize: 17)
        loginTitleLable.adjustsFontSizeToFitWidth = true
        loginTitleLable.textAlignment = .left
        loginTitleLable.textColor = .black
        loginTitleLable.sizeToFit()
    }
    
    func configureidSubtitle() {
        idSubtitleLable.numberOfLines = 1
        idSubtitleLable.font = UIFont.systemFont(ofSize: 12)
        idSubtitleLable.adjustsFontSizeToFitWidth = true
        idSubtitleLable.textAlignment = .left
        idSubtitleLable.textColor = .black
        idSubtitleLable.sizeToFit()
    }
    func configureStackLabel() {
        stackLableView.addArrangedSubview(loginTitleLable)
        stackLableView.addArrangedSubview(idSubtitleLable)
    
        stackLableView.distribution = .equalSpacing
        stackLableView.axis = .vertical
        stackLableView.alignment = .center
        
        configureImageView()
        configureLoginTitle()
    }
    
    func setImageConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        //avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
    }
    
    func setStackContraints() {
        stackLableView.translatesAutoresizingMaskIntoConstraints = false
        stackLableView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10).isActive = true
        stackLableView.heightAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
        stackLableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackLableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        stackLableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
