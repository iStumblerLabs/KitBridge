#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import "ILPasteboard+KitBridge.h"

@implementation ILPasteboard (KitBridge)

#if IL_APP_KIT
/// Convert an NSPasteboardItem into a UIPasteboard item dictionary
+ (NSDictionary<NSString*,id>*) dictionaryForItem:(NSPasteboardItem*) item {
    NSMutableDictionary<NSString*,id>* itemDict = NSMutableDictionary.new;

    for (NSString* type in item.types) {
        itemDict[type] = [item dataForType:type];
    }

    return itemDict;
}

+ (NSPasteboardItem*) itemForDictionary:(NSDictionary<NSString*,id>*) itemDictionary {
    NSPasteboardItem* item = NSPasteboardItem.new;

    for (NSString* type in itemDictionary) {
        id itemValue = itemDictionary[type];
        if ([itemValue isKindOfClass:NSString.class]) {
            [item setString:(NSString*)itemValue forType:type];
        }
        else if ([itemValue isKindOfClass:NSDictionary.class] || [itemValue isKindOfClass:NSArray.class]) {
            [item setPropertyList:itemValue forType:type];
        }
        else if ([itemValue isKindOfClass:NSData.class]) {
            [item setData:(NSData*)itemValue forType:type];
        }
        else {
            NSLog(@"can't convert type: %@ itemValue: %@ in +ILPasteboard.itemForDictionary:", type, itemValue);
        }
    }

    return item;
}

// MARK: - UIPasteboard
+ (nullable instancetype) pasteboardWithName:(NSString*) name create:(BOOL) create {
    /// TODO: check for existance of pasteboard name and honor create
    return [NSPasteboard pasteboardWithName:name];
}

+ (void) removePasteboardWithName:(NSString*) name {
    ILPasteboard* board = [ILPasteboard pasteboardWithName:name create:NO];
    if (board) {
        [board clearContents];
        [board releaseGlobally];
    }
}

// MARK: - Determining types of pasteboard items
- (NSArray<NSString*>*) pasteboardTypes {
    return self.types;
}

- (BOOL) containsPasteboardTypes:(NSArray<NSString*>*)types {
    BOOL contains = NO;
    for (NSString* type in types) {
        UTType* searchType = [UTType typeWithIdentifier:type];
        for (NSString* myType in self.types) {
            contains = [[UTType typeWithIdentifier:myType] conformsToType:searchType];
            if (contains) {
                break; // for .. self.types
            }
        }
        if (contains) {
            break; // for .. types
        }
    }
    return contains;
}

// MARK: - Getting and setting pasteboard items
- (NSInteger) numberOfItems {
    return self.items.count;
}

- (NSArray<NSDictionary<NSString*,id>*>*) items {
    NSMutableArray<NSDictionary<NSString*,id>*>* itemArray = NSMutableArray.new;
    for (NSPasteboardItem* item in self.pasteboardItems) {
        [itemArray addObject:[ILPasteboard dictionaryForItem:item]];
    }
    return itemArray;
}

- (void) setItems:(NSArray<NSDictionary<NSString*,id>*>*) items {
    [self setItems:items options:nil];
}

// XXX: this writes all the items to the first pasteboard item using setData:forType & c.
- (void) addItems:(NSArray<NSDictionary<NSString *,id> *> *)items {
    for (NSDictionary<NSString*,id>* item in items) {
        for (NSString* type in item.allKeys) {
            [self setValue:item[type] forPasteboardType:type];
        }
    }
}

// XXX: this ignores the options
- (void) setItems:(NSArray<NSDictionary<NSString *,id> *> *)items options:(NSDictionary<NSString*,id>* _Nullable) options {
    [self prepareForNewContentsWithOptions:0];
    [self addItems:items];
}

- (nullable NSData*) dataForPasteboardType:(NSString*) type {
    return [self dataForType:type];
}

- (void) setData:(NSData*) data forPasteboardType:(NSString*) type {
    [self setData:data forType:type];
}

- (nullable id) valueForPasteboadType:(NSString*) type {
    id value = nil;

    if ((value = [self stringForType:type])) {}
    else if ((value = [self propertyListForType:type])) {}
    else if ((value = [self dataForType:type])) {}

    return value;
}

