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

    // MARK: - Detect Links

    func testDetectLinkPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("https://www.apple.com", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "detected link")
        })
    }

    func testDetectBareDomainPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("apple.com", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "detected link")
        })
    }

    func testDetectEmailLinkPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("mailto:steve@apple.com", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "detected link")
        })
    }

    func testDetectSSHLinkPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("ssh:jrl@example.com", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "ssh: URL detected")
        })
    }

    func testDetectFileLinkPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("file:///dev/null", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "file: URL detected")
        })
    }

    func testDetectFTPLinkPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("ftp://infomac.archive.org", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "ftp: URL detected")
        })
    }

    func testDetectPrivateLinkPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("x-private:///test?x=y", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "private: URL detected")
        })
    }

    func testDetectDataLinkPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("data:;hex,EFBBBF", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link], completionHandler: { result, error in
            XCTAssert(!result.contains(.link), "data: URL not detected")
        })
    }

    // MARK: - Detect Phone Numbers

    func testDetectPhoneNumberPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("+1 (111) 867-5309", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.phoneNumber], completionHandler: { result, error in
            XCTAssert(result.contains(.phoneNumber), "detected phone number")
        })
    }

    // MARK: - Detect Calendar Dates

    func testDetectCalendarDatePatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("Mon Mar 17 20:23:07 MDT 2025", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.calendarEvent], completionHandler: { result, error in
            XCTAssert(result.contains(.calendarEvent), "detected calendar date")
        })
    }

    func testDetectShortDatePatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("Jan 3rd", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.calendarEvent], completionHandler: { result, error in
            XCTAssert(result.contains(.calendarEvent), "detected short date")
        })
    }

    func testDetectRelativeDatePatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("Next Monday", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.calendarEvent], completionHandler: { result, error in
            XCTAssert(result.contains(.calendarEvent), "detected relative date")
        })
    }

    func testDetectVagueDatePatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("thursday or friday around threeish", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.calendarEvent], completionHandler: { result, error in
            XCTAssert(result.contains(.calendarEvent), "detected vague date")
        })
    }

    // MARK: - Detect Postal Addresses

    func testDetectAddressPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("1 Infinite Loop, Cupertino, CA 95014", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.postalAddress], completionHandler: { result, error in
            XCTAssert(result.contains(.postalAddress), "detected postal address")
        })
    }

    func testDetectStreetAddressPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("1 Infinite Loop", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.postalAddress], completionHandler: { result, error in
            XCTAssert(!result.contains(.postalAddress), "detected no street address")
        })
    }

    func testDetectPartialAddressPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("1 Infinite Loop, Cupertino", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.postalAddress], completionHandler: { result, error in
            XCTAssert(result.contains(.postalAddress), "detected partial address")
        })
    }

    func testDetectCityStateAddressPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("Cupertino, CA", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.postalAddress], completionHandler: { result, error in
            XCTAssert(result.contains(.postalAddress), "address detected in city & state")
        })
    }

    func testDetectUSZipAddressPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("95014", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.postalAddress], completionHandler: { result, error in
            XCTAssert(!result.contains(.postalAddress), "no address detected in US zip code")
        })
    }

    func testDetectNonAddressPatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("the quick red fox jumped over the lazy brown dog", forType:NSPasteboard.PasteboardType.string)

        pasteboard.detectPatterns(forPatterns:[.postalAddress], completionHandler: { result, error in
            XCTAssert(!result.contains(.postalAddress), "detected no postal address")
        })
    }

    // MARK: - Multi Detection

    func testMultiplePatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("https://www.apple.com", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link, .phoneNumber], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "detected link")
            XCTAssert(!result.contains(.phoneNumber), "detected no phone number")
        })
    }

    func testMultipleExamplePatterns() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("https://www.apple.com +1(555)867-5309 1 Infinite Loop, Cupertino, CA April 1st, 1976", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectPatterns(forPatterns:[.link, .phoneNumber, .postalAddress, .calendarEvent], completionHandler: { result, error in
            XCTAssert(result.contains(.link), "detected link")
            XCTAssert(result.contains(.phoneNumber), "detected no phone number")
            XCTAssert(result.contains(.postalAddress), "detected postal address")
            XCTAssert(result.contains(.calendarEvent), "detected calendar event")
        })
    }

    // MARK: - Detect Links w/ Values

    func testDetectLinkValues() throws {
        let pasteboard = ILPasteboard.withUniqueName()
        pasteboard.setString("https://www.apple.com", forType:NSPasteboard.PasteboardType.string)
        pasteboard.detectValues(forPatterns:[.link], completionHandler: { result, error in

            //            XCTAssert(result.contains(.link), "detected link")
        })
    }

    // TODO: ILTextView+KitBridge tests

    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
