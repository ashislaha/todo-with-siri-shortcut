//
//  NewTaskViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 23/05/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit

enum TaskType {
	case none
	case listening
	case playing
	case studying
	case coding
	
	func getTitle() -> String {
		switch self {
		case .none: return ""
		case .listening: return "Listening"
		case .playing: return "Playing"
		case .studying: return "Studying"
		case .coding: return "Coding"
		}
	}
}

class NewTaskViewController: UIViewController {

	private var currentTask: TaskType = .none {
		didSet {
			taskTypeResult?.text = currentTask.getTitle()
		}
	}
	
	@IBOutlet weak var taskTypeResult: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func tapChooseTask(_ sender: UIButton) {
		
		let alertController = UIAlertController(title: "Choose a task", message: "", preferredStyle: .actionSheet)
		
		let listenAction = UIAlertAction(title: "Listening", style: .default) { (action) in
			self.currentTask = .listening
			// add the task into model
			
		}
		
		let playingAction = UIAlertAction(title: "Playing", style: .default) { (action) in
			self.currentTask = .playing
			// add the task into model
			
		}
		
		let studyAction = UIAlertAction(title: "Studying", style: .default) { (action) in
			self.currentTask = .studying
			// add the task into model
			
		}
		
		let codingAction = UIAlertAction(title: "Coding", style: .default) { (action) in
			self.currentTask = .coding
			// add the task into model
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		
		[listenAction, playingAction, studyAction, codingAction, cancelAction].forEach { alertController.addAction($0) }
		present(alertController, animated: true, completion: nil)
	}
	
}
