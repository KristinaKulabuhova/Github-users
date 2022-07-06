//
//  UserDetailsViewController.swift
//  testGit
//
//  Created by Kristina on 05.07.2022.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    var userLogin: String = ""
    
    convenience init(login: String) {
        self.init()
        self.userLogin = login
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct GHUserDetails: Codable {
        var followers: Int64
        var following: Int64
        var login: String
        var name: String?
        var email: String?
        var avatar_url: String
        var created_at: String
        var organizations_url: String
    }
    
    var detailsStackView = UIStackView()
    var user: GHUserDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailsStackView)
        getUserDetails(login: userLogin)
        configureStack()
        self.tabBarController!.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)
    }
    
    var avatarImage = UIImageView()
    var nameLabel: UILabel?
    var emailLabel: UILabel?
    var organizationLabel = UILabel()
    var followingCountLabel = UILabel()
    var followersCountLabel = UILabel()
    var creationDateLabel = UILabel()
    
    func configure() {
        nameLabel?.contentMode = .left
        emailLabel?.contentMode = .left
        organizationLabel.contentMode = .left
        followingCountLabel.contentMode = .left
        followersCountLabel.contentMode = .left
        creationDateLabel.contentMode = .left
        
        avatarImage.layer.cornerRadius = 10
        avatarImage.clipsToBounds = true
        avatarImage.contentMode = .scaleAspectFill
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.avatarImage.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func setUpData(structUser: GHUserDetails) {
        downloadImage(from: URL(string: user!.avatar_url)!)
        if let name = structUser.name {nameLabel = UILabel()
            nameLabel?.text = "Login: " + name
            detailsStackView.addArrangedSubview(nameLabel!)
            title = name
        }
        if let email = structUser.email {
            emailLabel = UILabel()
            emailLabel?.text = "Email: " + email
            detailsStackView.addArrangedSubview(emailLabel!)
            
        }
        
        creationDateLabel.text = "Date: " + structUser.created_at
        followersCountLabel.text = "Followers: " + String(structUser.followers)
        followingCountLabel.text = "Following: " + String(structUser.following)
        organizationLabel.text = "Organization: " + structUser.organizations_url
    }
    
    func configureStack() {
        detailsStackView.axis = .vertical
        detailsStackView.distribution = .equalSpacing
        detailsStackView.alignment = .leading
        detailsStackView.spacing = 30;
        
        detailsStackView.addArrangedSubview(avatarImage)
        detailsStackView.addArrangedSubview(organizationLabel)
        detailsStackView.addArrangedSubview(followingCountLabel)
        detailsStackView.addArrangedSubview(followersCountLabel)
        detailsStackView.addArrangedSubview(creationDateLabel)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCostraints()
    }
    
    func setCostraints() {
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor).isActive = true
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        detailsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        detailsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50).isActive = true
        detailsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    func getUserDetails(login: String) {
        guard let url = URL(string: "https://api.github.com/users/" + login) else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        Task {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

            user = try JSONDecoder().decode(GHUserDetails.self, from: data)
            setUpData(structUser: user!)
        }
    }
}
