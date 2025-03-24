#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

/// The pasteboard you use to perform ordinary cut, copy, and paste operations
#if IL_UI_KIT
#define ILPasteboardNameGeneral UIPasteboardNameGeneral
#elif IL_APP_KIT
#define ILPasteboardNameGeneral NSPasteboardNameGeneral
#endif

NS_ASSUME_NONNULL_BEGIN

// MARK: - ILPasteboardDetectionPattern

#if IL_UI_KIT
typedef UIPasteboardDetectionPattern ILPasteboardDetectionPattern NS_TYPED_ENUM;
#elif IL_APP_KIT
typedef NSString* ILPasteboardDetectionPattern NS_TYPED_ENUM;
#endif

/// A pattern that indicates the pasteboard detects a string that contains a calendar event.
/// the system reports the value as an array of NSDate, NSTimeZone, and a Boolean value to indicate an all-day event
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternCalendarEvent;

/// A pattern that indicates the pasteboard detects a string that contains an email address.
/// the system reports the value as an array of NSString
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternEmailAddress;

/// A pattern that indicates the pasteboard detects a string that contains a flight number.
/// the system reports the value as an array of NSString
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternFlightNumber;

/// A pattern that indicates the pasteboard detects of a string that contains a URL.
/// the system reports the value as an NSURL
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternLink;

/// A pattern that indicates the pasteboard detects a string that contains static ILPasteboardDetectionPattern an amount of money.
/// the system reports the value as an array of NSString and a Double.
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternMoneyAmount;

/// A pattern that indicates the pasteboard contains a string that consists of a numeric value.
/// it reports the value as an NSNumber.
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternNumber;

/// A pattern that indicates the pasteboard detects a string that contains a phone number.
/// the system reports the value as an array of NSString
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternPhoneNumber;

/// A pattern that indicates the pasteboard detects a string that contains a postal address.
///
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternPostalAddress;

/// A pattern that indicates the pasteboard contains a string suitable for use as a web search term.
/// it reports the value as an NSString.
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternProbableWebSearch;

/// A pattern that indicates the pasteboard contains a string that consists of a URL.
/// it reports the value as an NSString.
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternProbableWebURL;

/// A pattern that indicates the pasteboard detects a string that contains a parcel tracking number and carrier.
/// it reports the value as an NSString.
extern const ILPasteboardDetectionPattern ILPasteboardDetectionPatternShipmentTrackingNumber;

// MARK: -

@interface ILPasteboard (KitBridge) <NSCopying, NSCoding>

#if IL_APP_KIT
// MARK: - UIPasteboard
+ (nullable instancetype) pasteboardWithName:(NSString*) name create:(BOOL) create;
+ (void) removePasteboardWithName:(NSString*) name;

// MARK: - Detecting patterns of content in pasteboard items

- (void) detectPatternsForPatterns:(NSSet<ILPasteboardDetectionPattern>*) patterns
                 completionHandler:(void (^)(NSSet<ILPasteboardDetectionPattern>*, NSError*)) completionHandler;

- (void) detectPatternsForPatterns:(NSSet<ILPasteboardDetectionPattern>*) patterns
                         inItemSet:(NSIndexSet*) itemSet
                 completionHandler:(void (^)(NSArray<NSSet<ILPasteboardDetectionPattern>*>*, NSError*)) completionHandler;

- (void) detectValuesForPatterns:(NSSet<ILPasteboardDetectionPattern>*) patterns
               completionHandler:(void (^)(NSDictionary<ILPasteboardDetectionPattern, id>*, NSError*)) completionHandler;

- (void) detectValuesForPatterns:(NSSet<ILPasteboardDetectionPattern>*)patterns
                       inItemSet:(NSIndexSet*) itemSet
               completionHandler:(void (^)(NSArray<NSDictionary<ILPasteboardDetectionPattern, id>*>*, NSError*)) completionHandler;

// MARK: - Determining types of pasteboard items
@property(nonatomic, readonly) NSArray<NSString*>* pasteboardTypes;

// TODO: pasteboardTypesForItemSet:
- (BOOL) containsPasteboardTypes:(NSArray<NSString*>*) types;
// TODO: containsPasteboardTypes:inItemSet:
// TODO: itemSetWithPasteboardTypes:

// MARK: - Getting and setting pasteboard items
@property(nonatomic, readonly) NSInteger numberOfItems;
@property(nonatomic, copy) NSArray<NSDictionary<NSString*,id>*>* items;

- (void) addItems:(NSArray<NSDictionary<NSString*,id>*>*) items;
- (void) setItems:(NSArray<NSDictionary<NSString*,id>*>*) items options:(nullable NSDictionary<NSString*,id>*) options;
- (nullable NSData*) dataForPasteboardType:(NSString*) pasteboardType;
// TODO: dataForPasteboardType:inItemSet:
- (void) setData:(NSData*) data forPasteboardType:(NSString*) type;
- (nullable id) valueForPasteboadType:(NSString*) type;
// TODO: valuesForPasteboardType:inItemSet:
- (void) setValue:(id) value forPasteboardType:(NSString*) type;

// MARK: - Getting and setting pasteboard items of standard data types
@property(nullable, nonatomic, copy) NSString* string;
@property(nullable, nonatomic, copy) NSArray<NSString*>* strings;
@property(nullable, nonatomic, copy) ILImage* image;
@property(nullable, nonatomic, copy) NSArray<ILImage*>* images;
@property(nullable, nonatomic, copy) NSURL* URL;
@property(nullable, nonatomic, copy) NSArray<NSURL*>* URLs;
@property(nullable, nonatomic, copy) ILColor* color;
@property(nullable, nonatomic, copy) NSArray<ILColor*>* colors;

// MARK: - Checking Data Types
@property(nonatomic, readonly) BOOL hasImages;
@property(nonatomic, readonly) BOOL hasStrings;
@property(nonatomic, readonly) BOOL hasURLs;
@property(nonatomic, readonly) BOOL hasColors;

// MARK: - Getting and setting item providers
// TODO: setItemProviders:localOnly:expirationDate:
// TODO: setObjects:
// TODO: setObjects:localOnly:expirationDate:
#elif IL_UI_KIT

- (void) clearContents;
#endif

// MARK: - ILPasteboard

/// TRUE if the pasteboard is empty, either newley created or freshly cleared
@property(nonatomic,readonly) BOOL isClear;

/// TRUE if the pasteboard has any non "dyn." items
@property(nonatomic,readonly) BOOL hasItems;

- (BOOL) isEqualToPasteboard:(ILPasteboard*) pasteboard;

- (ILPasteboard*) deepCopy;

@end

// MARK: -

// TODO: Implement ILPasteboard for tvOS

NS_ASSUME_NONNULL_END
