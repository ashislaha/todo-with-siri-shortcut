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
import Intents

class HistoryViewController: UITableViewController {

	private let taskDetailView: TaskDetailView = {
		let view = TaskDetailView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// MARK:- View Controller life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = 100
		tableView.tableFooterView = UIView()
		activateActivity()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}
	
	/// restore activity state
	/// this method is getting called when AppDelegate restores the viewcontroller -- worked for single window system
	/// func application(_ application:  continue userActivity: , restorationHandler) -- restorationHandler(controllers)
	override func restoreUserActivityState(_ activity: NSUserActivity) {
		super.restoreUserActivityState(activity)
		
		if activity.activityType == Constants.UserActivity.createTaskByIntent {
			
			guard let intent = activity.interaction?.intent as? TODOIntent,
				let task = Task.createTask(from: intent) else { return }
			
			TaskManager.shared.addTask(task: task)
			showTask(task: task)
			
		} else if activity.activityType == Constants.UserActivity.taskHistoryType {
			tableView.reloadData()
		}
	}
	
}
//function for donating shortcut
extension HistoryViewController {
	
	func activateActivity() {
		userActivity = NSUserActivity(activityType: Constants.UserActivity.createTaskByUserActivity)
		userActivity?.persistentIdentifier = Constants.UserActivity.createIdentifier
		userActivity?.isEligibleForSearch = true
		userActivity?.isEligibleForPrediction = true
		userActivity?.title = "Create a Task"
		userActivity?.userInfo = ["create": true]
		userActivity?.suggestedInvocationPhrase = "Create a Task"
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
		addToSiriButton.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
		cell.accessoryView = addToSiriButton
	}
	
	public func showTask(task: Task) {
		
		taskDetailView.delegate = self
		taskDetailView.task = task
		
		view.addSubview(taskDetailView)
		NSLayoutConstraint.activate([
			taskDetailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			taskDetailView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
			taskDetailView.widthAnchor.constraint(equalToConstant: view.frame.size.width-100)
		])
	}
	
	public func gotoNewTaskPage() {
		performSegue(withIdentifier: "newTask", sender: nil)
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
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TaskTableViewCell else {
			return UITableViewCell()
		}
		
		let task = TaskManager.shared.tasks[indexPath.row]
		cell.updateView(task: task)
		addSiriShortCutButtonIfNeeded(task: task, cell: cell)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		guard editingStyle == .delete else { return }
		
		// let's delete an existing task
		let task = TaskManager.shared.tasks[indexPath.row]
		
		TaskManager.shared.tasks.remove(at: indexPath.row)
		tableView.reloadData()
		TaskManager.shared.saveTasksToFileSystem()
		
		// delete the donation in parallel
		if let identifier = task.intent.identifier {
			INInteraction.delete(with: identifier) { (error) in
				if error != nil {
					print("failed to delete the interactions with error \(error?.localizedDescription ?? "")")
				}
			}
		}
	}
}

// UITableViewDelegate
extension HistoryViewController {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let task = TaskManager.shared.tasks[indexPath.row]
		showTask(task: task)
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
		controller.dismiss(animated: true, completion: nil)
	}
	
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
		controller.dismiss(animated: true, completion: nil)
	}
	
	func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
		controller.dismiss(animated: true, completion: nil)
	}
}

// MARK:- TaskDetailViewDelegate
extension HistoryViewController: TaskDetailViewDelegate {
	func doneButtonTapped() {
		tableView.reloadData()
		taskDetailView.removeFromSuperview()
	}
}

