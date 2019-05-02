import XCTest
import Moxie
import class Foundation.Bundle

protocol List {
  mutating func add(_ item: String)
  mutating func clear()

  func get(_ index: Int) -> String?
}

struct MockList: Mock, List {
  var moxie = Moxie()

  mutating func add(_ item: String) {
    record(function: "add", wasCalledWith: [item])
  }

  mutating func clear() {
    record(function: "clear")
  }

  func get(_ index: Int) -> String? {
    return value(forFunction: "get")
  }
}

final class MoxieSpmTestTests: XCTestCase {
  func testList() {
    var mockList = MockList()

    mockList.add("one")
    mockList.clear()

    XCTAssertTrue(mockList.invoked(function: "add"))
    XCTAssertEqual("one", mockList.parameters(forFunction: "add")[0] as? String)
    XCTAssertTrue(mockList.invoked(function: "clear"))

    mockList.stub(function: "get", return: "first")

    XCTAssertEqual("first", mockList.get(0))
  }

  static var allTests = [
    ("testList", testList),
  ]
}
