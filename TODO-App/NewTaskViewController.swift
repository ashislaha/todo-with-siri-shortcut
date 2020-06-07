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
			subTaskButtonOutlet.setTitle(currentTask.getSubTaskTitle(), for: .normal)
		}
	}
	
	private var secondaryTask: SecondaryTaskType?
	private var timePicker: UIDatePicker!
	private var chooseTime: Date?
	
	// MARK:- Outlets
	
	@IBOutlet weak var taskButtonOutlet: UIButton! {
		didSet {
			taskButtonOutlet.layer.masksToBounds = true
			taskButtonOutlet.layer.cornerRadius = 10
		}
	}
	@IBOutlet weak var taskTypeResult: UILabel! {
		didSet {
			taskTypeResult.text = ""
		}
	}
	
	@IBOutlet weak var subTaskButtonOutlet: UIButton! {
		didSet {
			subTaskButtonOutlet.layer.masksToBounds = true
			subTaskButtonOutlet.layer.cornerRadius = 10
		}
	}
	@IBOutlet weak var secondaryTaskTypeResult: UILabel! {
		didSet {
			secondaryTaskTypeResult.text = ""
		}
	}

	
	@IBOutlet weak var chooseTimeOutlet: UIButton! {
		didSet {
			chooseTimeOutlet.layer.masksToBounds = true
			chooseTimeOutlet.layer.cornerRadius = 10
		}
	}
	@IBOutlet weak var timeLabel: UILabel! {
		didSet {
			timeLabel.text = ""
		}
	}
	
	
	// MARK:- Actions
	@IBAction func tapChooseTask(_ sender: UIButton) {
		showActionSheet(taskType: .primary, primaryTypes: TaskManager.shared.taskList)
	}
	
	@IBAction func tapSubTask(_ sender: UIButton) {
		
		guard currentTask != PrimaryTaskType.none else {
			self.showAlert(title: "Choose Primary First")
			return
		}
		
		switch currentTask {
		case .coding(let languages): showActionSheet(taskType: .secondary, secondaryOptions: languages)
		case .listening(let albums): showActionSheet(taskType: .secondary, secondaryOptions: albums)
		case .playing(let games): showActionSheet(taskType: .secondary, secondaryOptions: games)
		case .studying(let authors): showActionSheet(taskType: .secondary, secondaryOptions: authors)
		default: break
		}
	}
	
	@IBAction func tapChooseTime(_ sender: UIButton) {
		
		guard currentTask != PrimaryTaskType.none else {
			self.showAlert(title: "Choose Primary Task first")
			return
		}
		
		let height: CGFloat = 200
		timePicker = UIDatePicker(frame: CGRect(x: view.frame.midX - 100, y: view.frame.maxY - height, width: view.frame.size.width - 200, height: height))
		timePicker.layer.masksToBounds = true
		timePicker.layer.cornerRadius = 20
		timePicker.datePickerMode = .time
		timePicker.backgroundColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0) // https://flatuicolors.com/palette/defo
		view.addSubview(timePicker)
		timePicker.addTarget(self, action: #selector(saveTime), for: .valueChanged)
	}
	
	@objc func saveTime() {
		guard let timePicker = timePicker else { return }
		
		chooseTime = timePicker.date
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		timeLabel.text = formatter.string(from: timePicker.date)
		timePicker.removeFromSuperview()
	}
	
	@IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
		
		guard currentTask != .none else {
			self.showAlert(title: "Choose Primary Task first")
			return
		}
			
		guard let secondary = secondaryTask else {
			self.showAlert(title: "Choose Secondary Task")
			return
		}
		
		guard let chooseTime = chooseTime else {
			self.showAlert(title: "Choose a time")
			return
		}
		
		// create a new task with primary task, secondary task and date & time
		let task = Task(primary: currentTask,
						secondary: secondary,
						createTime: Date(),
						performTime: chooseTime,
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
	
	private func showAlert(title: String) {
		let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
			alertController.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(okayAction)
		self.present(alertController, animated: true, completion: nil)
	}
}

