//
//  SearchVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 12/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyPeasy

class SearchVC: UIViewController {
    let searchTF = UITextField()
    let searchView = SearchView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Search"
        navigationItem.titleView = searchTF
        
        searchTF <- Width(200)
        
        _ = searchTF.rx
            .controlEvent(.editingChanged)
            .asObservable()
            .throttle(0.8, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] term in
                guard let `self` = self, let term = `self`.searchTF.text else { return }
                `self`.search(withTerm: term)
            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.addSubview(searchView)
        searchView <- [
            Top().to(topLayoutGuide),
            Leading(),
            CenterX(),
            Bottom()
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.filmTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        searchView.userTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        _ = searchView.segmentedControl.rx.controlEvent(.valueChanged).map {
            return self.searchView.segmentedControl.selectedSegmentIndex == 0
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { showFilms in
            self.searchView.filmTableView.isHidden = !showFilms
        })
    }
    
    func search(withTerm term: String) {
        _ = Search(term: term).call()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { results in
            _ = Observable.just(results.films)
                .bindTo(self.searchView.filmTableView.rx.items(cellIdentifier: "Cell")) { _, film, cell in
                    cell.textLabel?.text = film.title
            }
            _ = Observable.just(results.users)
                .bindTo(self.searchView.userTableView.rx.items(cellIdentifier: "Cell")) { _, user, cell in
                    cell.textLabel?.text = user.username.value
            }
        })
    }
}