import XCTest
import KitBridge
#if SWIFT_PACKAGE
import KitBridgeSwift
#endif

final class KitBridgeTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    // MARK: -

    func testPasteboardIsEqual() throws {
        let pb: NSPasteboard = ILPasteboard.withUniqueName()
        let pb2: NSPasteboard = ILPasteboard.withUniqueName()
        XCTAssert(pb == pb2, "empty pasteboards are equal")

        pb.setString("test", forType: NSPasteboard.PasteboardType.string)
        pb2.setString("test", forType: NSPasteboard.PasteboardType.string)
        XCTAssert(pb == pb2, "pasteboards with same content are equal")

        let appIcon: ILImage = ILImage(named: "NSApplicationIcon")!
        pb.setValue(appIcon, forPasteboardType: "image/png")
        pb2.setValue(appIcon.copy() as! ILImage, forPasteboardType: "image/png")
        XCTAssert(pb == pb2, "pasteboards with same image content are equal")

        let general = ILPasteboard.general
        let general2 = general.copy() as! NSPasteboard
        XCTAssert(general == general2, "general and copy are equal")
    }

    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
