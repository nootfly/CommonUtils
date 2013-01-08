//
//  Utils.m

//

//  Copyright (c) 2012 Noot. All rights reserved.
//

#import "Utils.h"
#import <sys/time.h>



#import <CommonCrypto/CommonCrypto.h>




@implementation Utils





+ (void) alertMsgWithTitle:(NSString *)title messge:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

+ (NSString *)formatDateForWebService:(NSDate *) inputDate
{
    double dateMills  = [inputDate timeIntervalSince1970] * 1000;
    return [[@"\/Date(" stringByAppendingFormat:@"%0.f",dateMills] stringByAppendingString:@")\/"];
    
}

+ (NSDate *)getLocalToday:(NSDate *)sourceDate
{
    
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
}

+(NSDate *)getDateOnly:(NSDate *)date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    return  [calendar dateFromComponents:components];
}

+ (long long)currentTimeMillis
{
    struct timeval t;
    gettimeofday(&t, NULL);
    
    return (((long long) t.tv_sec) * 1000) + (((long long) t.tv_usec) / 1000);
}





+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string {
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

+(NSString *)formatDateTodMMMyyyy:(NSDate *)inputDate
{
    return [self formatDate:inputDate withPattern:@"d MMM yyyy"];
}

+ (NSString *)formatDateToddMMyyyy:(NSDate *)inputDate
{
    return [self formatDate:inputDate withPattern:@"dd/MM/yyyy"];
}

+ (NSString *)formatDate:(NSDate *)inputDate withPattern:(NSString *)pattern
{
    if (!inputDate) {
        return @"";
    }
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:pattern options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    return [formatter stringFromDate:inputDate];
}

+(NSString *)formatDateTohhmm:(NSDate *)inputDate
{
    
    return [self formatDate:inputDate withPattern:@"HH:mm"];
    
}

+ (BOOL)tranferTrueToBool:(NSString *)flag
{
    if ([flag isEqualToString:@"true"]) {
        return YES;
    } else {
        return NO;
    }
}



+ (NSInteger)transferTimeInterval:(NSTimeInterval) theTimeInterval withFlag:(unsigned int) unitFlag
{
    
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    // unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlag fromDate:date1  toDate:date2  options:0];
    if (unitFlag == NSHourCalendarUnit) {
        return [conversionInfo hour];
    }
    if (unitFlag == NSMinuteCalendarUnit) {
        return [conversionInfo minute];
    }
    
    return 0;
    //    NSLog(@"Conversion: %dmin %dhours %ddays %dmoths",[conversionInfo minute], [conversionInfo hour], [conversionInfo day], [conversionInfo month]);
}

+ (NSString *) stringAppend:(id) first, ...
{
    NSString * result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
    	result = [result stringByAppendingString:first];
    	va_start(alist, first);
    	while (eachArg = va_arg(alist, id))
    		result = [result stringByAppendingString:eachArg];
    	va_end(alist);
    }
    return result;
}

+ (id)getDataFromUserDefaults:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)setDataToUserDefaults:(NSString *)key value:(id)object
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

@end
