//: Playground - noun: a place where people can play

import UIKit

struct Person { // Entity (usually more complex e.g. NSManagedObject)
	let firstName: String
	let lastName: String
}

struct GreetingData { // Transport data structure (not Entity)
	let greeting: String
	let subject: String
}

protocol GreetingProvider {
	func provideGreetingData()
}

protocol GreetingOutput: class {
	func receiveGreetingData(greetingData: GreetingData)
}

class GreetingInteractor : GreetingProvider {
	weak var output: GreetingOutput!
	
	// MARK: - GreetingProvider
	func provideGreetingData() {
		let person = Person(firstName: "Kevin", lastName: "Durant") // usually comes from data access layer
		let subject = person.firstName + " " + person.lastName
		let greeting = GreetingData(greeting: "Hello", subject: subject)
		self.output.receiveGreetingData(greetingData: greeting)
	}
}

protocol GreetingViewEventHandler {
	func didTapShowGreetingButton()
}

protocol GreetingView: class {
	func setGreeting(greeting: String)
}

class GreetingPresenter : GreetingOutput, GreetingViewEventHandler {
	weak var view: GreetingView!
	var greetingProvider: GreetingProvider!
	
	// MARK: - GreetingViewEventHandler
	func didTapShowGreetingButton() {
		self.greetingProvider.provideGreetingData()
	}
	
	// MARK: - GreetingOutput
	func receiveGreetingData(greetingData: GreetingData) {
		let greeting = greetingData.greeting + " " + greetingData.subject
		self.view.setGreeting(greeting: greeting)
	}
}

class GreetingViewController : UIViewController, GreetingView {
	
	var eventHandler: GreetingViewEventHandler!
	
	let showGreetingButton = UIButton()
	let greetingLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showGreetingButton.addTarget(self, action: #selector(didTapButton(button:)), for: .touchUpInside)
	}
	
	@objc func didTapButton(button: UIButton) {
		self.eventHandler.didTapShowGreetingButton()
	}
	
	// MARK: - GreetingView
	func setGreeting(greeting: String) {
		self.greetingLabel.text = greeting
	}
	
	// layout code goes here
}

// Assembling of VIPER module, without Router
let view = GreetingViewController()
let presenter = GreetingPresenter()
let interactor = GreetingInteractor()
view.eventHandler = presenter
presenter.view = view
presenter.greetingProvider = interactor
interactor.output = presenter
