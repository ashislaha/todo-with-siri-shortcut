//
//  ViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit
import IntentsUI

class HistoryViewController: UITableViewController {

	
	// public method
	public func showNewCreatedTaskView(intent: TODOIntent) {
		_ = TaskCompletedViewController(for: intent)
	}
	
	
	// MARK:- View Controller life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		//completedView.vi
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
		userActivity?.userInfo = ["key":"value"]
		userActivity?.suggestedInvocationPhrase = "show me the tasks to do"
		userActivity?.becomeCurrent()
	}
	
	private func addSiriShortCutButtonIfNeeded(task: Task, cell: UITableViewCell) {
		
		guard task.primary != .none else {
			cell.accessoryView = nil
			return
		}
		
		let addToSiriButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
		addToSiriButton.shortcut = INShortcut(intent: task.intent)
		addToSiriButton.delegate = self
		addToSiriButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
		cell.accessoryView = addToSiriButton
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
		addSiriShortCutButtonIfNeeded(task: task, cell: cell)
		return cell
	}
}

// UITableViewDelegate
extension HistoryViewController {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath)
	}
}


// MARK:- INUIAddVoiceShortcutButtonDelegate
extension HistoryViewController: INUIAddVoiceShortcutButtonDelegate {
	func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		
		addVoiceShortcutViewController.delegate = self
		present(addVoiceShortcutViewController, animated: true, completion: nil)
	}
	
	func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		
		editVoiceShortcutViewController.delegate = self
		present(editVoiceShortcutViewController, animated: true, completion: nil)
	}
}

// MARK:- INUIAddVoiceShortcutViewControllerDelegate
extension HistoryViewController: INUIAddVoiceShortcutViewControllerDelegate {
	func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
	
	func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
		controller.dismiss(animated: true, completion: nil)
	}
}


// MARK:- INUIEditVoiceShortcutViewControllerDelegate
extension HistoryViewController: INUIEditVoiceShortcutViewControllerDelegate {
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
		
	}
	
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
		
	}
	
	func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
		
	}
}


