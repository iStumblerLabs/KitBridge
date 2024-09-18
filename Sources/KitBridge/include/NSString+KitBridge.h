#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: UTF Magic Numbers

/// UTF-8 Byte Order Mark Magic: EF BB BF
extern NSString* const ILUTF8BOMMagic;

/// UTF-16 Big Endian Magic: FE FF
extern NSString* const ILUTF16BEMagic;

/// UTF-16 Little Endian Magic: FF FE
extern NSString* const ILUTF16LEMagic;

/// UTF-32 Big Endian Magic: 00 00 FE FF
extern NSString* const ILUTF32BEMagic;

/// UTF-32 Little Endian Magic: FF FE 00 00
extern NSString* const ILUTF32LEMagic;

/// If the data is not a valid UTF encoding, return this value
extern NSUInteger const ILUTFEncodingNotFound;

// MARK: -

@interface NSString (KitBridge)

/// @returns the NSStringEncoding based on the magic number of the data provided or NSStringEncodingUn
+ (NSStringEncoding) UTFEncodingOfData:(NSData*) data;

/// @returns a string from any type of UTF data by auto-detecting the encoding
+ (NSString*) stringWithUTFData:(NSData*) data;

/// @returns a hexadecimal string representation of the data
+ (NSString*) hexStringWithData:(NSData*) data;

// MARK: -

/// @returns an array of substrings with a maximum length
- (NSArray<NSString*>*) linesWithMaxLen:(NSUInteger) maxLen;

@end

NS_ASSUME_NONNULL_END
