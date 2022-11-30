//
//  MovieListViewModel.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import Foundation
import Alamofire

protocol MovieListViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((Result<MovieListViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    
    /// ViewController' daki tableView'in row sayısını döner.
    /// - Returns: Int
    func getNumberOfRowsInSection() -> Int
    
    /// ViewController' daki tableView için cell datasını döner.
    /// - Parameter indexPath: Görünür cell'in index'i
     func getMovieForCell(at indexPath: IndexPath) -> [Movie]?
    /// - Returns: Movie datası
    func getMovies(search:String, page:Int)
    /// - movieList array'ini temizler.
    func cleanArray()
}

final class MovieListViewModelImpl: MovieListViewModel {
    func cleanArray() {
        movieList.removeAll()
    }
    
    private var searchResult : Search?
    private var movieList : [Movie] = []
   
    func getMovies(search:String, page:Int){
        AF.request("http://www.omdbapi.com/?s=\(search)&apikey=9b9e85e6&page=\(page)",method: .get).response { response in
            if let data = response.data{
                do{
                    let searchResult = try JSONDecoder().decode(Search.self, from: data)
                    self.movieList.append(contentsOf: searchResult.movies!)
                    self.start()
                }catch{
                    print(error.localizedDescription)
                }
            }
            
        }
    }

    
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?
    
    func start() {
        self.stateClosure?(.success(.updateMovieList))
    }
}

// MARK: ViewModel to ViewController interactivity
extension MovieListViewModelImpl {
    enum ViewInteractivity {
        case updateMovieList
    }
}


// MARK: TableView DataSource
extension MovieListViewModelImpl {
    func getNumberOfRowsInSection() -> Int {
        return self.movieList.count
    }
    
    func getMovieForCell(at indexPath: IndexPath) -> [Movie]? {
        guard let movie = self.movieList as [Movie]? else {return nil}
        return movie
    }
    
}
