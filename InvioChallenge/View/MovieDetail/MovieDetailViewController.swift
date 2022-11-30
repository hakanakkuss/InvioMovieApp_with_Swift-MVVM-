//
//  MovieDetailViewController.swift
//  InvioChallenge
//
//  Created by Macbook Pro on 25.11.2022.
//

import UIKit
import Kingfisher

class MovieDetailViewController: BaseViewController {
    
    private var viewModel : MovieDetailViewModel!
    private var detail: MovieDetail?
    var movieID: String = "" 

    @IBOutlet weak var movieImageView: UIImageView!

    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var plotSubLabel: UILabel!
    
    
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var directorSubLabel: UILabel!
    
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var writerSubLabel: UILabel!
    
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var actorsSubLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countrySubLabel: UILabel!
    
    
    @IBOutlet weak var boxOfficeLabel: UILabel!
    @IBOutlet weak var boxOfficeSubLabel: UILabel!
    

    override func viewDidLoad() {
    
        super.viewDidLoad()
      
        addObservationListener()
        viewModel.start()
        setFont()
        viewModel.getMovieDetail(id: movieID)

 
    }
    
    @objc func favoriteIcon(){
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "like-fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        }

    @objc func backIcon(){
            goBack()
        }
    
    func inject(viewModel:MovieDetailViewModel){
        self.viewModel = viewModel
    }
    
    func setFont(){
        movieDurationLabel.font = .roboto(.Medium, size: 16)
        movieYearLabel.font = .roboto(.Medium, size: 16)
        movieLanguageLabel.font = .roboto(.Medium, size: 16)
        movieRatingLabel.font = .roboto(.Medium, size: 16)
        
        plotLabel.font = .roboto(.Medium, size: 16)
        plotSubLabel.font = .roboto(.Medium, size: 12)
        plotLabel.textColor = .softBlack
        
        directorLabel.font = .roboto(.Medium, size: 16)
        directorSubLabel.font = .roboto(.Medium, size: 12)
        directorLabel.textColor = .softBlack
        
        writerLabel.font = .roboto(.Medium, size: 16)
        writerSubLabel.font = .roboto(.Medium, size: 12)
        writerLabel.textColor = .softBlack
        
        actorsLabel.font = .roboto(.Medium, size: 16)
        actorsSubLabel.font = .roboto(.Medium, size: 12)
        actorsLabel.textColor = .softBlack
        
        countryLabel.font = .roboto(.Medium, size: 16)
        countrySubLabel.font = .roboto(.Medium, size: 12)
        countryLabel.textColor = .softBlack
        
        boxOfficeLabel.font = .roboto(.Medium, size: 16)
        boxOfficeSubLabel.font = .roboto(.Medium, size: 12)
        boxOfficeLabel.textColor = .softBlack
    }
    
    @objc func sendDetailMovie(_ notification: NSNotification){
        let sendNotification = (notification.userInfo as! [String: MovieDetail]) ["detail"]
        
        
        setupNavBar(title: sendNotification?.title, leftIcon: "left-arrow", rightIcon: "like-empty", leftItemAction: #selector(backIcon), rightItemAction: #selector(favoriteIcon))
        
        movieDurationLabel.text = sendNotification?.runTime
        movieLanguageLabel.text = sendNotification?.language
        movieRatingLabel.text = sendNotification?.ratings
        movieYearLabel.text = sendNotification?.year
        
        if let url = URL(string: (sendNotification?.poster)!){  
                    DispatchQueue.main.async {
                        self.movieImageView.kf.setImage(with: url)
                    }
                }
        
        plotLabel.text = sendNotification?.plot
        directorLabel.text = sendNotification?.director
        writerLabel.text = sendNotification?.writer
        actorsLabel.text = sendNotification?.actors
        countryLabel.text = sendNotification?.country
        boxOfficeLabel.text = sendNotification?.boxOffice
    }

}

extension MovieDetailViewController {
    func addObservationListener() {
        self.viewModel.stateClosure = { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleClosureData(data: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func handleClosureData(data: MovieDetailViewModelImpl.ViewInteractivity) {
        switch data {
        case .updateMovieDetail:
            NotificationCenter.default.addObserver(self, selector: #selector(self.sendDetailMovie), name: .init(rawValue: "sendDetail"), object: nil)
        }
    }
}
