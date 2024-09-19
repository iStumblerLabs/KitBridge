#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: UTF Magic Numbers

/// @const UTF-8 Byte Order Mark Magic: EF BB BF
extern NSString* const ILUTF8BOMMagic;

/// @const UTF-16 Big Endian Magic: FE FF
extern NSString* const ILUTF16BEMagic;

/// @const UTF-16 Little Endian Magic: FF FE
extern NSString* const ILUTF16LEMagic;

/// @const UTF-32 Big Endian Magic: 00 00 FE FF
extern NSString* const ILUTF32BEMagic;

/// @const UTF-32 Little Endian Magic: FF FE 00 00
extern NSString* const ILUTF32LEMagic;

// MARK: -

@interface NSString (KitBridge)

/// @returns the NSStringEncoding based on the magic number of the data provided or NSStringEncodingUn
+ (NSStringEncoding) UTFEncodingOfData:(NSData*) data;

/// @returns a string from any type of UTF data by auto-detecting the encoding
+ (NSString*) stringWithUTFData:(NSData*) data;

/// @returns a hexadecimal string representation of the data
+ (NSString*) hexStringWithData:(NSData*) data;

// MARK: -

/// @returns a new data object with the UTF encoding specified including the BOM
- (NSData*) dataWithByteOrderUTFEncoding:(NSStringEncoding)utfEncoding;

/// @returns an array of substrings with a maximum length
- (NSArray<NSString*>*) linesWithMaxLen:(NSUInteger) maxLen;

@end

NS_ASSUME_NONNULL_END
