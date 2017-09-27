//: Playground - noun: a place where people can play

import UIKit

struct Person { // Model
	let firstName: String
	let lastName: String
}

class GreetingViewController : UIViewController { // View + Controller, are tightly coupled
	
	var person: Person!
	
	let showGreetingButton = UIButton()
	let greetingLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showGreetingButton.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
	}
	
	@objc func didTapButton(button: UIButton) {
		let greeting = "Hello" + " " + self.person.firstName + " " + self.person.lastName
		self.greetingLabel.text = greeting
	}
	
	// layout code goes here
}

// Assembling of MVC
let model = Person(firstName: "Kevin", lastName: "Durant")
let vc = GreetingViewController()
vc.person = model;
