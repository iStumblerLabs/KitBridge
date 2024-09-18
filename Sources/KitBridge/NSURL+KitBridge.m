#import "NSURL+KitBridge.h"

NSString* const ILDataURIScheme = @"data";
NSString* const ILDataURIUTF8Encoding = @"utf8";
NSString* const ILDataURIHexEncoding = @"hex";
NSString* const ILDataURIBase64Encoding = @"base64";

@implementation NSURL (KitBridge)

+ (NSURL*) dataURLWithData:(NSData*) data {
    NSString* encodedData = [data base64EncodedStringWithOptions:0];
    NSString* dataURL = [[ILDataURIScheme stringByAppendingString:@":;base64,"] stringByAppendingString:encodedData];
    return [NSURL URLWithString:dataURL];
}

// MARK: -

- (NSData*) URLData {
    return [self URLDataWithMediaType:nil parameters:nil contentEncoding:nil];
}

// formats which *should* work with this parser:
//
// data:,
// data:,0
// data:,Hello%20World
// data:;hex,EFBBBF
// data:application/octet-stream;base64,RUZCQkJG
// data:image/jpeg;base64,%2F9j%2F4AAQSkZJRgABAgAAZABkAAD
// data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4%2F%2F8%2Fw38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU
// data:text/vnd-example+xyz;foo=bar;base64,R0lGODdh <- double comma
// data:text/plain;charset=UTF-8;page=21,the%20data:1234,5678 <- double comma, implicit encoding
// data:image/svg+xml;utf8,%3Csvg%20width%3D'10'%20height%3D'10'%20xmlns%3D'http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg'%3E%3Ccircle%20style%3D'fill%3Ared'%20cx%3D'5'%20cy%3D'5'%20r%3D'5'%2F%3E%3C%2Fsvg%3E <- utf8 encoding
//
- (NSData*) URLDataWithMediaType:(NSString**) returnMediaType
                      parameters:(NSDictionary<NSString*, NSString*>**) returnParameters
                 contentEncoding:(NSString**) returnContentEncoding { // TODO: add error parameter
    NSData* decoded = nil;
    if ([self.scheme isEqualToString:ILDataURIScheme]) { // it's a data URL!
        NSScanner* URIscanner = [NSScanner scannerWithString:self.absoluteString];
        NSString* mediaType = @"";
        NSMutableDictionary<NSString*, NSString*>* parameters = NSMutableDictionary.new;
        NSString* contentEncoding = nil;
        NSString* data = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];
        // split encoding
        NSArray<NSString*>* encodingParts = [contentEncoding componentsSeparatedByString:@";"];
        for (NSString* part in encodingParts) {
            if ([@[ILDataURIUTF8Encoding, ILDataURIHexEncoding, ILDataURIBase64Encoding] containsObject:part]) {
                contentEncoding = part;
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

        [URIscanner scanUpToString:@"" intoString:&data];

        if ([contentEncoding isEqualToString:ILDataURIUTF8Encoding]) {
            // decode utf8
            decoded = [data dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([contentEncoding isEqualToString:ILDataURIHexEncoding]) {
            // decode hex
            NSMutableData* buffer = NSMutableData.new;
            NSUInteger scanIndex = 0;
            unsigned int byte = 0;
            while (scanIndex < data.length) {
                [[NSScanner scannerWithString:[data substringWithRange:NSMakeRange(scanIndex, 2)]] scanHexInt:&byte];
                [buffer appendBytes:&byte length:1];
                scanIndex += 2;
            }
            decoded = buffer;
        }
        else if ([contentEncoding isEqualToString:ILDataURIBase64Encoding]) {
            // decode base64
            decoded = [NSData.alloc initWithBase64EncodedString:data options:0];
        }

        if (returnMediaType) { *returnMediaType = mediaType; }
        if (returnParameters) { *returnParameters = parameters; }
        if (returnContentEncoding) { *returnContentEncoding = contentEncoding; }
    }

    return decoded;
}

@end
