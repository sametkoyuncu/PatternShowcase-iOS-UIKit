//
//  ViewModel.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

import Foundation

class PostViewModel {
    private var posts: [Post] = []

    func fetchPosts(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                return
            }

            do {
                self?.posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    func numberOfPosts() -> Int {
        return posts.count
    }

    func post(at index: Int) -> Post {
        return posts[index]
    }
}

