//
//  ViewController.swift
//  MoviesApp
//
//  Created by Dubrouski Nikita on 21.07.23.
//
import UIKit

class ViewController: UIViewController {

    var myCollectionView: UICollectionView?
    let alomafireProvider: AlomafireProviderProtocol = AlomafireProvider()
    
    var searchModel: [SearchModel] = []
    var currentPage = 1 // Current page of movies
    var isFetchingMovies = false // Track if movies are being fetched
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .gray
        getMovies(nameMovies: "home", page: currentPage)
        
        let mosaicLayout = MosaicLayout()
        
        myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)
        
        myCollectionView?.backgroundColor = UIColor.clear
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        
        myCollectionView?.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)
        
        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
    }
    
    func getMovies(nameMovies: String, page: Int) {
        guard !isFetchingMovies else { return } // Return if movies are already being fetched
        isFetchingMovies = true // Set fetching flag to true
        
        Task {
            do {
                let moviesModel = try await alomafireProvider.getMovies(nameMovies: nameMovies, page: page)
                searchModel += moviesModel.search.map { SearchModel(data: $0) }
             
                currentPage += 1 // Increment the current page
                myCollectionView?.reloadData()
                isFetchingMovies = false // Reset fetching flag to false
            } catch {
                print(error)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCell.identifer, for: indexPath) as? MosaicCell else {
            return UICollectionViewCell()
        }
        
        let searchInfo = searchModel[indexPath.item]
        cell.configure(model: searchInfo)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if the last cell is about to be displayed
        if indexPath.item == searchModel.count - 1 {
            // Load new movies
            getMovies(nameMovies: "home", page: currentPage)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.item)")
    }
}
