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
    
    var searchModel: [SearchModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .white
        getMovies(nameMovies: "home")
        
        let mosaicLayout = MosaicLayout()
        myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: mosaicLayout)// Add minimum line spacing
        
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)
        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
     
    }
    
    func getMovies(nameMovies: String) {
        Task {
            do {
                let moviesModel = try await alomafireProvider.getMovies(nameMovies: nameMovies)
                searchModel = moviesModel.search.map { SearchModel(data: $0) }
                myCollectionView?.reloadData()
            }
            catch {
                print(error)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCell.identifer, for: indexPath) as? MosaicCell else { return UICollectionViewCell() }
        guard let searchInfo = searchModel else { return cell}
        cell.configure(model: searchInfo[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
