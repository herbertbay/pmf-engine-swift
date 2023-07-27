import XCTest
@testable import pmf_engine_swift

class MockUserDefaults: PMFUserDefaultsProtocol {
  var registeredDate: Date?
  var accountId: String?
  var userId: String?
  var keyActionsPerformedCount: [String : Int] = [:]
}

class PMFEngineTests: XCTestCase {

  var pmfEngine: PMFEngineExtendedProtocol!

  override func setUp() {
    super.setUp()
    pmfEngine = PMFEngine.default

    (pmfEngine as! PMFEngine).defaults = MockUserDefaults()
  }

  override func tearDown() {
    pmfEngine = nil
    super.tearDown()
  }

  // Test if the configure method sets the defaults correctly
  func testConfigure() {
    let defaults = (pmfEngine as! PMFEngine).defaults

    pmfEngine.configure(accountId: "yourAccountId", userId: "yourUserId")

    XCTAssertEqual(defaults.accountId, "yourAccountId")
    XCTAssertEqual(defaults.userId, "yourUserId")
  }

  func testTrackKeyEvent() {
    let defaults = (pmfEngine as! PMFEngine).defaults

    pmfEngine.trackKeyEvent("event1")
    pmfEngine.trackKeyEvent("event1")
    pmfEngine.trackKeyEvent("event2")

    XCTAssertEqual(defaults.keyActionsPerformedCount["event1"], 2)
    XCTAssertEqual(defaults.keyActionsPerformedCount["event2"], 1)
  }

  func testBuildPMFUrl() {
    // If accountId and userId are not configured, it should return nil
    XCTAssertNil(pmfEngine.buildPMFUrl())

    pmfEngine.configure(accountId: "yourAccountId", userId: "yourUserId")

    let url = pmfEngine.buildPMFUrl()
    XCTAssertEqual(url, URL(string: "https://pmf-engine.com/form/yourAccountId/feedback/:yourUserId/:iOS"))
  }

  func testShouldShowPMFForm() {
    var defaults = (pmfEngine as! PMFEngine).defaults

    // If registeredDate is nil, it should return false
    XCTAssertFalse(pmfEngine.shouldShowPMFForm())

    // If registeredDate is within the last two weeks and there are not enough key events, it should return false
    defaults.registeredDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
    XCTAssertFalse(pmfEngine.shouldShowPMFForm())

    // If registeredDate is over two weeks ago but there are not enough key events, it should return false
    defaults.registeredDate = Calendar.current.date(byAdding: .day, value: -15, to: Date())
    XCTAssertFalse(pmfEngine.shouldShowPMFForm())

    // If registeredDate is over two weeks ago and there are enough key events, it should return true
    defaults.keyActionsPerformedCount = ["event1": 3, "event2": 2]
    XCTAssertTrue(pmfEngine.shouldShowPMFForm())
  }

  func testHasAtLeastTwoKeyEvents() {
    var defaults = (pmfEngine as! PMFEngine).defaults

    // If there are less than two key events, it should return false
    defaults.keyActionsPerformedCount = [:]
    XCTAssertFalse(pmfEngine.hasAtLeastTwoKeyEvents())

    defaults.keyActionsPerformedCount = ["event1": 1]
    XCTAssertFalse(pmfEngine.hasAtLeastTwoKeyEvents())

    // If there are at least two key events, it should return true
    defaults.keyActionsPerformedCount = ["event1": 2, "event2": 1]
    XCTAssertTrue(pmfEngine.hasAtLeastTwoKeyEvents())

    // If there are more than two key events, it should return true
    defaults.keyActionsPerformedCount = ["event1": 2, "event2": 1, "event3": 1]
    XCTAssertTrue(pmfEngine.hasAtLeastTwoKeyEvents())
  }
}
