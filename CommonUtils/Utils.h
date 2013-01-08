//
//  Utils.h

//

//  Copyright (c) 2012 Noot. All rights reserved.
//

#import <Foundation/Foundation.h>




#define FONT @"Collator"

#ifdef DEBUG
#   define DLog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...) do {} while (0)
#endif
// ALog always displays output regardless of the DEBUG setting
#define ALog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface Utils : NSObject

+ (NSString *) encryptPassword:(NSString *)str;
+ (NSString *)AESEncrypt:(NSString *)plainText;
+ (void)alertMsgWithTitle:(NSString *)title messge:(NSString *)msg;
+ (NSString *)formatDateForWebService:(NSDate *) inputDate;
+ (NSDate *)getLocalToday:(NSDate *)sourceDate;
+ (NSDate *)getDateOnly:(NSDate *)date;
+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string;

+ (NSString *)formatDateTodMMMyyyy:(NSDate *)inputDate;
+ (NSString *)formatDateTohhmm:(NSDate *)inputDate;
+ (NSString *)formatDateToddMMyyyy:(NSDate *)inputDate;
+ (NSString *)formatDate:(NSDate *)inputDate withPattern:(NSString *)pattern;
+ (BOOL)tranferTrueToBool:(NSString *)flag;

+ (NSInteger)transferTimeInterval:(NSTimeInterval) theTimeInterval withFlag:(unsigned int) unitFlag;
+ (NSString *) stringAppend:(id) first, ...;
+ (id)getDataFromUserDefaults:(NSString *)key;
+ (void)setDataToUserDefaults:(NSString *)key value:(id)object;
@end
