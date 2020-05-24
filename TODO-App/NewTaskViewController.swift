//
//  NewTaskViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit

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
	
	private var currentSubTask: SecondaryTaskType = .none
	
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
	
	// MARK:- ViewController life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	// MARK:- Actions
	@IBAction func tapChooseTask(_ sender: UIButton) {
		
		let primaryTypes: [PrimaryTaskType] = [.listening, .playing, .studying, .coding]
		showActionSheet(taskType: .primary, primaryTypes: primaryTypes)
	}
	
	@IBAction func tapSubTask(_ sender: UIButton) {
		guard currentTask != .none else { return }
		
		switch currentTask.mappedToSubTask() {
		case .none: break
		case .albums(let colletion): showActionSheet(taskType: .secondary, secondaryOptions: colletion)
		case .books(let names): showActionSheet(taskType: .secondary, secondaryOptions: names)
		case .coding(let languages): showActionSheet(taskType: .secondary, secondaryOptions: languages)
		case .games(let list): showActionSheet(taskType: .secondary, secondaryOptions: list)
		}
	}
	
	@IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
		
		guard let primaryDescription = taskTypeResult.text, !primaryDescription.isEmpty,
			let secondaryDescription = secondaryTaskTypeResult.text, !secondaryDescription.isEmpty
			else {
				return
		}
		
		// create a new task with primary task, secondary task and date & time
		let task = Task(primaryDescription: primaryDescription,
						secondaryDescription: secondaryDescription,
						createdTime: Date(),
						performTime: Date()) // will update later -- should be user input
		TaskManager.shared.addTask(task: task)
		navigationController?.popViewController(animated: true)
	}
	
	private func showActionSheet(taskType: TaskType, primaryTypes: [PrimaryTaskType] = [], secondaryOptions: [String] = []) {
		
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
				let alertAction = UIAlertAction(title: each, style: .default) { (action) in
					self.secondaryTaskTypeResult.isHidden = false
					self.secondaryTaskTypeResult.text = each
				}
				alertController.addAction(alertAction)
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
}

