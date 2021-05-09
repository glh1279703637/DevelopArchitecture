//
//  JAppUtility.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 15/9/6.
//  Copyright (c) 2015年 Jeffrey. All rights reserved.
//

#import "JAppUtility.h"
#import "JAppViewTools.h"
#import <WebKit/WebKit.h>
#import "JConstantHelp.h"
#import <UserNotifications/UserNotifications.h>

@implementation JAppUtility

+(NSString*)funj_getTempPath:(NSString*)basepath name:(NSString*)fileName{
    NSString *temp=NSTemporaryDirectory();
    if(basepath)temp= [temp stringByAppendingString:basepath];
    if(fileName)temp= [temp stringByAppendingPathComponent:fileName];
    return temp;
}
+ (NSString *)funj_getDocumentPathWithFile:(NSString*)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentdir=[paths objectAtIndex:0];
    if(fileName){
        return [documentdir stringByAppendingPathComponent:fileName];
    }
    return documentdir;
}
+ (NSString *)funj_getCompleteWebsiteURL:(NSString *)urlStr{
    if(!urlStr)return nil;
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            if (([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                return nil;
            }
        }
    }
    return returnUrlStr;
}

+ (BOOL)funj_isFileExit:(NSString *)filepath
{
    if(filepath!=nil)
        return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    else
        return NO;
}
+ (BOOL)funj_createDirector:(NSString *)filepath
{
    if(filepath!=nil)
        return [[NSFileManager defaultManager] createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    else
        return NO;
}


+(NSString *)funj_md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str,(CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


+ (CGFloat)funj_getTextHeight:(NSString *)content f:(UIFont *)textFont w:(CGFloat)layoutwidth{
    CGSize textSize = CGSizeMake(layoutwidth,CGFLOAT_MAX);
    
    if(!textFont || !content || [content isKindOfClass:[NSNull class]]) return 0;
    textSize=[content boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil].size;
    
    return textSize.height+3;
}
+(CGFloat) funj_getTextWidth:(NSString *)text f:(UIFont *)font {
    
    CGSize textSize =CGSizeMake(MAXFLOAT, 60);
    if(!font || !text || [text isKindOfClass:[NSNull class]]) return 0;

    textSize=[text boundingRectWithSize:textSize options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    return textSize.width;
}
// 通过控件返回控件高度；
+ (CGFloat)funj_getTextHeightWithView:(UIView*)view  m:(CGFloat)maxHeight{
    CGSize textSize = CGSizeMake(view.frame.size.width,CGFLOAT_MAX);
    UIFont *font = nil;NSString *title = nil;
    if([view isKindOfClass:[UIButton class]]){
        font = [(UIButton*)view titleLabel].font;
        title =[(UIButton*)view titleLabel].text;
    }else if([view isKindOfClass:[UILabel class]] ||[view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]] ){
        font = [(UILabel*)view font];
        title =[(UILabel*)view text];
    }
    if(!font || !title || [title isKindOfClass:[NSNull class]])return 0;
    textSize=[title boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return MIN(textSize.height+3, maxHeight==-1?CGFLOAT_MAX:maxHeight);
}
//获得字符串的长度
+(CGFloat) funj_getTextWidthWithView:(UIView*)view{
    CGSize textSize =CGSizeMake(MAXFLOAT, view.frame.size.height);
    UIFont *font = nil;NSString *title = nil;
    if([view isKindOfClass:[UIButton class]]){
        font = [(UIButton*)view titleLabel].font;
        title =[(UIButton*)view titleLabel].text;
    }else if([view isKindOfClass:[UILabel class]] ||[view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]] ){
        font = [(UILabel*)view font];
        title =[(UILabel*)view text];
    }
    if(!font || !title || [title isKindOfClass:[NSNull class]])return 0;
    textSize=[title boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return textSize.width;
}

+(CGFloat)funj_getAttriTextHeightWithView:(UIView*)view m:(CGFloat)maxHeight{
    CGSize textSize = CGSizeMake(view.frame.size.width,CGFLOAT_MAX);
    NSMutableAttributedString *attri = nil;
    BOOL isNeedRemove = NO;
    if([view isKindOfClass:[UIButton class]]){
        attri = (NSMutableAttributedString*)[(UIButton*)view titleLabel].attributedText;
        isNeedRemove =[[(UIButton*)view titleLabel] numberOfLines] == 0;
    }else if([view isKindOfClass:[UILabel class]] ||[view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]] ){
        attri = (NSMutableAttributedString*)[(UILabel*)view attributedText];
        isNeedRemove =([view isKindOfClass:[UILabel class]] && [(UILabel*)view numberOfLines] == 0) || ([view isKindOfClass:[UITextView class]]);
    }
    
    if(isNeedRemove){
        if(![attri isKindOfClass:[NSMutableAttributedString class]]){
            attri =[[NSMutableAttributedString alloc]initWithAttributedString:attri];
        }
        [attri removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, attri.length)];
        NSMutableParagraphStyle*paragraphStyle =[[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 5;
        [attri addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attri.length)];
    }
    textSize =[attri boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return MIN(textSize.height+3, maxHeight==-1?CGFLOAT_MAX:maxHeight);
}


//图片压缩算法
//+ (UIImage *)funj_imageByScalingForSourceImage:(UIImage *)sourceImage targetViewSize:(CGSize)targetSize {
//    UIImage *newImage = nil;
//    CGSize imageSize = sourceImage.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    CGFloat targetWidth = targetSize.width;
//    CGFloat targetHeight = targetSize.height;
//    CGFloat scaleFactor = 0.0;
//    CGFloat scaledWidth = targetWidth;
//    CGFloat scaledHeight = targetHeight;
//    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
//    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
//        CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//
//        if (widthFactor < heightFactor)
//            scaleFactor = widthFactor; // scale to fit height
//        else
//            scaleFactor = heightFactor; // scale to fit width
//        scaledWidth  = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//    }
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = thumbnailPoint;
//    thumbnailRect.size.width  = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//    UIGraphicsBeginImageContext(thumbnailRect.size); // this will crop
//     [sourceImage drawInRect:thumbnailRect];
//
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    if(newImage == nil) CLog(@"could not scale image");
//
//    //pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//图片 压缩算法 上传时候处理
+(NSData *)funj_compressImageWithMaxLength:(UIImage*)image s:(CGFloat)sizeM{
    // Compress by quality
    if(sizeM == -1) sizeM = 0.4 + IS_IPAD * 0.3;
    NSInteger maxLength = 1024 * 1024 * sizeM;
    
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.8) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
//    CLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    CLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

+(UIImage *)funj_imageWithColor:(UIColor *)color s:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
//+ (UIImage*)funj_imageFromScreenShotView:(UIView*)view reView:(NSArray*)removeViews r:(CGRect)shotRect{
//    CGFloat scale = [UIScreen mainScreen].scale;
//    shotRect.size.width *= scale;shotRect.size.height *= scale;
//    UIGraphicsBeginImageContextWithOptions(shotRect.size,NO, scale);
//    if(!removeViews || [removeViews containsObject:view]){
//        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    }
//    for(UIView *subview in view.subviews) {
//        if(!removeViews || ![removeViews containsObject:subview]){
//            [subview drawViewHierarchyInRect:subview.frame afterScreenUpdates:YES];
//        }
//    }
//    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, shotRect);
//    UIImage *CGImg = [UIImage imageWithCGImage:ref];
//    CGImageRelease(ref);
//    return CGImg;
//}
//+ (NSString *) funj_hexFromUIColor: (UIColor*) color {
//    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
//        const CGFloat *components = CGColorGetComponents(color.CGColor);
//        color = [UIColor colorWithRed:components[0]
//                                green:components[0]
//                                 blue:components[0]
//                                alpha:components[1]];
//    }
//
//    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
//        return [NSString stringWithFormat:@"#FFFFFF"];
//    }
//
//    return [NSString stringWithFormat:@"#X%02x%02x%02x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
//            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
//            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
//}
//// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
//+ (UIColor *) funj_colorWithHexString: (NSString *)color
//{
//    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
//
//    // String should be 6 or 8 characters
//    if ([cString length] < 6) {
//        return [UIColor clearColor];
//    }
//
//    // 判断前缀并剪切掉
//    if ([cString hasPrefix:@"0X"])
//        cString = [cString substringFromIndex:2];
//    if ([cString hasPrefix:@"#"])
//        cString = [cString substringFromIndex:1];
//    if ([cString length] != 6)
//        return [UIColor clearColor];
//
//    // 从六位数值中找到RGB对应的位数并转换
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//
//    //R、G、B
//    NSString *rString = [cString substringWithRange:range];
//
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//
//    // Scan values
//    unsigned int r, g, b;
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//
//    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
//}

+(BOOL)funj_isPureInt:(NSString *)string{
    NSScanner *scan=[NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
+(NSString*)funj_getHiddenMobile:(NSString*)mobile{
    if(mobile.length<=0)return @"";
    NSInteger width = MIN(mobile.length,3);
    NSString *str = [NSString stringWithFormat:@"%@***%@",[mobile substringToIndex:width],[mobile substringFromIndex:MAX(mobile.length-width, 0)]];
    return str;
}

//判断手机号码，电话号码函数
+(BOOL)funj_isMobileNumber:(NSString*)mobileNum{
    
    NSString *MOBILE = @"^1[0-9][0-9]\\d{8}$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    if (([regexMobile evaluateWithObject:mobileNum] == YES)) return YES;
    return NO;
    
}
+(BOOL)funj_isCheckNameIsRight:(NSString*)name{
    NSString *MOBILE = @"([0-9a-zA-Z]){6,17}";//只有数据字母
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    if ([regexMobile evaluateWithObject:name] == YES){
        return YES;
    }
    
    return NO;
}
//邮箱地址的正则表达式
+ (BOOL)funj_isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)funj_isCheckMobile_Password_CodeIsRight:(UIViewController*)viewController d:(NSDictionary*)data{
    NSString *allName = data[@"allName"];
    NSString *email = data[@"email"];
    NSString *name = data[@"name"];
    NSString *mobile = data[@"mobile"];
    NSString *oldMobile = data[@"oldMobile"];
    NSString *code = data[@"code"];
    NSString *oldCode = data[@"oldCode"];
    NSString *password = data[@"password"];
    NSString *surePassword = data[@"surePassword"];
    NSString *answer = data[@"answer"];;
    NSString *isAgree = data[@"isAgree"];
    NSString *title = nil;
    if(allName && (![JAppUtility funj_isCheckNameIsRight:allName] && [allName rangeOfString:@"@"].length <=0)){
        title = LocalStr(@"Please input account with 6-17 letters and numbers");
    }
    if(allName &&  [allName rangeOfString:@"@"].length >0  &&  ![JAppUtility funj_isValidateEmail:allName]  && !title){
        title = LocalStr(@"Please input correct email");
    }
    
    if(name && (![JAppUtility funj_isCheckNameIsRight:name] || [JAppUtility funj_isPureInt:name])  && !title){
        title = LocalStr(@"Please input account with 6-17 letters and numbers");
    }
    if(email &&  ![JAppUtility funj_isValidateEmail:email]  && !title){
        title = LocalStr(@"Please input correct email");
    }
    if(oldMobile && oldMobile.length<=0){
        title = LocalStr(@"Mobile is required");
        if(oldMobile || code) title = [NSString stringWithFormat:@"%@%@",LocalStr(@"Original"),title];
    }
    if(oldMobile && ![JAppUtility  funj_isMobileNumber:oldMobile] && !title){
        title = [NSString stringWithFormat:LocalStr(@"Please input correct %@ mobile"),LocalStr(@"Original")] ;
    }
    if(mobile && mobile.length<=0   && !title){
        title = LocalStr(@"Mobile is required");
        if(oldMobile || code) title = [NSString stringWithFormat:@"%@%@",LocalStr(@"New"),title];
    }
    if(mobile && ![JAppUtility  funj_isMobileNumber:mobile] && !title){
        title = [NSString stringWithFormat:LocalStr(@"Please input correct %@ mobile"),(oldMobile || code)?LocalStr(@"New"):@""] ;
    }
    if(mobile && oldMobile && !title){
        title = LocalStr(@"Old and new mobile cannot be the same");
    }
    if(oldCode && !([JAppUtility funj_isPureInt:oldCode] && oldCode.length==6) && !title){
        title = [NSString stringWithFormat:LocalStr(@"Please input correct %@ verification number"),(oldMobile || code)?LocalStr(@"Original"):@""] ;
    }
    if(code && !([JAppUtility funj_isPureInt:code] && code.length==6) && !title){
        title = [NSString stringWithFormat:LocalStr(@"Please input correct %@ verification number"),(oldMobile || code)?LocalStr(@"New"):@""] ;
    }
    if(password&& ([password length]<6 || [password length] >16) && !title){
        title= LocalStr(@"Please input password between 6 and 16 bits");
    }
    if(surePassword && ![surePassword isEqualToString:password] && !title){
        title= LocalStr(@"Password is not consistent");
    }
    if(answer&& [answer length]<=0  && !title){
        title = LocalStr(@"Please input the answer");
    }
    if(isAgree&& ![isAgree isEqualToString:@"1"] && !title){
        title = LocalStr(@"Please click to confirm the user agreement");
    }
    if(title){
        if(viewController)[JAppViewTools funj_showAlertBlock:viewController t:nil msg:title items:nil c:nil];
        return NO;
    }
    return YES;
}

//对象转化成字符串  nssarray->string or....
+(NSString*)funj_stringFromObject:(id)object{
    if(!object)return nil;
    NSString *jsonString = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted  error:NULL];
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//字符串转化成对象  string->nsarray or....
+(id)funj_objectFromString:(NSString*)jsonString{
    if (jsonString == nil || ![jsonString isKindOfClass:[NSString class]] || jsonString.length <=0) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
    return object;
    
}

+(NSString*)funj_getDateTime:(NSString*)format{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"%@",format?format:@"yyyyMMddHHmmss"]];
    return  [formatter stringFromDate:[NSDate date]];
}

+(id)getObjectWithClass:(NSString*)className{
    
    return  [[NSClassFromString(className) alloc]init];
}
+(void)funj_getTheTimeCountdownWithCode:(UIButton*)getCodeBt c:(UIColor*)defaultBoardColor{
    getCodeBt.userInteractionEnabled = NO;
    getCodeBt.selected=YES;
    getCodeBt.layer.borderColor = kColor_Line_Gray_Dark.CGColor;
    __block int timeout=60; //倒计时时间
    __weak typeof(getCodeBt)weakBt = getCodeBt;
    __weak typeof(defaultBoardColor)weakColor = defaultBoardColor;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(weakBt)strongBt = weakBt;
                __weak typeof(weakColor)strongColor = weakColor;
                //设置界面的按钮显示 根据自己需求设置
                [strongBt setTitle:NSLocalizedString(@"Get verification code",nil) forState:UIControlStateNormal];
                strongBt.userInteractionEnabled = YES;
                strongBt.selected=NO;
                strongBt.layer.borderColor = strongColor.CGColor;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(weakBt)strongBt = weakBt;
                NSString *title =[NSLocalizedString(@"Resend",nil) stringByAppendingFormat:@"(%@s)",strTime];
                [strongBt setTitle:title forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//是否含有表情
+ (BOOL)funj_stringContainsEmoji:(NSString *)string{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    
    return modifiedString.length != string.length;
}
+ (BOOL)funj_stringContainsNonChar:(NSString *)string{
    if(!string || string.length<=0)return YES;
    NSString *MOBILE = @"([0-9a-zA-Z.,~`!@#$%^&*\\(\\)|\{}\\[\\];:'\"/\\\\])+";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    return [regexMobile evaluateWithObject:string];
}
+ (NSString *) funj_pinyinFromChineseString:(NSString *)string {
    if(!string || ![string length]) return nil;
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+ (void)funj_shakeAnimationForView:(UIView *)view offset:(CGSize)offset{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - offset.width, position.y-offset.height);
    CGPoint right = CGPointMake(position.x + offset.width, position.y+ offset.height);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}
//color效果 放大缩小
+ (void)funj_changeColorAnimationForView:(UIView *)view{
    CALayer *viewLayer = view.layer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    animation.fromValue = (id)RGB(230, 230, 230, 0.5).CGColor;
    animation.toValue = (id)RGB(200, 200, 200, 0.8).CGColor;
    [animation setAutoreverses:YES];
    [animation setDuration:0.05];
    [animation setRepeatCount:1];
    
    [viewLayer addAnimation:animation forKey:nil];
}
//expand效果 放大缩小
+ (void)funj_expandAnimationForView:(UIView *)view{
    CALayer *viewLayer = view.layer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    animation.fromValue = [NSNumber numberWithFloat:0.9];
    animation.toValue = [NSNumber numberWithFloat:1.1];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}
+ (void) funj_transitionWithType:(NSString *) type subtype:(NSString *)subtype forView : (UIView *) view{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    //设置运动时间
    animation.duration = 0.4f;
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        //设置子类
        animation.subtype = subtype;
    }
    //设置运动速度
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}
// 去掉HTML标签
+ (NSString *)funj_filterHTML:(NSString *)html {
    if(!html || html.length<=0)return @"";
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
+(void)funj_clearWebViewCookies{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{ }];
}

+(NSString*)funj_getTextFieldLength:(NSString*)textFieldText  r:(NSRange)range t:(NSString*)string maxLen:(NSInteger)maxLength{
    if(textFieldText.length+string.length>maxLength){
        int insertLength = (int)maxLength-(int)textFieldText.length;
        insertLength = insertLength<=0?0:insertLength;
        
        int firstLength =range.location<textFieldText.length?(int)range.location:(int)textFieldText.length;
        int endLength =(int)maxLength-(int)range.location-(int)insertLength;
        endLength=endLength<=0?0:endLength;
        
        textFieldText = [NSString  stringWithFormat:@"%@%@%@",[textFieldText substringWithRange:NSMakeRange(0, firstLength)],[string substringWithRange:NSMakeRange(0, insertLength)],[textFieldText substringWithRange:NSMakeRange(range.location, endLength)]];
    }
    return textFieldText;
}
+(void)funj_checkAppStoreVersion:(NSString*)appleId{
    if(!appleId || appleId.length <=0)return;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    NSURLSessionDataTask *dataTask =  [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error && data){
                NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                if([receiveDic integerWithKey:@"resultCount"] <=0)return ;
                
                NSString *localVersion = [[[NSBundle  mainBundle]infoDictionary] stringWithKey:@"CFBundleShortVersionString"];
                for(NSDictionary *dic in [receiveDic objectForKey:@"results"]){
                    NSString *newVersion = [dic stringWithKey:@"version"];
                    if([localVersion compare:newVersion] < 0){
                        NSString *releaseNotes = dic[@"releaseNotes"];
                        NSArray *sumbitArr = @[@"取消",@"确定"];
                        if([releaseNotes rangeOfString:@";;。"].length > 0){ //如果更新日志中，有;;。 则会强制更新
                            sumbitArr = @[@"确定"];
                        }
                        NSInteger indexCount = sumbitArr.count - 1;
                        [JAppViewTools funj_showAlertBlock:[JAppViewTools funj_getTopViewcontroller] t:nil msg:releaseNotes items:sumbitArr c:^(id strongSelf, NSInteger index) {
                            if(index == indexCount){
//                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppstoreURL] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
                            }
                        }];
                        return;
                    }
                }
            }
        });
    }];
    [dataTask resume];
}
/*本地通知 显示结果
 *-- title
 *-- subtitle
 *-- content -- contentRightImage
 */
