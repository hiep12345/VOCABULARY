//
//  ListNewWordController.swift
//  VOCABULARY
//
//  Created by MAC on 6/8/18.
//  Copyright © 2018 lehiep. All rights reserved.
//

import UIKit

class ListNewWordsController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK: VARIABLE
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "Cell"
    let itemRepository = ItemsRepository.shared
    var itemCards:[ItemCard] = []
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: LIFE CYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupView()
    }
    
    //MARK: OTHER FUNCTION
    
    func setupView(){
    }
    
    func setupData(){
        self.tableView.dataSource = self
        self.tableView.delegate   = self
    }
    
    //MARK:UITABLEVIEW DATASOURCE, DELEGATE
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListNewWordCell
        cell.word.text = itemCards[indexPath.row].word
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "today"
    }
}
