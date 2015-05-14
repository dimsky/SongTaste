//
//  NSObject+Property.m
//  CalendarLib
//
//  Created by  on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Property.h"
#import "objc/runtime.h"
//#import "NSDate+Category.h"

@implementation NSObject (Property)
- (NSArray *) allKeys {
    NSMutableArray* propertyArray = [[NSMutableArray alloc] init];

    Class clazz = [self class];
//    while (true) {  
//        if (clazz == NULL) {
//            break;
//        }
//        if ([NSStringFromClass(clazz) compare:@"NSObject"] == NSOrderedSame) {
//            break;
//        }
//        
//        u_int count;
//        objc_property_t* properties = class_copyPropertyList(clazz, &count);
//        for (int i = 0; i < count ; i++) {
//            const char* propertyName = property_getName(properties[i]);
//            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
//        }
//        free(properties);
//        
//        clazz = clazz.superclass;
//    }
    if (true) {  
        u_int count;
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count ; i++) {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
    }
    
//    objc_property_t* superproperties = class_copyPropertyList(self.superclass, &count);
//    for (int i = 0; i < count ; i++) {
//        const char* propertyName = property_getName(properties[i]);
//        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
//    }
//    free(superproperties);
    
    return [NSArray arrayWithArray:propertyArray];
}

+ (id)customClassWithProperties:(NSDictionary *)properties {
    return [[self alloc] initWithProperties:properties];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {    // Avoid crash for no property exist.
    NSLog(@"Undefined Key: %@", key);
}

- (id)initWithProperties:(NSDictionary *)properties {
    if (self = [self init]) {
        Class clazz = [self class];
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        NSArray *dictKeys = [properties allKeys];
        for (NSString *key in [self allKeys]) {
            id data = [properties objectForKey:key];
            if (data == nil) {
                for (NSString *k in dictKeys) {
                    if ([key compare:k options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                        data = [properties objectForKey:k];
                        break;
                    }
                }
            }
            
            if (data) {
                NSString *propertyAttribute = [NSString stringWithCString:property_getAttributes(class_getProperty(clazz, [key UTF8String])) encoding:NSUTF8StringEncoding];
                NSArray  *attributes = [propertyAttribute componentsSeparatedByString:@","];
                NSString *typeAttribute = [attributes objectAtIndex:0];
                NSString *propertyType = [typeAttribute substringFromIndex:1];
                //NSLog(@"key:%@ value:%@ attribute:%@", key, data, propertyType);
                if ([propertyType hasPrefix:@"@"] && [propertyType length] > 2) {
                    NSRange range = (NSRange){2,[propertyType length] - 3};
                    NSString *typeName = [propertyType substringWithRange:range];
                    if ([typeName compare:@"NSDate"] == 0) {
                        // hack way.
                        if ([data isKindOfClass:[NSDate class]]) {
                            [result setObject:data forKey:key];
                        }
                        else {
                            // asume it is a long long int.
                            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[(NSNumber*)data longLongValue] / 1000.0];
                            [result setObject:date forKey:key];
                        }
                    }
                    else if ([typeName compare:@"NSString"] == 0 || [typeName compare:@"NSDictionary"] == 0 || [typeName compare:@"NSArray"] == 0) {
                        [result setObject:data forKey:key];
                    }
                    else if ([typeName compare:@"NSMutableString"] == 0 || [typeName compare:@"NSMutableDictionary"] == 0 || [typeName compare:@"NSMutableArray"] == 0) {
                        [result setObject:data forKey:key];
                    }
                    else if ([typeName compare:@"NSNumber"] == 0){
                        [result setObject:data forKey:key];
                    }
                    else {
                        id obj = [[NSClassFromString(typeName) alloc] initWithProperties:data];
                        [result setObject:obj forKey:key];

                    }
                }
                else {
                    [result setObject:data forKey:key];
                }
            }
        }
        [self setValuesForKeysWithDictionary:result];
    }
    return self;
}

+ (id)objectWithProperties:(NSDictionary *)properties {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:properties];
    for (NSString *key in [dict allKeys]) {
        if ([dict objectForKey:key] == nil || [[dict objectForKey:key] isKindOfClass:[NSNull class]]) {
            [dict removeObjectForKey:key];
        }
    }
    id idValue = [properties objectForKey:@"id"];
    if (idValue && ![idValue isKindOfClass:[NSNull class]]) {
        [dict setObject:idValue forKey:@"ID"];
        [dict removeObjectForKey:@"id"];
    }
    return [[self alloc] initWithProperties:dict];
}

