//
//  FetchPhotoOperation.swift
//  Astronomy
//
//  Created by Dillon McElhinney on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    var imageData: Data? = nil
    let photoReference: MarsPhotoReference
    private var dataTask: URLSessionDataTask?
    
    init(photoReference: MarsPhotoReference) {
        self.photoReference = photoReference
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let url = photoReference.imageURL.usingHTTPS else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error GETing image for \(self.photoReference.id): \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned")
                return
            }
            
            self.imageData = data
            return
        })
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
