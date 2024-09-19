#import "NSString+KitBridge.h"
#import "NSURL+KitBridge.h"

// MARK: UTF Magic Numbers

NSString* const ILUTF8BOMMagic = @"data:;hex,EFBBBF";
NSString* const ILUTF16BEMagic = @"data:;hex,FEFF";
NSString* const ILUTF16LEMagic = @"data:;hex,FFFE";
NSString* const ILUTF32BEMagic = @"data:;hex,0000FEFF";
NSString* const ILUTF32LEMagic = @"data:;hex,FFFE0000";

// MARK: -

@implementation NSString (KitBridge)

+ (NSData*) magicForUTFEncoding:(NSStringEncoding) utfEncoding {
    static NSData* UTF8BOMMagicData;
    static NSData* UTF16BEMagicData;
    static NSData* UTF16LEMagicData;
    static NSData* UTF32BEMagicData;
    static NSData* UTF32LEMagicData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UTF8BOMMagicData = [NSURL URLWithString:ILUTF8BOMMagic].URLData;
        UTF16BEMagicData = [NSURL URLWithString:ILUTF16BEMagic].URLData;
        UTF16LEMagicData = [NSURL URLWithString:ILUTF16LEMagic].URLData;
        UTF32BEMagicData = [NSURL URLWithString:ILUTF32BEMagic].URLData;
        UTF32LEMagicData = [NSURL URLWithString:ILUTF32LEMagic].URLData;
    });

    NSData* magic = nil;
    switch (utfEncoding) {
        case NSUTF8StringEncoding:
            magic = UTF8BOMMagicData;
            break;
        case NSUTF16StringEncoding:
            magic = UTF16BEMagicData;
            break;
        case NSUTF16BigEndianStringEncoding:
            magic = UTF16BEMagicData;
            break;
        case NSUTF16LittleEndianStringEncoding:
            magic = UTF16LEMagicData;
            break;
        case NSUTF32StringEncoding:
            magic = UTF32BEMagicData;
            break;
        case NSUTF32BigEndianStringEncoding:
            magic = UTF32BEMagicData;
            break;
        case NSUTF32LittleEndianStringEncoding:
            magic = UTF32LEMagicData;
            break;
        default:
            break;
    }

    return magic;
}

+ (NSStringEncoding) UTFEncodingOfData:(NSData*) data {
    NSStringEncoding encoding = 0;
    if ([data rangeOfData:[self magicForUTFEncoding:NSUTF8StringEncoding]
                  options:NSDataSearchAnchored
                    range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF8StringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16BigEndianStringEncoding]
                         options:NSDataSearchAnchored
                           range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF16BigEndianStringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16LittleEndianStringEncoding]
                       options:NSDataSearchAnchored
                         range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF16LittleEndianStringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32BigEndianStringEncoding]
                       options:NSDataSearchAnchored
                         range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF32BigEndianStringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32LittleEndianStringEncoding]
                       options:NSDataSearchAnchored
                         range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF32LittleEndianStringEncoding;
    }
    else { // assume UTF8
        encoding = NSUTF8StringEncoding;
    }

    return encoding;
}

+ (NSStringEncoding) UTFEncodingOfData:(NSData*) data convertedString:(NSString*_Nullable*) string {
    static NSDictionary* options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = @{
            NSStringEncodingDetectionAllowLossyKey: @(NO),
            NSStringEncodingDetectionSuggestedEncodingsKey: @[
                @(NSUTF8StringEncoding),
                @(NSUTF16StringEncoding),
                @(NSUTF16BigEndianStringEncoding),
                @(NSUTF16LittleEndianStringEncoding),
                @(NSUTF32StringEncoding),
                @(NSUTF32BigEndianStringEncoding),
                @(NSUTF32LittleEndianStringEncoding)
            ],
            NSStringEncodingDetectionUseOnlySuggestedEncodingsKey: @(YES)
        };
    });

    NSStringEncoding detectedEncoding = [NSString stringEncodingForData:data encodingOptions:options convertedString:string usedLossyConversion:nil];
    if (detectedEncoding == NSUTF16StringEncoding) {
        if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16BigEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF16BigEndianStringEncoding;
        }
        else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16LittleEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF16LittleEndianStringEncoding;
        }
    }
    else if (detectedEncoding == NSUTF32StringEncoding) {
        if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32BigEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF32BigEndianStringEncoding;
        }
        else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32LittleEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF32LittleEndianStringEncoding;
        }
    }

    return detectedEncoding;
}

+ (NSString*) stringWithUTFData:(NSData*) data {
    return [NSString.alloc initWithData:data encoding:[self UTFEncodingOfData:data]];
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

- (NSData*) dataWithByteOrderUTFEncoding:(NSStringEncoding)utfEncoding {
    static NSData* UTF8BOMMagicData;
    static NSData* UTF16BEMagicData;
    static NSData* UTF16LEMagicData;
    static NSData* UTF32BEMagicData;
    static NSData* UTF32LEMagicData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UTF8BOMMagicData = [NSURL URLWithString:ILUTF8BOMMagic].URLData;
        UTF16BEMagicData = [NSURL URLWithString:ILUTF16BEMagic].URLData;
        UTF16LEMagicData = [NSURL URLWithString:ILUTF16LEMagic].URLData;
        UTF32BEMagicData = [NSURL URLWithString:ILUTF32BEMagic].URLData;
        UTF32LEMagicData = [NSURL URLWithString:ILUTF32LEMagic].URLData;
    });

    NSMutableData* BOMData = NSMutableData.new;
    switch (utfEncoding) {
        case NSUTF8StringEncoding:
            [BOMData appendData:UTF8BOMMagicData];
            break;
        case NSUTF16BigEndianStringEncoding:
            [BOMData appendData:UTF16BEMagicData];
            break;
        case NSUTF16LittleEndianStringEncoding:
            [BOMData appendData:UTF16LEMagicData];
            break;
        case NSUTF32BigEndianStringEncoding:
            [BOMData appendData:UTF32BEMagicData];
            break;
        case NSUTF32LittleEndianStringEncoding:
            [BOMData appendData:UTF32LEMagicData];
            break;
        default:
            break;
    }

    [BOMData appendData:[self dataUsingEncoding:utfEncoding]];

    return BOMData;
}

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