- (NSDictionary*)objectProperties {
//    NSDictionary *dictionary = [self dictionaryWithValuesForKeys:[self allKeys]];
//    NSArray *dictKeys = [dictionary allKeys];
//    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
//    for (NSString *key in dictKeys) {
//        id data = [dictionary objectForKey:key];
//        NSLog(@"key:%@ value:%@", key, data);
//        if ([data isKindOfClass:[NSDate class]]) {
//            NSDate *date = (NSDate*)data;
//            [result setObject:[NSNumber numberWithLongLong:[date toMilliSecond]] forKey:key];
//        }
//        else if (![data isKindOfClass:[NSNull class]] && data != nil){
//            [result setObject:data forKey:key];
//        }
//    }
//    return [result autorelease];
    return [self dictionaryWithValuesForKeys:[self allKeys]];
}

- (id)jsonObject {
    if ([NSStringFromClass([self class]) isEqualToString:@"NSObject"]) {
        // Not Support?
        return @"Not Supported";
    }

    if ([self isKindOfClass:[UIColor class]]) {
        CGFloat r,g,b,a;
        [(UIColor *)self getRed:&r green:&g blue:&b alpha:&a];
        return [NSString stringWithFormat:@"%02x%02x%02x%02x", (unsigned int)(a * 255), (unsigned int)(r * 255), (unsigned int)(g * 255), (unsigned int)(b * 255)];
    }
    NSMutableDictionary *jo = [[NSMutableDictionary alloc] init];
    for (NSString *key in [self allKeys]) {
        id value = [self valueForKey:key];

        if (value) {
            [jo setObject:[value jsonObject] forKey:key];
        }
    }
    return jo;
}
@end

@implementation NSArray (Property)
- (id)jsonObject {
    NSMutableArray *jo = [[NSMutableArray alloc] init];
    for (id obj in self) {
        [jo addObject:[obj jsonObject]];
    }
    return jo;
}
@end

@implementation NSDictionary (Property)
- (id)jsonObject {
    NSMutableDictionary *jo = [[NSMutableDictionary alloc] init];
    for (NSString *key in [self allKeys]) {
        id v = [self valueForKey:key];
        [jo setObject:[v jsonObject] forKey:key];
    }
    return jo;
}
@end

@implementation NSString (Property)
- (id)jsonObject {
    return self;
}
@end

@implementation NSNumber (Property)
- (id)jsonObject {
    if (strcmp((const char *)@encode(BOOL), (const char *)[self objCType]) == 0) {
        if ([self intValue] == 0) {
            return @"false";
        }
        else {
            return @"true";
        }
    }
    return self;
}
@end

@implementation NSDate (Property)
- (id)jsonObject {
    return self;
}
@end

@implementation UIImage (Property)
- (id)jsonObject {
    return @"";
}
@end

@implementation UIColor (Property)
- (id)jsonObject {
    CGFloat a,r,g,b;
    [(UIColor *)self getRed:&r green:&g blue:&b alpha:&a];
    return [NSString stringWithFormat:@"%02x%02x%02x%02x", (unsigned int)(a * 255), (unsigned int)(r * 255), (unsigned int)(g * 255), (unsigned int)(b * 255)];
}
@end
