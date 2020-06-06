//
//  NewTaskViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit
import Intents

class NewTaskViewController: UIViewController {

	// MARK:- Private variables
	private var currentTask: PrimaryTaskType = .none {
		didSet {
			taskTypeResult?.text = currentTask.getTitle()
			
			secondaryTaskTypeResult?.isHidden = true
			subTaskButtonOutlet.isHidden = false
			subTaskButtonOutlet.setTitle(currentTask.getSubTaskTitle(), for: .normal)
		}
	}
	
	private var secondaryTask: SecondaryTaskType?
	
	// MARK:- Outlets
	@IBOutlet weak var taskTypeResult: UILabel!
	@IBOutlet weak var subTaskButtonOutlet: UIButton! {
		didSet {
			subTaskButtonOutlet.isHidden = true
		}
	}
	@IBOutlet weak var secondaryTaskTypeResult: UILabel! {
		didSet {
			secondaryTaskTypeResult.isHidden = true
		}
	}
	@IBOutlet weak var addToSiriView: UIView!
	
	
	// MARK:- Actions
	@IBAction func tapChooseTask(_ sender: UIButton) {
		showActionSheet(taskType: .primary, primaryTypes: TaskManager.shared.taskList)
	}
	
	@IBAction func tapSubTask(_ sender: UIButton) {
		
		guard currentTask != PrimaryTaskType.none else { return }
		
		switch currentTask {
		case .coding(let languages): showActionSheet(taskType: .secondary, secondaryOptions: languages)
		case .listening(let albums): showActionSheet(taskType: .secondary, secondaryOptions: albums)
		case .playing(let games): showActionSheet(taskType: .secondary, secondaryOptions: games)
		case .studying(let authors): showActionSheet(taskType: .secondary, secondaryOptions: authors)
		default: break
		}
	}
	
	@IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
		
		guard currentTask != .none, let secondary = secondaryTask else { return }
		
		// create a new task with primary task, secondary task and date & time
		let task = Task(primary: currentTask,
						secondary: secondary,
						createTime: Date(),
						performTime: Date(),
						primaryDescription: currentTask.getTitle(),
						secondaryDescription: secondary.getTitle())
		
		TaskManager.shared.addTask(task: task)
		
		// Donate an interaction to the system
		let interaction = INInteraction(intent: task.intent, response: nil)
		interaction.donate { (error) in
			if let error = error {
				print("failed to donate: \(error.localizedDescription)")
			}
		}
		navigationController?.popViewController(animated: true)
	}
	
	// MARK:- Private methods
	
	private func showActionSheet(taskType: TaskType, primaryTypes: [PrimaryTaskType] = [], secondaryOptions: [SecondaryTaskType] = []) {
		
		let title = taskType == .primary ? "Choose a task": "Choose a sub-task"
		let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
		
		if taskType == .primary {
			
			for primaryTask in primaryTypes {
				let actionTitle = primaryTask.getTitle()
				let alertAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
					self.currentTask = primaryTask
				}
				alertController.addAction(alertAction)
			}
			
		} else { // secondary
			
			for each in secondaryOptions {
				let alertAction = UIAlertAction(title: each.getTitle(), style: .default) { (action) in
					self.secondaryTaskTypeResult.isHidden = false
					self.secondaryTaskTypeResult.text = each.getTitle()
					self.secondaryTask = each
				}
				alertController.addAction(alertAction)
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
}