- (void) setValue:(id) value forPasteboardType:(NSString*) type {
    if ([value isKindOfClass:NSData.class]) {
        [self setData:(NSData*)value forType:type];
    }
    else if ([value isKindOfClass:NSString.class]) {
        [self setString:(NSString*)value forType:type];
    }
    else if ([value isKindOfClass:NSDictionary.class] || [value isKindOfClass:NSArray.class]) {
        [self setPropertyList:value forType:type];
    }
    else {
        NSLog(@"WARNING: can't convert type: %@ value: %@ in -ILPastebaord_setValue:forPasteboardType:", type, value);
    }
}

// MARK: - Getting and setting pasteboard items of standard data types

- (nullable NSString*) string {
    return [self stringForType:NSPasteboardTypeString];
}

- (void) setString:(NSString*) string {
    [self setString:string forType:NSPasteboardTypeString];
}
// TODO: @property(nullable, nonatomic, copy) NSArray<NSString*>* strings;

- (nullable ILImage*) image {
    NSData* imageData = [self dataForType:NSPasteboardTypePNG];
    if (!imageData) {
        imageData = [self dataForType:NSPasteboardTypeTIFF];
    }

    ILImage* image = nil;
    if (imageData) {
        image = [ILImage.alloc initWithData:imageData];
    }

    return image;
}

- (void) setImage:(ILImage*) image {
    NSData* imageData = image.TIFFRepresentation;
    [self setData:imageData forType:NSPasteboardTypeTIFF];
}
// TODO: @property(nullable, nonatomic, copy) NSArray<ILImage*>* images;

- (nullable NSURL*) URL {
    return [NSURL URLFromPasteboard:self];
}

- (void) setURL:(NSURL*) url {
    [url writeToPasteboard:self];
}
// TODO: @property(nullable, nonatomic, copy) NSArray<NSURL*>* URLs;

- (nullable ILColor*) color {
    return [ILColor colorFromPasteboard:self];
}

- (void) setColor:(ILColor*) color {
    [color writeToPasteboard:self];
}
// TODO: @property(nullable, nonatomic, copy) NSArray<ILColor*>* colors;

// MARK: - Checking Data Types

- (BOOL) hasColors {
    return [self containsPasteboardTypes:@[NSPasteboardTypeColor]];
}

- (BOOL) hasImages {
    return [self containsPasteboardTypes:@[NSPasteboardTypePNG, NSPasteboardTypeTIFF]];
}

- (BOOL) hasStrings {
    return [self containsPasteboardTypes:@[NSPasteboardTypeString]];
}

- (BOOL) hasURLs {
    return [self containsPasteboardTypes:@[NSPasteboardTypeURL]];
}
#endif

// MARK: - ILPasteboard

- (BOOL) isClear {
    return (self.numberOfItems == 0);
}

- (BOOL) hasItems {
    BOOL hasInfo = NO;
    for (NSDictionary<NSString*,id>* item in self.items) {
        for (NSString* key in item.allKeys) {
            if ([key rangeOfString:@"dyn." options:NSAnchoredSearch].location == NSNotFound) { // there is at least one non-dynaic item
                hasInfo = YES;
                break; // for key in item.allKeys
            }
        }
        if (hasInfo) {
            break; // for item in self.items
        }
    }
    return hasInfo;
}

// MARK: - NSCopying

- (instancetype) copyWithZone:(NSZone *)zone {
    ILPasteboard* copy = ILPasteboard.pasteboardWithUniqueName;
    copy.items = self.items;
    return copy;
}

// MARK: - NSCoding

- (void) encodeWithCoder:(NSCoder *)coder {
    NSData* encodedPasteboard = [NSKeyedArchiver archivedDataWithRootObject:self.items requiringSecureCoding:YES error:nil];
    [coder encodeDataObject:encodedPasteboard];
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    if ((self = ILPasteboard.pasteboardWithUniqueName)) {
        self.items = [coder decodeTopLevelObjectAndReturnError:nil];
    }
    return self;
}

@end
