//
//  SecondVC.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

import UIKit

/// MVVM - ViewController
class MVVMView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = MVVMViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchPosts { [weak self] in
            self?.tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension MVVMView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = viewModel.post(at: indexPath.row)
        cell.textLabel?.text = post.title
        return cell
    }
}
