//
//  PhotoFetchOperation.swift
//  Astronomy
//
//  Created by Enrique Gongora on 3/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class PhotoFetchOperation: ConcurrentOperation {
    
    var photoReference: MarsPhotoReference
    var dataTask: URLSessionDataTask?
    var imageData: Data?
    
    init(photoReference: MarsPhotoReference, session: URLSession = .shared) {
        self.photoReference = photoReference
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        fetchPhoto()
        dataTask?.resume()
    }
    
    override func cancel() {
        state = .isFinished
        dataTask?.cancel()
    }
    
    func fetchPhoto() {
        guard let url = photoReference.imageURL.usingHTTPS else { return }
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            defer {
                self.state = .isFinished
            }
            self.imageData = data
        }
    }
}
