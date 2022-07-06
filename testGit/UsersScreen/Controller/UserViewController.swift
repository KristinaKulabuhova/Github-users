//
//  UserViewController.swift
//  testGit
//
//  Created by Kristina on 05.07.2022.
//

import Foundation

import UIKit

final class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct GHUser : Codable {
        var name : String?
        var email : String?
        var login : String
        var id : Int64
        var avatar_url : String
        var url : String
        var html_url : String
        var followers_url : String
        var following_url : String
        var subscriptions_url : String
        var organizations_url : String
    }
    
    var users: [GHUser] = []
    
    let tableView = UITableView()
    var sinceId : Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
        configureTableView()
        getUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTableView()
        tableView.refreshControl?.addTarget(self, action: #selector(loadUsers(_:)), for: .valueChanged)
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureTableView() {
        self.restorationIdentifier = "userlist"
        view.addSubview(tableView)
        tableView.refreshControl = UIRefreshControl()
        tableView.register(UsersViewCell.self,
                           forCellReuseIdentifier: UsersViewCell.identifier)
        tableView.rowHeight = 70
        setTableViewDelegates()
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getUsers() {
        guard let url = URL(string: "https://api.github.com/users?since=" + String(sinceId)) else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        Task {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

            users = try JSONDecoder().decode([GHUser].self, from: data)
            users.reverse()
            sinceId = users.first!.id
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    
    @objc private func loadUsers(_ sender: Any) {
        getUsers()
    }

    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ collectionView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersViewCell.identifier, for: indexPath) as! UsersViewCell
        
        cell.setUpData(login: users[indexPath.row].login, id: String(users[indexPath.row].id), avatar_url: users[indexPath.row].avatar_url)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        print("cell tapped")
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableRow = indexPath.row

        let userDetails: UIViewController = UserDetailsViewController(login: users[tableRow].login)
        userDetails.modalPresentationStyle = .pageSheet
        navigationController?.pushViewController(userDetails, animated: true)
        self.loadView()
        self.view.setNeedsLayout()
    }
}
