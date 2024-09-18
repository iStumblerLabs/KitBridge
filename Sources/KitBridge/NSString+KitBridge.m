#import "NSString+KitBridge.h"
#import "NSURL+KitBridge.h"

// MARK: UTF Magic Numbers

NSString* const ILUTF8BOMMagic = @"data:;hex,EFBBBF";
NSString* const ILUTF16BEMagic = @"data:;hex,FEFF";
NSString* const ILUTF16LEMagic = @"data:;hex,FFFE";
NSString* const ILUTF32BEMagic = @"data:;hex,0000FEFF";
NSString* const ILUTF32LEMagic = @"data:;hex,FFFE0000";

/// If the data is not a valid UTF encoding, return this value
NSUInteger const ILUTFEncodingNotFound = NSUIntegerMax;

// MARK: -

@implementation NSString (KitBridge)

+ (NSStringEncoding) UTFEncodingOfData:(NSData*) data {
    static NSData* UTF8BOMMagicData;
    static NSData* UTF16BEMagicData;
    static NSData* UTF16LEMagicData;
    static NSData* UTF32BEMagicData;
    static NSData* UTF32LEMagicData;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UTF8BOMMagicData = [NSURL URLWithString:ILUTF8BOMMagic].URLData;
        UTF16BEMagicData = [NSURL URLWithString:ILUTF16BEMagic].URLData;;
        UTF16LEMagicData = [NSURL URLWithString:ILUTF16LEMagic].URLData;;
        UTF32BEMagicData = [NSURL URLWithString:ILUTF32BEMagic].URLData;;
        UTF32LEMagicData = [NSURL URLWithString:ILUTF32LEMagic].URLData;;
    });

    NSStringEncoding encoding = ILUTFEncodingNotFound;
    if ([data rangeOfData:UTF8BOMMagicData options:NSDataSearchAnchored range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF8StringEncoding;
    } else if ([data rangeOfData:UTF16BEMagicData options:NSDataSearchAnchored range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF16BigEndianStringEncoding;
    } else if ([data rangeOfData:UTF16LEMagicData options:NSDataSearchAnchored range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF16LittleEndianStringEncoding;
    } else if ([data rangeOfData:UTF32BEMagicData options:NSDataSearchAnchored range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF32BigEndianStringEncoding;
    } else if ([data rangeOfData:UTF32LEMagicData options:NSDataSearchAnchored range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF32LittleEndianStringEncoding;
    }
    else { // assume UTF8
        encoding = NSUTF8StringEncoding;
    }

    return encoding;
}

+ (NSString*) stringWithUTFData:(NSData*) data {
    NSString* string = nil;
    NSStringEncoding encoding = [NSString UTFEncodingOfData:data];
    if (encoding != ILUTFEncodingNotFound) {
        string = [NSString.alloc initWithData:data encoding:encoding];
    }

    return string;
}

+ (NSString*) hexStringWithData:(NSData*) data {
    NSString* string = nil;
    const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
    if (dataBuffer) {
        NSMutableString* hexString  = [NSMutableString stringWithCapacity:(data.length * 2)];
        for (int i = 0; i < data.length; ++i) {
            [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
        }

        string = [NSString stringWithString:hexString];
    }
    
    return string;
}

// MARK: -

- (NSArray<NSString*>*) linesWithMaxLen:(NSUInteger) maxLen {
    NSMutableArray* lines = NSMutableArray.new;
    NSUInteger index = 0;
    while (index < self.length) {
        NSUInteger lineLength = MIN(maxLen, self.length - index);
        NSRange lineRange = NSMakeRange(index, lineLength);
        NSString* line = [self substringWithRange:lineRange];
        [lines addObject:line];
        index += lineLength;
    }

    return lines;
}

@end
