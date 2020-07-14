import SwiftLintFramework
import XCTest

class RxPrivateSubjectTests: XCTestCase {
    func testWithDefaultConfiguration() {
        verifyRule(RxPrivateSubjectRule.description)
    }
}
