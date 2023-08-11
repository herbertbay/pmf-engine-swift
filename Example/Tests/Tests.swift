import XCTest
@testable import pmf_engine_swift

// MARK: - Constants

private struct TestConstants {
  static let testAccountId = "yourAccountId"
  static let testUserId = "yourUserId"
}

// MARK: - MockUserDefaults

class MockUserDefaults: PMFUserDefaultsProtocol {
  var registeredDate: Date?
  var accountId: String?
  var userId: String?
  var keyActionsPerformedCount: [String : Int] = [:]
}

// MARK: - MockPMFNetworkService

class MockPMFNetworkService: PMFNetworkProtocol {
  var shouldSucceed = true
  var returnedCommands: [PMFNetworkService.CommandEntity]? = nil
  var eventsTracked: [(accountId: String, userId: String, eventName: String)] = []

  func trackEvent(accountId: String, userId: String, eventName: String) {
    eventsTracked.append((accountId, userId, eventName))
  }

  func getFormActions(forceShow: Bool, accountId: String, userId: String, completion: @escaping ([PMFNetworkService.CommandEntity]?) -> Void) {
    if shouldSucceed || forceShow {
      completion(returnedCommands)
    } else {
      completion(nil)
    }
  }
}

class PMFEngineTests: XCTestCase {
  var pmfEngine: PMFProtocol!

  override func setUp() {
    super.setUp()

    pmfEngine = PMFEngine.default
    (pmfEngine as! PMFEngine).defaults = MockUserDefaults()
  }

  override func tearDown() {
    pmfEngine = nil
    super.tearDown()
  }

  // Testing configuration method
  func testConfigure() {
    let defaults = (pmfEngine as! PMFEngine).defaults
    pmfEngine.configure(accountId: TestConstants.testAccountId, userId: TestConstants.testUserId)

    XCTAssertEqual(defaults.accountId, TestConstants.testAccountId)
    XCTAssertEqual(defaults.userId, TestConstants.testUserId)
  }

  // Testing event tracking mechanism
  func testTrackKeyEvent() {
    pmfEngine.configure(accountId: TestConstants.testAccountId, userId: TestConstants.testUserId)
    
    let defaults = (pmfEngine as! PMFEngine).defaults
    let mockNetworkService = MockPMFNetworkService()
    (pmfEngine as! PMFEngine).pmfNetworkService = mockNetworkService

    pmfEngine.trackKeyEvent("event1")
    pmfEngine.trackKeyEvent("event1")
    pmfEngine.trackKeyEvent("event2")

    XCTAssertEqual(defaults.keyActionsPerformedCount["event1"], 2)
    XCTAssertEqual(defaults.keyActionsPerformedCount["event2"], 1)

    // Asserting trackEvent calls
    XCTAssertEqual(mockNetworkService.eventsTracked.count, 3)
  }

  // Testing popup appearance on success
  func testShowPMFPopup_Success() {
    setupViewControllerWithCommands(shouldSucceed: true)
    XCTAssertTrue(isViewControllerPresented(PMFEngineViewController.self))
  }

  // Testing forced popup appearance
  func testForceShowPMFPopup_Success() {
    setupViewControllerWithCommands(shouldSucceed: false, forceShow: true)
    XCTAssertTrue(isViewControllerPresented(PMFEngineViewController.self))
  }

  // Testing popup does not appear on failure
  func testShowPMFPopup_Failure() {
    setupViewControllerWithCommands(shouldSucceed: false)
    XCTAssertFalse(isViewControllerPresented(PMFEngineViewController.self))
  }
}

extension PMFEngineTests {
  private func setupViewControllerWithCommands(shouldSucceed: Bool, forceShow: Bool = false) {
    let rootViewController = UIViewController()
    UIApplication.shared.windows.first?.rootViewController = rootViewController

    let mockNetworkService = MockPMFNetworkService()
    mockNetworkService.shouldSucceed = shouldSucceed
    mockNetworkService.returnedCommands = [PMFNetworkService.CommandEntity(type: "form", url: "https://example.com")]
    (pmfEngine as! PMFEngine).pmfNetworkService = mockNetworkService
    pmfEngine.configure(accountId: TestConstants.testAccountId, userId: TestConstants.testUserId)

    if forceShow {
      pmfEngine.forceShowPMFPopup(popupView: PMFEnginePopupView(), onViewController: rootViewController)
    } else {
      pmfEngine.showPMFPopup(popupView: PMFEnginePopupView(), onViewController: rootViewController)
    }
  }

  var rootViewController: UIViewController? {
    return UIApplication.shared.windows.first?.rootViewController
  }

  func isViewControllerPresented<T: UIViewController>(_ type: T.Type) -> Bool {
    guard let rootViewController = rootViewController else {
      return false
    }
    return findPresentedViewController(rootViewController) is T
  }

  private func findPresentedViewController(_ vc: UIViewController) -> UIViewController? {
    if let presented = vc.presentedViewController {
      return findPresentedViewController(presented)
    }
    return vc
  }
}
