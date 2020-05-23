//
//  ViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.tableFooterView = UIView()
		
	}
	@IBAction func tapNewTask(_ sender: UIBarButtonItem) {
		print("create a new task")
	}
}

// UITableViewDataSource
extension HistoryViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = "\(indexPath.row)"
		return cell
	}
}

// UITableViewDelegate
extension HistoryViewController {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath)
	}
}

