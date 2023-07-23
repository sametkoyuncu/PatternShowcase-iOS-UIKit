//
//  ViewController.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

import UIKit

/// MVC - ViewController
class FirstVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [MVCPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPosts()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                self?.posts = try JSONDecoder().decode([MVCPost].self, from: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

extension FirstVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}

