//: Playground - noun: a place where people can play

import UIKit

struct Person { // Model
	let firstName: String
	let lastName: String
}

protocol GreetingViewProtocol: class {
	func setGreeting(greeting: String)
}

// Decouple view and model
protocol GreetingViewPresenterProtocol {
	init(view: GreetingViewProtocol, person: Person)
	func showGreeting()
}

// Data Binding view and model
class GreetingPresenter : GreetingViewPresenterProtocol {
	let view: GreetingViewProtocol
	let person: Person
	required init(view: GreetingViewProtocol, person: Person) {
		self.view = view
		self.person = person
	}
	func showGreeting() {
		let greeting = "Hello" + " " + self.person.firstName + " " + self.person.lastName
		self.view.setGreeting(greeting: greeting)
	}
}

class GreetingViewController : UIViewController, GreetingViewProtocol {
	
	var presenter: GreetingViewPresenterProtocol!
	
	let showGreetingButton = UIButton()
	let greetingLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showGreetingButton.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
	}
	
	@objc func didTapButton(button: UIButton) {
		self.presenter.showGreeting()
	}
	
	// MARK: - GreetingViewProtocol method
	
	func setGreeting(greeting: String) {
		self.greetingLabel.text = greeting
	}
	
	// layout code goes here
}

// Assembling of MVP
let model = Person(firstName: "Kevin", lastName: "Durant")
let vc = GreetingViewController()
let presenter = GreetingPresenter(view: vc, person: model)
vc.presenter = presenter
