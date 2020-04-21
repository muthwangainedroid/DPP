# DPProtocols

Swift Package of DigitalProducts architecture related protocols for modular project design.

# Table of Contents

1. [Purpose](#purpose)
2. [Protocols](#protocols)
   1. [Announceable](#announceable)
   2. [Bindable](#bindable)
   3. [ViewModel](#viewmodel)
   4. [Coordinator](#coordinator)
   5. [FeedbackCoodinator](#feedbackcoordinator)
   5. [Logger](#logger)
   5. [Repository](#repository)
   6. [Storyboardable](#storyboardable)

## <span id="purpose">Purpose</span>
This package was created to facilitate the building of clean, modular iOS applications with a standard and familiar architecture. It has been constructed by using industry best practices as well as the methods found to work best with DigitalProducts clients.

## <span id="protocols">Protocols</span>
_____
### <span id="announceable">Announceable</span>
The `Announceable` protocol is intended to help with making our apps accessible to the visually challenged.
##### Announce
 Allow conforming objects to have a message audibly read if voice over is currently running. Used primarily to announce changes in state.

```Swift
import DPProtocols

final class MyViewController: Announceable {
    ....
    // previous view controller code

    private func toggleSwitchState() {
        let newState = !switch.isOn
        switch.isOn = newState
        let message = "The switch is now \(newState ? "on" ? "off")"

        // Announce the change in state after an half-second delay
        announce(withDelay: 0.5, message: message)
    }

    ....
    // the rest of the view controller code
}
```

_____

### <span id="bindable">Bindable</span>
The `Bindable` protocol provides a standard interface for a view or viewController's internal elements to be bound to a view model.

MyViewModel.swift implementation
```Swift
import DPProtocols

// this example uses RxSwift as the reactive framework
import RxSwift

struct MyViewModel {
    let title: PublishSubject<String>()
    let information: PublishSubject<String>
    let isSubmitEnabled: BehaviorSubject<Bool>(false)

    ....
    // the rest of the view model code
}
```

MyViewController.swift implementation
```Swift
final class MyViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    // viewModel needs to be explicitly unwrapped to avoid the need to be assigned at initialization but referenced without having to be unwrapped
    var viewModel: MyViewModel!
    let disposeBag = DisposeBag()

    ....
    // the rest of the view controller code
}

extension MyViewController: Bindable {
    func bindViewModel() {
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.information
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.isSubmitEnabled
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
```

##### SetViewModel
Once the view model and view controller are defined and the view controller conforms to `Bindable` when creating an instance of the view controller `setViewModel(to:)` needs to be called to trigger the bindings.

```Swift
    let myViewModel = MyViewModel()
    var myViewController = MyViewController()
    myViewController.setViewModel(to: viewModel) // causes `bindViewModel` to be called

```

_____

### <span id="viewmodel">ViewModel</span>
The ViewModel protocol helps define consistent interfaces for view models, specifically an `Input` and `Output` interface (typically a struct of Observers and Observables) .

---

### <span id="coordinator">Coordinator</span>
Use of the [coordinator pattern](https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps) simplifies the navigation of the app and allows the app to follow the single responsibility principle and separation of concerns by holding all navigation logic in one place and not spread out through the view controllers and view models.

```Swift
import SomeOtherFramework

final class MyMainCoordinator: Coordinator {
    private var childCoordinator = Coordinator?
    private let navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        // add child coordinators to `children` if needed
        let otherFrameworkCoordinator = SomeOtherFramework().coordinator(navigationController: navigationController) // pass MyMainCoordinator's navigationController as the child coordinator's navigationController
        children.append(otherFrameworkCoordinator)
    }

    // provides the initial view controller for the `navigationController`
    public func start() {
        let viewModel = MyViewModel(coordinator: self)
        let viewController = MyViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    // a destination within the same module
    func theNextScreen() {
        let viewModel = MyOtherViewModel(coordinator: self)
        let viewController = MyOtherViewController(viewModel: viewModel)
        navigationController.push(viewController, animated: true)
    }

    func anotherModuleScreen() {
        let otherCoordinator = OtherCoordinator(with: navigationController)
        childCoordinator = otherCoordinator
        // go to the primary screen in the other module
        otherCoordinator.start()
    }
}

struct MyViewModel {
    let coordinator: Coordinator

    init(coordinator: coordinator) {
        self.coordinator = coordinator
    }

    func showNextScreen() {
        coordinator.theNextScreen()
    }

    func goToAnotherModule() {
        coordinator.anotherModuleScreen()
    }
}
```
_____

### <span id="feedbackcoordinator">FeedbackCoordinator</span>
Extension on the `Coordinator` that adds support for using the `RxFeedback` library.

The `FeedbackCoordinator` now has a `State` (typically a struct) that will be changed based on the triggering of an `Event`. The coordinator contains a `reduce` function that takes an existing state and an event and reduces it to an updated state and a `feedback` loop observes `State` changes and returns an `Observable<Event>`.

The `Coordinator` start method is defined in a `FeedbackCoordinator` extension that will start the RxFeedback loop.  ViewModels in applications using `FeedbackCoordinator` should have an `Observable<Event>` as one of the members of the ViewModel's `Output` struct. A posted event to that Observable will trigger the `reduce` function to calculate the new `State` of the Coordinator.  The state change will trigger the feedback loop in which a new view should be created, associated with a ViewModel, and pushed onto the view stack. The `Observable<Event>` from the new `ViewModel`'s `Output` should be returned from the feedback method, continuing RxFeedback change. 

----

### <span id="logger">Logger</span>
Logging is an important part of any robust application and can make debugging issues much easier.

The `Logger` protocol is currently empty and will expanded as requirements become more clear.

_____

### <span id="repository">Repository</span>
The [repository pattern](https://medium.com/tiendeo-tech/ios-repository-pattern-in-swift-85a8c62bf436) provides for abstraction of data. It is not necessarily needed in every module and should be implemented based on the needs of the specific module.

The `Repository` protocol is currently empty and will be expanded as requirements become more clear.

_____

### <span id="storyboardable">Storyboardable</span>
The `Storyboardable` protocol is there to assist in instantiating view controllers from storyboards.

**Important Note:** In order to work each view controller in the storyboard must have an identifier that matches the view controller name. e.g. - MyViewController.swift would have an identifier of MyViewController

```Swift
// MyViewController is in Mine.storyboard, has the identifier "MyViewController" and in the bundle called "MyBundle"
final class MyViewController: Storyboardable {
    ....
    // the rest of the view controller code    
}
// MyOtherViewController is in Main.storyboard that was created when we created the project, has the identifier "MyOtherViewController" and in the main bundle.
final class MyOtherViewController: Storyboardable {
    ....
    // the rest of the view controller code
}
```
Now that the view controller conforms to `Storyboardable`, instantiation is simple.
```Swift
let nextViewController: UIViewController
if shouldShowOther {
    // due to the bundle and storyboard that MyOtherViewController is located, no arguments need to be passed in to `instantiate`
    nextViewController = MyOtherViewController.instantiate()
} else {
    let myBundle = Bundle(identifier: "MyBundle")
    nextViewController = MyViewController.instantiate(fromStoryboardNamed: "Mine", in: myBundle)
}

present(nextViewController, animated: true)

```
