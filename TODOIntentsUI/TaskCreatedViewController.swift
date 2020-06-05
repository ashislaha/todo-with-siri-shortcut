//
//  TaskCreatedViewController.swift
//  TODOIntentsUI
//
//  Created by Ashis Laha on 05/06/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit
import Intents

class TaskCreatedViewController: UIViewController {

	private let intent: TODOIntent
	private let response: TODOIntentResponse
	
	@IBOutlet var createdView: TaskCreatedView!
	
	init(for intent: TODOIntent, with response: TODOIntentResponse) {
		self.intent = intent
		self.response = response
		super.init(nibName: "TaskCreatedView", bundle: Bundle(for: TaskCreatedViewController.self))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		createdView = view as? TaskCreatedView
		
		// configure the view
		if let task = Task.createTask(from: intent) {
			let primary = task.primary
			switch primary {
			case .coding(_):
				createdView.imageView.image = UIImage(named: "coding")
				createdView.message.text = "Created a Coding task with \(task.secondary.getTitle()) language"
			case .listening(_):
				createdView.imageView.image = UIImage(named: "listening")
				createdView.message.text = "Created a Listening task of \(task.secondary.getTitle())"
			case .playing(_):
				createdView.imageView.image = UIImage(named: "game")
				createdView.message.text = "Task Created for playing \(task.secondary.getTitle()) game"
			case .studying(_):
				createdView.imageView.image = UIImage(named: "studying")
				createdView.message.text = "Task Created for studying of author \(task.secondary.getTitle())"
			default:
				break
			}
		}
    }

}

class TaskCreatedView: UIView {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var message: UILabel!
	
}
