//
//  VIPER_Interactor.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

import Foundation

protocol VIPERInteractorDelegate: AnyObject {
    func postsFetched(posts: [VIPERPost])
    func onError()
}

class VIPERInteractor {
    weak var delegate: VIPERInteractorDelegate?
    
    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            delegate?.onError()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                self.delegate?.onError()
                return
            }
            
            if let data = data {
                do {
                    let posts = try JSONDecoder().decode([VIPERPost].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.postsFetched(posts: posts)
                    }
                } catch {
                    print("Error decoding posts: \(error)")
                    DispatchQueue.main.async {
                        self.delegate?.onError()
                    }
                }
            }
        }.resume()
    }
}
