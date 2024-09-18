#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: Data URI Constants

/// data: URI scheme
extern NSString* const ILDataURIScheme;

/// utf8 encoding
extern NSString* const ILDataURIHexEncoding;

/// hex encoding
extern NSString* const ILDataURIHexEncoding;

/// base64 encoding
extern NSString* const ILDataURIBase64Encoding;

// MARK: -

@interface NSURL (KitBridge)

/// @returns an RFC 2397 `data:` URL with the data provided
+ (NSURL*) dataURLWithData:(NSData*) data;

// MARK: -

/// attempt to parse the URL as an RFC 2397 `data:` URL and return the data
/// e.g.
/// `data:;hex,EFBBBF`
/// `data:application/octet-stream;base64,RUZCQkJG`
///
@property(nonatomic, readonly, nullable) NSData* URLData;

/// @returns the data parsed from this URL as a data URI
/// @param returnMediaType the media type of the data
/// @param returnParameters the parameters of the media type
/// @param returnContentEncoding the content encoding of the data
/// @ref https://datatracker.ietf.org/doc/html/rfc2397
///
/// In addition to the `base64` encoding in RFC 2397, the following encodings are supported:
/// - `hex`: hexadecimal encoding
/// - `utf8`: UTF-8 encoding
///
- (NSData*) URLDataWithMediaType:(NSString*_Nullable *_Nullable) returnMediaType
                      parameters:(NSDictionary<NSString*,NSString*>*_Nullable *_Nullable) returnParameters
                 contentEncoding:(NSString*_Nullable *_Nullable) returnContentEncoding;

@end

NS_ASSUME_NONNULL_END
