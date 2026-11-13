import XCTest
@testable import Spiteful

final class RibGeneratorTests: XCTestCase {
    func testBlocksPersonalAttacks() {
        XCTAssertFalse(RibGenerator.isSafe("you're so ugly"))
        XCTAssertFalse(RibGenerator.isSafe("lose some weight"))
    }

    func testAllowsWorkRibbing() {
        XCTAssertTrue(RibGenerator.isSafe("the colors could be brighter next time"))
    }

    func testRoastMentionsRivalAndIsSafe() {
        let rival = Rival(name: "Maya", emoji: "🎨", project: "painting", optedIn: true)
        for level in Intensity.allCases {
            let text = RibGenerator.roast(for: rival, task: "the painting", intensity: level)
            XCTAssertTrue(text.contains("Maya"))
            XCTAssertTrue(RibGenerator.isSafe(text))
        }
    }
}
