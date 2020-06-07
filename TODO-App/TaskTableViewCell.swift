//
//  TaskTableViewCell.swift
//  TODO-App
//
//  Created by Ashis Laha on 07/06/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit

class TaskTableViewCell: UITableViewCell {

	@IBOutlet weak var taskImageView: UIImageView!
	
	@IBOutlet weak var primaryTaskLabel: UILabel!
	
	@IBOutlet weak var secondaryTaskLabel: UILabel!
	
	@IBOutlet weak var taskPerformTimeLabel: UILabel!
	
	public func updateView(task: Task) {
		
		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .short
		dateFormatter.dateStyle = .short
		let dateString = dateFormatter.string(from: task.performTime)
		
		switch task.primary {
		case .coding(_): taskImageView.image = UIImage(named: "coding")
		case .listening(_): taskImageView.image = UIImage(named: "listening")
		case .playing(_): taskImageView.image = UIImage(named: "game")
		case .studying(_): taskImageView.image = UIImage(named: "studying")
		default: taskImageView.image = UIImage(named: "task")
		}
		
		primaryTaskLabel.text = task.primaryTaskDescription
		secondaryTaskLabel.text = task.secondaryTaskDescription
		taskPerformTimeLabel.text = dateString		
	}
}
