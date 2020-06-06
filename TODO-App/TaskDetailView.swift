//
//  TaskDetailView.swift
//  TODO-App
//
//  Created by Ashis Laha on 05/06/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit
import TODOKit

protocol TaskDetailViewDelegate: class {
	func doneButtonTapped()
}

class TaskDetailView: UIView {
	
	public weak var delegate: TaskDetailViewDelegate?
	
	public var task: Task? {
		didSet {
			primaryTaskLabel.text = "Created Task"
			secondaryTaskLabel.text = (task?.primaryTaskDescription ?? "") + " - " + (task?.secondaryTaskDescription ?? "")
		}
	}
	
	// primary task label
	private let primaryTaskLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.contentMode = .center
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		return label
	}()
	
	// secondary task label
	private let secondaryTaskLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.contentMode = .center
		label.font = UIFont.preferredFont(forTextStyle: .body)
		return label
	}()
	
	// acknowledgement button
	private let okayButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = UIColor.purple
		button.layer.cornerRadius = 10
		button.layer.masksToBounds = true
		button.setTitle("Done", for: .normal)
		return button
	}()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		viewSetup()
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		viewSetup()
	}
	
	private func viewSetup() {
		
		backgroundColor = UIColor(red: 230.0/255.0, green: 126.0/255.0, blue: 34.0/255.0, alpha: 1)
		layer.masksToBounds = true
		layer.cornerRadius = 10
		okayButton.addTarget(self, action: #selector(okayTapped), for: .touchUpInside)
		
		[primaryTaskLabel, secondaryTaskLabel, okayButton].forEach { addSubview($0) }
		NSLayoutConstraint.activate([
			
			primaryTaskLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
			primaryTaskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
			primaryTaskLabel.bottomAnchor.constraint(equalTo: secondaryTaskLabel.topAnchor, constant: -16),
			primaryTaskLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
			
			secondaryTaskLabel.leadingAnchor.constraint(equalTo: primaryTaskLabel.leadingAnchor),
			secondaryTaskLabel.trailingAnchor.constraint(equalTo: secondaryTaskLabel.trailingAnchor),
			secondaryTaskLabel.bottomAnchor.constraint(equalTo: okayButton.topAnchor, constant: -32),
			
			okayButton.leadingAnchor.constraint(equalTo: primaryTaskLabel.leadingAnchor),
			okayButton.trailingAnchor.constraint(equalTo: primaryTaskLabel.trailingAnchor),
			okayButton.heightAnchor.constraint(equalToConstant: 44),
			okayButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
		])
	}
	
	@objc func okayTapped() {
		delegate?.doneButtonTapped()
	}
}
