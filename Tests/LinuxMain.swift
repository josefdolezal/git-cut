import XCTest

import gitcutTests

var tests = [XCTestCaseEntry]()
tests += gitcutTests.allTests()
XCTMain(tests)
