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

// MARK: -

@interface ILPasteboard (KitBridge)

#if IL_APP_KIT
// MARK: - UIPasteboard
+ (nullable instancetype) pasteboardWithName:(NSString*) name create:(BOOL) create;
+ (void) removePasteboardWithName:(NSString*) name;

// MARK: - Detecting patterns of content in pasteboard items
// TODO: detectPatternsForPatterns:completionHandler:
// TODO: detectPatternsForPatterns:inItemSet:completionHandler:
// TODO: detectValuesForPatterns:completionHandler:
// TODO: detectValuesForPatterns:inItemSet:completionHandler:

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
// TODO: @property(nullable, nonatomic, copy) NSArray<NSString*>* strings;
@property(nullable, nonatomic, copy) ILImage* image;
// TODO: @property(nullable, nonatomic, copy) NSArray<ILImage*>* images;
@property(nullable, nonatomic, copy) NSURL* URL;
// TODO: @property(nullable, nonatomic, copy) NSArray<NSURL*>* URLs;
@property(nullable, nonatomic, copy) ILColor* color;
// TODO: @property(nullable, nonatomic, copy) NSArray<ILColor*>* colors;

// MARK: - Checking Data Types
@property(nonatomic, readonly) BOOL hasColors;
@property(nonatomic, readonly) BOOL hasImages;
@property(nonatomic, readonly) BOOL hasStrings;
@property(nonatomic, readonly) BOOL hasURLs;

// MARK: - Getting and setting item providers
// TODO: setItemProviders:localOnly:expirationDate:
// TODO: setObjects:
// TODO: setObjects:localOnly:expirationDate:
#endif

// MARK: - ILPasteboard

/// TRUE if the pasteboard is empty, either newley created or freshly cleared
@property(nonatomic,readonly) BOOL isClear;

/// TRUE if the pasteboard has any non "dyn." items
@property(nonatomic,readonly) BOOL hasItems;

@end

// MARK: -

// TODO: Implement ILPasteboard for tvOS

NS_ASSUME_NONNULL_END