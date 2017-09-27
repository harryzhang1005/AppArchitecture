//: Playground - noun: a place where people can play

import UIKit

struct Person { // Model
	let firstName: String
	let lastName: String
}

protocol GreetingViewModelProtocol: class {
	var greeting: String? { get }
	var greetingDidChange: ((GreetingViewModelProtocol) -> Void)? { get set }	// callback
	
	init(person: Person)
	func showGreeting()
}

class GreetingViewModel: GreetingViewModelProtocol {
	let person: Person
	
	// MARK: - GreetingViewModelProtocol
	var greeting: String? {
		didSet {
			self.greetingDidChange?(self)
		}
	}
	
	var greetingDidChange: ((GreetingViewModelProtocol) -> Void)?
	
	required init(person: Person) {
		self.person = person
	}
	
	@objc func showGreeting() {
		self.greeting = "Hello" + " " + self.person.firstName + " " + self.person.lastName
	}
}

class GreetingViewController : UIViewController {
	
	var viewModel: GreetingViewModelProtocol! {
		didSet {	// set up bindings
			self.viewModel.greetingDidChange = { [unowned self] vm in
				self.greetingLabel.text = vm.greeting
			}
		}
	}
	
	let showGreetingButton = UIButton()
	let greetingLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		showGreetingButton.addTarget(self.viewModel, action: #selector(GreetingViewModel.showGreeting), for: .touchUpInside)
	}
	
	// layout code goes here
}

// Assembling of MVVM
let model = Person(firstName: "Kevin", lastName: "Durant")
let viewModel = GreetingViewModel(person: model)
let vc = GreetingViewController()
vc.viewModel = viewModel
