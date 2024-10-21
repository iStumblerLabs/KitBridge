#import "NSURL+KitBridge.h"
#import "NSString+KitBridge.h"
#import "KitBridgeDefines.h"

NSString* const ILDataURLScheme = @"data";
NSString* const ILDataURLUTF8Encoding = @"utf8";
NSString* const ILDataURLHexEncoding = @"hex";
NSString* const ILDataURLBase64Encoding = @"base64";

@implementation NSURL (KitBridge)

+ (NSURL*) dataURLWithData:(NSData*) data {
    NSString* encodedData = [data base64EncodedStringWithOptions:0];
    NSString* dataURL = [[ILDataURLScheme stringByAppendingString:@":;base64,"] stringByAppendingString:encodedData];
    return [NSURL URLWithString:dataURL];
}

+ (NSURL*) dataURLWithData:(NSData*) data
                 mediaType:(NSString*) mediaType
                parameters:(NSDictionary<NSString*,NSString*>*) parameters
           contentEncoding:(NSString*) contentEncoding {
    NSString* dataURL = [ILDataURLScheme stringByAppendingString:@":"];

    if (mediaType) {
        dataURL = [dataURL stringByAppendingFormat:@"%@;", mediaType];
        if (parameters) {
            for (NSString* key in parameters.allKeys) {
                dataURL = [dataURL stringByAppendingFormat:@"%@=%@;", key, parameters[key]];
            }
        }
    }
    // TODO: else if paramaters are present, but no mediaType, report a media type error

    // Encode the data as directed by the contentEncoding
    if ([ILDataURLHexEncoding isEqualToString:contentEncoding]) {
        dataURL = [dataURL stringByAppendingFormat:@"%@,%@", contentEncoding, [NSString hexStringWithData:data]];
    }
    else if ([ILDataURLBase64Encoding isEqualToString:contentEncoding]) {
        dataURL = [dataURL stringByAppendingFormat:@"%@,%@", contentEncoding, [data base64EncodedStringWithOptions:0]];
    }
    else if ([ILDataURLUTF8Encoding isEqualToString:contentEncoding]) {
        dataURL = [dataURL stringByAppendingFormat:@"%@,%@", contentEncoding, [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding]];
    }
    else { // Assume UTF8
        dataURL = [dataURL stringByAppendingFormat:@",%@", [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding]];
    }

    return [NSURL URLWithString:dataURL];
}

+ (NSURL*) URLWithUTTypeData:(NSData*)UTTypeData {
    NSURL* dataURL = nil;
#if IL_APP_KIT
    dataURL = [NSURL URLWithDataRepresentation:UTTypeData relativeToURL:nil];
#elif IL_UI_KIT
    NSPropertyListFormat plistFormat;
    NSError* plistError = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:UTTypeData
                                                         options:NSPropertyListImmutable
                                                          format:&plistFormat
                                                           error:&plistError];
    if ([plist isKindOfClass:NSArray.class]) {
        dataURL = [NSURL URLWithString:[plist firstObject]];
    }
    else if ([plist isKindOfClass:NSString.class]) {
        dataURL = [NSURL URLWithString:plist];
    }
#endif
    return dataURL;
}

// MARK: -

- (NSData*) URLData {
    return [self URLDataWithMediaType:nil parameters:nil contentEncoding:nil];
}

- (NSData*) URLDataWithMediaType:(NSString**) returnMediaType
                      parameters:(NSDictionary<NSString*, NSString*>**) returnParameters
                 contentEncoding:(NSString**) returnEncoding { // TODO: add error parameter
    NSData* decoded = nil;
    if ([self.scheme isEqualToString:ILDataURLScheme]) { // it's a data URL!
        NSScanner* URIscanner = [NSScanner scannerWithString:self.absoluteString];
        NSString* mediaType = @"";
        NSMutableDictionary<NSString*, NSString*>* parameters = NSMutableDictionary.new;
        NSString* contentEncoding = nil;
        NSString* encoding = nil;
        NSString* dataString = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];
        // split encoding
        NSArray<NSString*>* encodingParts = [contentEncoding componentsSeparatedByString:@";"];
        for (NSString* part in encodingParts) {
            if ([@[ILDataURLUTF8Encoding, ILDataURLHexEncoding, ILDataURLBase64Encoding] containsObject:part]) {
                encoding = part;
            }
            else if ([part rangeOfString:@"/"].location != NSNotFound) { // it's a mediatype
                mediaType = part;
            }
            else if ([part rangeOfString:@"="].location != NSNotFound) { // it's a parameter
                NSArray<NSString*>* parameterParts = [part componentsSeparatedByString:@"="];
                parameters[parameterParts.firstObject] = parameterParts.lastObject;
            }
            // TODO: else report a media type decode error
        }

        [URIscanner scanUpToString:@"" intoString:&dataString];

        if (dataString) {
            dataString = dataString.stringByRemovingPercentEncoding; // remove any URL encoding in the data string

            if ([encoding isEqualToString:ILDataURLUTF8Encoding]) {
                // decode utf8
                decoded = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            }
            else if ([encoding isEqualToString:ILDataURLHexEncoding]) {
                // decode hex
                NSMutableData* buffer = NSMutableData.new;
                NSUInteger scanIndex = 0;
                unsigned int byte = 0;
                while (scanIndex < dataString.length) {
                    [[NSScanner scannerWithString:[dataString substringWithRange:NSMakeRange(scanIndex, 2)]] scanHexInt:&byte];
                    [buffer appendBytes:&byte length:1];
                    scanIndex += 2;
                }
                decoded = buffer;
            }
            else if ([encoding isEqualToString:ILDataURLBase64Encoding]) {
                // decode base64
                decoded = [NSData.alloc initWithBase64EncodedString:dataString options:0];
                // TODO: if decoded is nil, report a decoding error
            }
            else if (dataString) {
                // assume utf8
                decoded = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            }
        }

        if (returnMediaType) { *returnMediaType = mediaType; }
        if (returnParameters) { *returnParameters = parameters; }
        if (returnEncoding) { *returnEncoding = encoding; }
    }

    return decoded;
}

@end
