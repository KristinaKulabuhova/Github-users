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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getUsers()
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
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
        guard let url = URL(string: "https://api.github.com/users") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        Task {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

            users = try JSONDecoder().decode([GHUser].self, from: data)
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
        }
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
        //tableView.reloadData()
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        print("cell tapped")
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let tableRow = indexPath.row

      var controllerToPresent: UIViewController
        controllerToPresent = UserDetailsViewController(login: users[tableRow].login)
      self.present(controllerToPresent, animated: true)
    }
}