+(void)funj_postLocalNotifation:(NSString*)title s:(NSString*)subtitle b:(NSString*)body i:(NSString*)contentRightImage{
//第二步：新建通知内容对象
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subtitle;
    content.body = body;
    content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber]);
    content.sound = [UNNotificationSound defaultSound];
    
    if(contentRightImage){
        NSString *imageFile = [[NSBundle mainBundle] pathForResource:contentRightImage ofType:@"png"];
        if(imageFile){
            UNNotificationAttachment *imageAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"iamgeAttachment" URL:[NSURL fileURLWithPath:imageFile] options:nil error:nil];
            if(imageAttachment)content.attachments = @[imageAttachment];//虽然是数组，但是添加多个只能显示第一个
        }

    }
           
//第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
           
//第四步：创建UNNotificationRequest通知请求对象
    NSString *requertIdentifier = @"RequestIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
    
//第五步：将通知加到通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        CLog(@"Error:%@",error);
    }];
}
//冒泡排序
-(void)funj_bubbleSortWithArray:(NSMutableArray*)array{
    static int iiiid = 0;
    for(int i=0;i<array.count - 1 ;i++){
        for(int j=0;j<array.count -1 -i ;j++){
            if([array[j] intValue] > [array[j+1]intValue]){
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                NSLog(@"-- -- -- %d",iiiid ++ );
            }
        }
    }
    NSLog(@"-- - -- %@",array);
}
//快速排序
-(void) funj_quickSortArray:(NSMutableArray*)array l:(NSInteger)left r:(NSInteger)right{
    static int iiiid = 0;
    if(left > right ) return;
    
    NSInteger i = left ,j = right;
    //记录基数pivoty
    NSInteger key = [array[i] integerValue];
    while (i < j ) {
        while (i < j && key <= [array[j] integerValue]) {
            j -- ;
        }
        if(i < j ){
            array[i] = array[j];
        }
        while (i < j && [array[i] integerValue] <= key) {
            i ++;
        }
        if(i < j) {
            array[j] = array[i];
        }
    }
    array[i] = [NSString stringWithFormat:@"%zd",key];
    [self funj_quickSortArray:array l:left r:i -  1];
    [self funj_quickSortArray:array l: i + 1 r:right];
//    NSLog(@"-- - -- %@",array);
    NSLog(@"-- -- -- %d",iiiid ++ );
}
//直接选择排序
-(void)funj_selectSortWithArray:(NSMutableArray*)array{
    static int iiiid = 0;
    for(int i=0;i<array.count;i++){
        for(int j=i+1;j<array.count;j++){
            if(array[i] > array[j]){
                NSLog(@"-- -- -- %d",iiiid ++ );
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}
//堆排序
-(void)funj_heapSortWithArray:(NSMutableArray*)array {
    static int iiiid = 0;
    //循环建立初始堆
    for(NSInteger i = array.count / 2 ;i>=0;i--){
        [self funj_heapAdjustWithArray:array p:i l:array.count];
    }
    for(NSInteger j=array.count - 1;j>0;j--){
        //最后一个元素和第一个元素进行交换
        [array exchangeObjectAtIndex:j withObjectAtIndex:0];
        //筛选R[0]结点，得到i-1个结点的堆
        [self funj_heapAdjustWithArray:array p:0 l:j];
        NSLog(@"-- -- -- %d",iiiid ++ );
    }
    NSLog(@"-- - -- %@",array);
}
-(void)funj_heapAdjustWithArray:(NSMutableArray*)array p:(NSInteger)parentIndex l:(NSInteger)length {
    NSInteger temp = [array[parentIndex] integerValue];
    NSInteger child = 2 * parentIndex + 1 ; //左孩子
    while (child < length) {
        //如果有右孩子结点，并且右孩子结点的值大于左孩子结点，则选取右孩子结点
        if(child + 1 < length && [array[child] integerValue] < [array[child + 1] integerValue]){
            child ++ ;
        }
        //如果父结点的值已经大于孩子结点的值，则直接结束
        if(temp >= [array[child] integerValue]){
            break;
        }
        //把孩子结点的值赋值给父结点
        array[parentIndex] = array[child];
        
        //选取孩子结点的左孩子结点，继续向下筛选
        parentIndex = child;
        child = 2 * child + 1;
    }
    array[parentIndex] = [NSString stringWithFormat:@"%zd",temp];
}
-(void)funj_insertSortWithArray:(NSMutableArray*)array {
    static int iiiid = 0;
    NSInteger j ;
    for(NSInteger i = 1;i<array.count;i++){
        NSInteger temp = [array[i] integerValue];
        for(j= i - 1;j>=0 && temp < [array[j] integerValue];j --){
            array[j + 1] = array[j];
            array[j] = [NSString stringWithFormat:@"%zd",temp];
            NSLog(@"-- -- -- %d",iiiid ++ );
        }
    }
    NSLog(@"-- - -- %@",array);
}

-(void)funj_mergeSortWithArray:(NSMutableArray*)array l:(NSInteger)left r:(NSInteger)right {
    if(left >= right) return;
    NSInteger middle = (left + right) / 2;
    [self funj_mergeSortWithArray:array l:left r:middle];
    [self funj_mergeSortWithArray:array l:middle + 1 r:right];
    [self funj_mergeSortWithArray:array l:left m:middle r:right];
    
    NSLog(@"-- - -- %@",array);
}
-(void)funj_mergeSortWithArray:(NSMutableArray*)array l:(NSInteger)left m:(NSInteger)middle r:(NSInteger)right{
    NSMutableArray *copyArray = [NSMutableArray arrayWithCapacity:right - left + 1];
    [copyArray addObjectsFromArray:[array subarrayWithRange:NSMakeRange(left, right - left + 1)]];
    NSInteger i = left , j = middle + 1;
    //循环从left开始到right区间内给数组重新赋值，注意赋值的时候也是从left开始的，不要习惯写成了从0开始，还有都是闭区间
    for(NSInteger k = left;k<=right;k++){
        if(i > middle){
            array[k] = copyArray[j - left];
            j ++ ;
        }else if(j > right){
            array[k] = copyArray[i - left];
            i ++;
        }else if (copyArray[i - left] > copyArray[j - left]){
            array[k] = copyArray[j - left];
            j ++;
        }else {
            array[k] = copyArray[i - left];
            i ++;
        }
    }
}
//基数排序
- (void)funj_radixAscendingOrderSort:(NSMutableArray *)ascendingArr {
    NSMutableArray *buckt = [self createBucket];
    NSNumber *maxnumber = [self listMaxItem:ascendingArr];
    NSInteger maxLength = numberLength(maxnumber);
    for (int digit = 1; digit <= maxLength; digit++) {
        // 入桶
        for (NSNumber *item in ascendingArr) {
            NSInteger baseNumber = [self fetchBaseNumber:item digit:digit];
            NSMutableArray *mutArray = buckt[baseNumber];
            [mutArray addObject:item];
        }
        NSInteger index = 0;
        for (int i = 0; i < buckt.count; i++) {
            NSMutableArray *array = buckt[i];
            while (array.count != 0) {
                NSNumber *number = [array objectAtIndex:0];
                ascendingArr[index] = number;
                [array removeObjectAtIndex:0];
                index++;
            }
        }
    }
    NSLog(@"希尔升序排序结果：%@", ascendingArr);
}

- (NSMutableArray *)createBucket {
    NSMutableArray *bucket = [NSMutableArray array];
    for (int index = 0; index < 10; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [bucket addObject:array];
    }
    return bucket;
}

- (NSNumber *)listMaxItem:(NSArray *)list {
    NSNumber *maxNumber = list[0];
    for (NSNumber *number in list) {
        if ([maxNumber integerValue] < [number integerValue]) {
            maxNumber = number;
        }
    }
    return maxNumber;
}

NSInteger numberLength(NSNumber *number) {
    NSString *string = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
    return string.length;
}

- (NSInteger)fetchBaseNumber:(NSNumber *)number digit:(NSInteger)digit {
    if (digit > 0 && digit <= numberLength(number)) {
        NSMutableArray *numbersArray = [NSMutableArray array];
        NSString *string = [NSString stringWithFormat:@"%ld", [number integerValue]];
        for (int index = 0; index < numberLength(number); index++) {
            [numbersArray addObject:[string substringWithRange:NSMakeRange(index, 1)]];
        }
        NSString *str = numbersArray[numbersArray.count - digit];
        return [str integerValue];
    }
    return 0;
}
@end

@implementation JAppUtility (JClearCache)
//内存的清理
-(void)funj_startToclearCach:(NSInteger)section{
//    [self funj_showProgressView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger typeArr[2] = {NSCachesDirectory,NSDocumentDirectory};
        for(int i=0;i<2;i++){
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(typeArr[i],NSUserDomainMask, YES) objectAtIndex:0];
            [self funj_solveclearCach:cachPath];
        }
        [self performSelectorOnMainThread:@selector(funj_clearCacheSuccess:) withObject:[NSString stringWithFormat:@"%zd",section] waitUntilDone:YES];
    });
}
-(void)funj_solveclearCach:(NSString*)cachPath{
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *p in files) {
        if(!([cachPath rangeOfString:@"Caches"].length > 0 || ([cachPath rangeOfString:@"Documents"].length > 0 && ([p hasPrefix:@"log"] || [p hasPrefix:@"NIMSDK"])))) continue;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        BOOL isDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
        if(isDir){
            [self funj_solveclearCach:path];
        }else{
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
    }
}
//清除成功
-(void)funj_clearCacheSuccess:(NSString*)section{
//    [self funj_closeLoadingProgressView];
//    [self.m_tableView reloadData];
}

@end
