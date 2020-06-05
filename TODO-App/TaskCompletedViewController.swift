//
//  TaskCompletedViewController.swift
//  TODO-App
//
//  Created by Ashis Laha on 05/06/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit
import Intents

class TaskCompletedViewController: UIViewController {
	private let intent: TODOIntent
	@IBOutlet var completedView: TaskCompletedView!
	
	init(for intent: TODOIntent)
	{
		self.intent = intent
		super.init(nibName: "Taskcompletedview", bundle: Bundle(for: TaskCompletedViewController.self))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		completedView = view as? TaskCompletedView
		
		if let task = Task.createTask(from: intent){
			completedView.primaryTask.text = task.primary.getTitle()
			completedView.secondaryTask.text=task.primary.getSubTaskTitle()
			
			
		}
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class TaskCompletedView : UIView {
	
	@IBOutlet weak var primaryTask: UILabel!
	
	@IBOutlet weak var secondaryTask: UILabel!
}
