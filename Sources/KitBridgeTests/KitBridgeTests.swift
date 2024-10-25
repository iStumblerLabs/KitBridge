import XCTest
import KitBridge
#if SWIFT_PACKAGE
import KitBridgeSwift
#endif

final class KitBridgeTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    // MARK: - RFC 2397 data: URL Tests

    // test basic data URL creation
    func testDataURLWithData() throws {
        if let exampleData: Data = "testDataURLWithData()".data(using: String.Encoding.utf8) {
            let testURL: URL = NSURL.dataURL(with: exampleData)
            NSLog("testDataURLWithData: \(testURL)")
            XCTAssertNotNil(testURL, "testURL is not null")
            XCTAssert(!testURL.isFileURL, "testURL is not a file URL")
            XCTAssert(testURL.absoluteString.hasPrefix("data:"), "testURL is a data URL")
            XCTAssert(testURL.absoluteString.contains("base64"), "testURL is a base64 data URL")
        } else {
            XCTFail("Failed to create Data from string")
        }
    }

    // test `data:,` URL creation
    func testNullDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:,")!
        let testData: Data? = testURL.urlData
        XCTAssertNil(testData, "testData is null")
    }

    // test `data:,0` single byte URL creation
    func testSingleByteDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:,0")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 1, "testData is one byte")
        XCTAssert(testData == "0".data(using: String.Encoding.utf8), "testData is \"0\"")
    }

    // data:,Hello%20World
    func testStringDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:,Hello%20World".removingPercentEncoding!)!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        NSLog("testData: \(testData!)")
        XCTAssert(testData!.count == 11, "testData is 11 bytes")
        XCTAssert(testData!.elementsEqual("Hello World".data(using: String.Encoding.utf8)!), "testData is 'Hello World'")
    }

    // data:;hex,EFBBBF
    func testHexDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:;hex,EFBBBF")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 3, "testData is 3 bytes")
        XCTAssertEqual(NSString.hexString(with: testData!).uppercased(), "EFBBBF")
    }

    // base64 encoded "1234567890"
    // data:application/octet-stream;base64,MTIzNDU2Nzg5MA==
    func testBase64DataURL() throws {
        let testURL: NSURL = NSURL(string: "data:application/octet-stream;base64,MTIzNDU2Nzg5MA==")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 10, "testData is 10 bytes")
        XCTAssert(String(data: testData!, encoding: String.Encoding.utf8) == "1234567890", "testData is '1234567890'")
    }

    // https://stackoverflow.com/questions/2253404/what-is-the-smallest-valid-jpeg-file-size-in-bytes#2349470

    let JPEGDataURL = "data:image/jpeg;hex,ffd8ffe000104a46494600010101004800480000ffdb004300030202020202030202020303030304060404040404080606050609080a0a090809090a0c0f0c0a0b0e0b09090d110d0e0f101011100a0c12131210130f101010ffc9000b080001000101011100ffcc000600101005ffda0008010100003f00d2cf20ffd9"

    func testHexJPEGDataURL() throws {
        let testURL: NSURL = NSURL(string: JPEGDataURL)!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 125, "testData is 125 bytes")
        let image: ILImage? = ILImage(data: testData!)
        XCTAssertNotNil(image, "image is not null")
    }

    func testHexToBase64Conversion() throws {
        let testData: Data? = NSURL(string: JPEGDataURL)!.urlData!
        let image: ILImage? = ILImage(data: testData!)
        let imageBase64: String? = testData?.base64EncodedString()
        let imageBase64URL: NSURL = NSURL(string: "data:image/jpeg;base64,\(imageBase64!)")!
        NSLog("imageBase64URL: \(imageBase64URL)")
        let imageBase64Data: Data? = imageBase64URL.urlData
        let base64Image: ILImage? = ILImage(data: imageBase64Data!)
        XCTAssertEqual(image?.size, base64Image?.size, "image and base64Image are the same size")
        XCTAssert(image!.isEqual(to: base64Image), "image and base64Image are the same")
    }

    // https://evanhahn.com/worlds-smallest-png/
    //
    let PNGDataURL = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQAAAAA3bvkkAAAACklEQVR4AWNgAAAAAgABc3UBGAAAAABJRU5ErkJggg=="

    func testBase64PngDataURL() throws {
        let testURL: NSURL = NSURL(string: PNGDataURL)!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 67, "testData is 24 bytes")
        let image: ILImage? = ILImage(data: testData!)
        XCTAssertNotNil(image, "image is not null")
        XCTAssert(image?.size.width == 1 && image?.size.height == 1, "image is 1x1")
    }

    func testBase64ToHexConversion() throws {
        let testData: Data? = NSURL(string: PNGDataURL)!.urlData!
        let image: ILImage? = ILImage(data: testData!)
        let imageHexURL = NSURL.dataURL(with: testData!, mediaType: "image/png", parameters: nil, contentEncoding:ILDataURLHexEncoding)
        let imageHexNSURL: NSURL = NSURL(string:imageHexURL.absoluteString)! // TODO: sort the Foundation.URL
        NSLog("imageHexURL: \(imageHexURL)")
        let imageHexData: Data? = imageHexNSURL.urlData!
        let hexImage: ILImage? = ILImage(data: imageHexData!)
        XCTAssertEqual(image?.size, hexImage?.size, "image and hexImage are the same size")
    }

    // http://probablyprogramming.com/2009/03/15/the-tiniest-gif-ever
    // data:image/gif;base64,R0lGODlhAQABAIABAP///wAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
    func testBase64GifDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:image/gif;base64,R0lGODlhAQABAIABAP///wAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 43, "testData is 43 bytes")
        let image: ILImage? = ILImage(data: testData!)
        XCTAssertNotNil(image, "image is not null")
    }

    // data:text/example;foo=bar,
    func testDataURLParameters() throws {
        let testURL: NSURL = NSURL(string: "data:text/example;foo=bar,")!
        var mediaType: NSString?
        var parameters: NSDictionary?
        var encoding: NSString?
        let testData: Data? = testURL.urlData(withMediaType: &mediaType, parameters: &parameters, contentEncoding: &encoding)
        XCTAssertNotNil(mediaType, "mediaType is not nil")
        XCTAssertNotNil(parameters, "parameters is not nil")
        XCTAssertNil(encoding, "encoding is nil")
        XCTAssertNil(testData, "testData is nil")
    }

    // data:text/example;foo=bar;hex,FF
    func testDataURLParametersHex() throws {
        let testURL: NSURL = NSURL(string: "data:text/example;foo=bar;hex,FF")!
        var mediaType: NSString?
        var parameters: NSDictionary?
        var encoding: NSString?
        let testData: Data? = testURL.urlData(withMediaType: &mediaType, parameters: &parameters, contentEncoding: &encoding)
        XCTAssertNotNil(mediaType, "mediaType is not nil")
        XCTAssertNotNil(parameters, "parameters is not nil")
        XCTAssertNotNil(encoding, "encoding is not nil")
        XCTAssertNotNil(testData, "testData is not nil")
        XCTAssert(testData!.count == 1, "testData is 1 byte")
        XCTAssertEqual(NSString.hexString(with: testData!).uppercased(), "FF")
    }

    // data:text/plain;charset=UTF-8;page=21,the%20data:1234,5678 <- double comma, implicit encoding
    func testDataURLParametersImplicitEncoding() throws {
        let testURL: NSURL = NSURL(string: "data:text/plain;charset=UTF-8;page=21,the%20data:1234,5678")!
        var mediaType: NSString?
        var parameters: NSDictionary?
        var encoding: NSString?
        let testData: Data? = testURL.urlData(withMediaType: &mediaType, parameters: &parameters, contentEncoding: &encoding)
        XCTAssertNotNil(mediaType, "mediaType is not nil")
        XCTAssertNotNil(parameters, "parameters is not nil")
        XCTAssertEqual(parameters?.count, 2, "parameters has 2 entries")
        XCTAssertEqual(parameters?.object(forKey: "charset") as? String, "UTF-8", "parameters has charset=UTF-8")
        XCTAssertEqual(parameters?.object(forKey: "page") as? String, "21", "parameters has page=21")
        XCTAssertNil(encoding, "encoding is nil")
        XCTAssertEqual(mediaType, "text/plain", "mediaType is 'text/plain'")
        XCTAssertNotNil(testData, "testData is not nil")
        XCTAssert(testData!.elementsEqual("the data:1234,5678".data(using: String.Encoding.utf8)!))
    }

    // data:image/svg+xml;utf8,%3Csvg%20width%3D'10'%20height%3D'10'%20xmlns%3D'http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg'%3E%3Ccircle%20style%3D'fill%3Ared'%20cx%3D'5'%20cy%3D'5'%20r%3D'5'%2F%3E%3C%2Fsvg%3E <- utf8 encoding
    func testSVGDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:image/svg+xml;utf8,%3Csvg%20width%3D'10'%20height%3D'10'%20xmlns%3D'http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg'%3E%3Ccircle%20style%3D'fill%3Ared'%20cx%3D'5'%20cy%3D'5'%20r%3D'5'%2F%3E%3C%2Fsvg%3E")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not nil")
        NSLog("testURL: \(testURL)")
        let stgImage: ILImage? = ILImage(data: testData!)
        XCTAssertNotNil(stgImage, "stgImage is not nil")
        XCTAssert(stgImage!.size.width == 10 && stgImage!.size.height == 10, "stgImage is 10x10")
    }

    // MARK: - UTF Auto-detection Tests

    func testUTF8EncodingDetection() throws {
        let utf8Data: Data = "UTF-8".data(using: String.Encoding.utf8)!
        let encoding: UInt = NSString.utfEncoding(of: utf8Data)
        XCTAssertEqual(encoding, String.Encoding.utf8.rawValue, "utf8Data is UTF-8")
    }

    func testUTF8Decode() throws {
        let utf8Data: Data = "UTF-8".data(using: String.Encoding.utf8)!
        let decoded = NSString(data: utf8Data, encoding: String.Encoding.utf8.rawValue)
        XCTAssertNotNil(decoded, "utf8Data decoded is not nil")
        XCTAssert(decoded == "UTF-8", "decoded is 'UTF-8'")
    }

    func testUTF8ByteOrder() throws {
        let utf8BOMData: Data = NSString(string: "UTF-8").data(withByteOrderUTFEncoding: String.Encoding.utf8.rawValue)
        XCTAssertNotNil(utf8BOMData, "utf8BOMData is not nil")
        let _: NSData = NSURL(string: ILUTF8BOMMagic)!.urlData! as NSData
        // XCTAssert(utf8BOMData, "utf8BOMData has BOM")
    }

    func testUTF16EncodingDetection() throws {
        let utf16Data: Data = "UTF-16".data(using: String.Encoding.utf16)!
        let encoding: UInt = NSString.utfEncoding(of: utf16Data)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf16Data is UTF-16LE")

        let decoded = NSString(data: utf16Data, encoding: String.Encoding.utf16LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16Data decoded is not nil")
    }

    func testUTF16BEDetection() throws {
        let utf16BEData: Data = NSString(string: "UTF-16BE").data(withByteOrderUTFEncoding: String.Encoding.utf16BigEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf16BEData)
        XCTAssertEqual(encoding, String.Encoding.utf16BigEndian.rawValue, "utf16BEData is UTF-16BE")

        let decoded = NSString(data: utf16BEData, encoding: String.Encoding.utf16BigEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16BEData decoded is not nil")
        // XCTAssert(decoded == "UTF-16BE", "decoded is 'UTF-16BE'")
    }

    func testUTF16LEDetection() throws {
        let utf16LEData: Data = NSString(string: "UTF-16LE").data(withByteOrderUTFEncoding:String.Encoding.utf16LittleEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf16LEData)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf16LEData is UTF-16LE")

        let decoded = NSString(data: utf16LEData, encoding: String.Encoding.utf16LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16LEData decoded is not nil")
        // XCTAssert((decoded! as String).compare("UTF-16LE") == ComparisonResult.orderedSame, "utf16LEData is 'UTF-16LE'")
    }

    func testUTF32EncodingDetection() throws {
        let utf32Data: Data = "UTF-32".data(using: String.Encoding.utf32)!
        let encoding: UInt = NSString.utfEncoding(of: utf32Data)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf32Data is UTF-16LE?!")

        let decoded = NSString(data: utf32Data, encoding: String.Encoding.utf32LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf32Data decoded is not nil")
    }

    func testUTF32BEDetection() throws {
        let utf32BEData: Data = NSString(string:"UTF-32BE").data(withByteOrderUTFEncoding: String.Encoding.utf32BigEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf32BEData)
        XCTAssertEqual(encoding, String.Encoding.utf32BigEndian.rawValue, "utf32BEData is UTF-32BE")

        let decoded = NSString(data: utf32BEData, encoding: String.Encoding.utf32BigEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16LEData is 'UTF-32BE'")
    }

    func testUTF32LEDetection() throws {
        let utf32LEData: Data = NSString(string:"UTF-32LE").data(withByteOrderUTFEncoding: String.Encoding.utf32LittleEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf32LEData)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf32LEData is UTF-32LE")

        let decoded = NSString(data: utf32LEData, encoding: String.Encoding.utf32LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf32LEData decoded is not nil")
    }

    // MARK: -

    func testLinesWithMaxLength() throws {
        let lines = NSString(string:JPEGDataURL).lines(withMaxLen: 20)
        NSLog("lines: \(lines)")
        XCTAssertNotNil(lines, "lines is not nil")
        for line in lines {
            XCTAssert(line.count <= 20, "line length < 20")
            XCTAssert(line.count != 0, "line not empty")
        }
    }

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
