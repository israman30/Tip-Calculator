//
//  PresntTipViewController.swift
//  TipCalc
//
//  Created by Israel Manzo on 3/1/25.
//  Copyright © 2025 Israel Manzo. All rights reserved.
//
import UIKit

class PresentingTipViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        view.addSubViews(topView, tableView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, size: .init(width: 0, height: 60))
        tableView.anchor(top: topView.bottomAnchor, left: topView.leftAnchor, bottom: view.bottomAnchor, right: topView.rightAnchor)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
