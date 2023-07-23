//
//  VIPER_View.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

import UIKit

/// VIPER - ViewController
class VIPERView: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var presenter: VIPERPresenter!
    private var posts: [VIPERPost] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter = VIPERPresenter()
        presenter.delegate = self
        presenter.fetchPosts()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension VIPERView: VIPERPresenterDelegate {
    func showPosts(posts: [VIPERPost]) {
        self.posts = posts
        tableView.reloadData()
    }

    func showError() {
        // Handle error display here
    }
}

extension VIPERView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}
