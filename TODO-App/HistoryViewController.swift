//
//  ViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit

class HistoryViewController: UITableViewController {

	// MARK:- View Controller life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		tableView.tableFooterView = UIView()
		activateActivity()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}
	
	// MARK:- Actions
	@IBAction func tapNewTask(_ sender: UIBarButtonItem) {
		print("create a new task")
	}
}
//function for donating shortcut
extension HistoryViewController {
	
	func activateActivity() {
		userActivity = NSUserActivity(activityType: "com.myapp.name.todo-task-activity")
		userActivity?.isEligibleForSearch=true
		userActivity?.isEligibleForPrediction=true
		userActivity?.title = "Task History"
		userActivity?.userInfo=["key":"value"]
		userActivity?.suggestedInvocationPhrase="show me the tasks to do"
		userActivity?.becomeCurrent()
	}
}
// UITableViewDataSource
extension HistoryViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return TaskManager.shared.tasks.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		let task = TaskManager.shared.tasks[indexPath.row]
		cell.textLabel?.text = "Task \(indexPath.row + 1): \(task.primaryTaskDescription)"
		cell.detailTextLabel?.text = task.secondaryTaskDescription
		return cell
	}
}

// UITableViewDelegate
extension HistoryViewController {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath)
	}
}

