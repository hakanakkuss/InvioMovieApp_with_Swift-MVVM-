//
//  MovieDetailViewModel.swift
//  InvioChallenge
//
//  Created by Macbook Pro on 25.11.2022.
//

import Foundation
import Alamofire

protocol MovieDetailViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
   
    var stateClosure: ((Result<MovieDetailViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }

    func getMovieDetail(id:String)
   
}

final class MovieDetailViewModelImpl: MovieDetailViewModel {
  
    var detayID:MovieDetail?

    func getMovieDetail(id:String) {
        AF.request("http://www.omdbapi.com/?i=\(id)&apikey=9b9e85e6",method: .get).response { response in
            if let data = response.data{
                do{
                    let searchResult = try JSONDecoder().decode(MovieDetail.self, from: data)
                   
                    //burada detay nesnesi oluşturucaksın nesnenin içine verileri alcaksın.
                    
                    self.detayID = searchResult
                    print(self.detayID!)
                    
                    DispatchQueue.main.async {
                        let sendToDetail: [String:MovieDetail] = ["detail": self.detayID!]
                        NotificationCenter.default.post(name: .init(rawValue: "sendDetail"), object: nil, userInfo: sendToDetail as [AnyHashable:Any])
                    }
                    self.start()
                   
                }catch{
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    

    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?

    func start() {
        self.stateClosure?(.success(.updateMovieDetail))
    }
}

// MARK: ViewModel to ViewController interactivity
extension MovieDetailViewModelImpl {
    enum ViewInteractivity {
        case updateMovieDetail
    }
}

