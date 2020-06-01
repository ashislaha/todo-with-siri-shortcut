//
//  NewTaskViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit
import IntentsUI

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
	@IBOutlet weak var addToSiriView: UIView!
	
	// MARK:- ViewController life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
		
		addSiriShortCutButton()
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
		let task = Task(primaryDesc: primaryDescription,
						secondaryDesc: secondaryDescription,
						createTime: Date(),
						performTime: Date())
		TaskManager.shared.addTask(task: task)
		
		//Donate an interaction to the system
			let interaction=INInteraction(intent: task.intent, response: nil)
			interaction.donate{ (error) in
				if let error=error{
					print("Did Fail: \(error.localizedDescription)")
				}
			}
			
			navigationController?.popViewController(animated: true)
		}
	// MARK:- Private methods
	
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
	
	private func addSiriShortCutButton() {
		
		let task = Task(primaryDesc: "none",
						secondaryDesc: "none",
						createTime: Date(),
						performTime: Date())
		let addToSiriButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
		addToSiriButton.shortcut = INShortcut(intent: task.intent)
		addToSiriButton.delegate = self
		
		addToSiriButton.translatesAutoresizingMaskIntoConstraints = false
		addToSiriView.addSubview(addToSiriButton)
		NSLayoutConstraint.activate([
			addToSiriButton.centerXAnchor.constraint(equalTo: addToSiriView.centerXAnchor),
			addToSiriButton.centerYAnchor.constraint(equalTo: addToSiriView.centerYAnchor)
		])
	}
}

// MARK:- INUIAddVoiceShortcutButtonDelegate
extension NewTaskViewController: INUIAddVoiceShortcutButtonDelegate {
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
extension NewTaskViewController: INUIAddVoiceShortcutViewControllerDelegate {
	func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
		
	}
	
	func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
		
	}
}


// MARK:- INUIEditVoiceShortcutViewControllerDelegate
extension NewTaskViewController: INUIEditVoiceShortcutViewControllerDelegate {
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
		
	}
	
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
		
	}
	
	func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
		
	}
}
