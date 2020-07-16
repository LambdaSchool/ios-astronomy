//
//  PhotosCollectionViewController.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.fetchMarsRover(named: "curiosity") { (rover, error) in
            if let error = error {
                NSLog("Error fetching info for curiosity: \(error)")
                return
            }
            
            self.roverInfo = rover
        }
    }
    
    // UICollectionViewDataSource/Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReferences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCollectionViewCell ?? ImageCollectionViewCell()
        
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    // Make collection view cells fill as much available width as possible
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        var totalUsableWidth = collectionView.frame.width
        let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        totalUsableWidth -= inset.left + inset.right
        
        let minWidth: CGFloat = 150.0
        let numberOfItemsInOneRow = Int(totalUsableWidth / minWidth)
        totalUsableWidth -= CGFloat(numberOfItemsInOneRow - 1) * flowLayout.minimumInteritemSpacing
        let width = totalUsableWidth / CGFloat(numberOfItemsInOneRow)
        return CGSize(width: width, height: width)
    }
    
    // Add margins to the left and right side
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentFetchOperation = photoReferences[indexPath.item]
        guard let currentOperaion = operation[currentFetchOperation.id] else { return }
        currentOperaion.cancel()
    }
    // MARK: - Private
    
    private func loadImage(forCell cell: ImageCollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoReference = photoReferences[indexPath.item]
        
        // Checking if image has been cached and if it is, loading the image before the network call
        if let cachedImage = cache.getValue(for: photoReference.id){
            cell.imageView.image = UIImage(data: cachedImage)
            return
        }
        
        let photoFetchRequest = FetchPhotoOperation(photo: photoReference)

        let storeData = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            self.cache.storeInCache(value: data, for: photoReference.id)
        }
        
        let beenReused = BlockOperation {
            let currentIndex = self.collectionView.indexPath(for: cell)
            guard currentIndex == indexPath, let data = photoFetchRequest.imageData else { return }
            cell.imageView.image = UIImage(data: data)
        }
        
        storeData.addDependency(photoFetchRequest)
        beenReused.addDependency(photoFetchRequest)
        
        photoFetchQueue.addOperation(photoFetchRequest)
        photoFetchQueue.addOperation(storeData)
        OperationQueue.main.addOperation(beenReused)
        
        operation[photoReference.id] = photoFetchRequest
        
        // Creating a data task to retrive the images
        //        guard let imageURL = photoReference.imageURL.usingHTTPS else {
        //            print("Error getting image")
        //            return
        //        }
        //
        //        let task = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
        //            if let error = error{
        //                print("Error fetching image: \(error)")
        //                return
        //            }
        //
        //            guard let data = data else {
        //                    print("No data returned")
        //                    return
        //            }
        //
        //            // Saving the image to our cache for later use
        //            self.cache.storeInCache(value: data, for: photoReference.id)
        //
        //            DispatchQueue.main.async {
        //                // Checking to see if the indexpath of the cell is the one being called to load the image
        //                guard self.collectionView.indexPath(for: cell) == indexPath else { return }
        //                cell.imageView.image = UIImage(data: data)
        //            }
        //        }
        //        task.resume()
    }
    
    // Properties
    
    private let cache = Cache<Int, Data>()
    private let photoFetchQueue = OperationQueue()
    var operation = [Int: Operation]()
    
    private let client = MarsRoverClient()
    
    private var roverInfo: MarsRover? {
        didSet {
            solDescription = roverInfo?.solDescriptions[100]
        }
    }
    private var solDescription: SolDescription? {
        didSet {
            if let rover = roverInfo,
                let sol = solDescription?.sol {
                client.fetchPhotos(from: rover, onSol: sol) { (photoRefs, error) in
                    if let e = error { NSLog("Error fetching photos for \(rover.name) on sol \(sol): \(e)"); return }
                    self.photoReferences = photoRefs ?? []
                }
            }
        }
    }
    private var photoReferences = [MarsPhotoReference]() {
        didSet {
            DispatchQueue.main.async { self.collectionView?.reloadData() }
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!
}
