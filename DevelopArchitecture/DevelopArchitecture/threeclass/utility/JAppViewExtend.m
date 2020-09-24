//
//  JAppViewExtend.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 16/7/21.
//  Copyright © 2016年 Jeffrey. All rights reserved.
//

#import "JAppViewExtend.h"
#import <objc/runtime.h>
#import "JConstantHelp.h"
@implementation JAppViewExtend
@end
@implementation UIResponder (JBaseResponder)
-(void)funj_addNumberInputKeyAccesssoryTitleView{
    UIView *inputAccessoryView =[UIView funj_getView:CGRectMake(0, 0, KWidth, 50) :UIColorFromARGB(0xD1D4D9,1)];
    UIButton *sumBt =[UIButton funj_getButtonBlock:CGRectMake(KWidth-120, 0, 120, 50) :LocalStr(@"Confirm") :JTextFCMake(PUBLIC_FONT_BOLDSIZE17, COLOR_ORANGE) :nil  :0 :^(UIButton *button) {
        [[JAppViewTools funj_getKeyWindow] endEditing:YES];
    }];
    [sumBt funj_updateContentImageLayout:kRIGHT_CONTENTIMAGE a:JAlignMake(0, 0, 20)];
    [inputAccessoryView addSubview:sumBt];
    UITextField *textField = (UITextField*)self;
    textField.inputAccessoryView =inputAccessoryView;
}
-(void)funj_setTextFieldMaxLength:(NSInteger)maxLength t:(TEXTFINPUT_TYPE)type{
    if(!([self isKindOfClass:[JTextField class]] || [self isKindOfClass:[JTextView class]]))return;
    JTextField *weakSelf = (JTextField*)self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChangedToSubLength:)
                                                name:([self isKindOfClass:[JTextField class]] ?UITextFieldTextDidChangeNotification :UITextViewTextDidChangeNotification)
                                              object:nil];
    if(type >0){
        NSString*string = @"0000000";
        NSInteger maxIndex = string.length-1;
        do{
            if(type >> maxIndex){
                type = type-pow(2, maxIndex);
                string =[string stringByReplacingCharactersInRange:NSMakeRange(maxIndex  , 1) withString:@"1"];
            }
            maxIndex --;
        }while (type > 0);
        weakSelf.textFieldInsertTextInputType = string;
    }
    maxLength = maxLength > 0 ? maxLength : 1000;
    weakSelf.textFieldMaxLengthKey = [NSString stringWithFormat:@"%zd",maxLength];
}
-(void)textFiledEditChangedToSubLength:(NSNotification*)obj{
    JTextField *textField = (JTextField *)obj.object;
    if(!([textField isKindOfClass:[JTextField class]] || [textField isKindOfClass:[JTextView class]]))return;
    NSString *toBeString = textField.text;
    NSString *stringType =textField.textFieldInsertTextInputType;
    if(stringType && stringType.length >0){
        NSString *regexStr = @"";
        for(int i=0;i<stringType.length;i++){
            int types = [[stringType substringWithRange:NSMakeRange(i, 1)] intValue];
            if(i == 0 && types == 1) break;
            types = types == 1 ? i : -1;
            switch (types) {
                case 1:{
                    regexStr =[regexStr stringByAppendingString:@"0-9"];
                }break;
                case 2:{
                    regexStr =[regexStr stringByAppendingString:@"a-zA-Z"];
                }break;
                case 3:{
                    regexStr =[regexStr stringByAppendingString:@"\\u4E00-\\u9FC2"];
                }break;
                case 4:{
                    regexStr =[regexStr stringByAppendingString:@".,~`!@#$%^&*\\(\\)|\{}\\[\\];:'\"/\\\\_"];
                }continue;
                case 5:{
                    regexStr =[regexStr stringByAppendingString:@"\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n"];
                }break;
                    
                default:
                    break;
            }
        }
        if(regexStr.length >0){
            regexStr = [NSString stringWithFormat:@"[^%@]",regexStr];
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
            toBeString = [regex stringByReplacingMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length]) withTemplate:@""];
            regexStr = nil;
        }
        
    }
    NSString *numbers =textField.textFieldMaxLengthKey;
    if(!numbers || numbers.length <=0){
        textField.text = toBeString;
        return ;
    }
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if(([lang hasPrefix:@"zh-Han"])) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if(!position) {//没有高亮选择的字，则对已输入的文字进行字数统计和限制
            NSString *localIndex =textField.textFieldInsertLengthKey;
            
            if(toBeString.length > numbers.integerValue) {
                if(localIndex.integerValue < 0){
                    NSString *firstStr = [toBeString substringToIndex:abs(localIndex.intValue)];
                    
                    NSString *endStr = [toBeString substringWithRange:NSMakeRange(toBeString.length-(numbers.intValue - abs(localIndex.intValue)), numbers.integerValue-abs(localIndex.intValue))];
                    textField.text = [NSString stringWithFormat:@"%@%@",firstStr,endStr];
                    
                }else{
                    NSString *endStr = [toBeString substringWithRange:NSMakeRange(localIndex.intValue, numbers.integerValue-localIndex.intValue)];
                    NSString *firstStr = [toBeString substringToIndex:localIndex.intValue];
                    textField.text = [NSString stringWithFormat:@"%@%@",firstStr,endStr];
                }
            }else{
                textField.text = toBeString;
            }
        }else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            int localIndex = (int)[textField offsetFromPosition:textField.beginningOfDocument toPosition:position];
            textField.textFieldInsertLengthKey = [NSString stringWithFormat:@"%d",localIndex * (localIndex == numbers.intValue ?1:-1)];
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if(toBeString.length > numbers.integerValue) {
            int localIndex = (int)[textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
            
            if(localIndex< toBeString.length){
                NSString *firstStr = [toBeString substringToIndex:localIndex-1];
                
                NSString *endStr = [toBeString substringWithRange:NSMakeRange(toBeString.length-(numbers.intValue - localIndex+1), numbers.integerValue-localIndex+1)];
                textField.text = [NSString stringWithFormat:@"%@%@",firstStr,endStr];
                
            }else{
                NSInteger maxLength = numbers.integerValue-localIndex;
                maxLength = maxLength<0?0:maxLength;
                NSString *endStr = @"";
                if(localIndex + maxLength < toBeString.length){
                    endStr = [toBeString substringWithRange:NSMakeRange(localIndex, maxLength)];
                }
                NSString *firstStr = [toBeString substringToIndex:numbers.integerValue];
                textField.text = [NSString stringWithFormat:@"%@%@",firstStr,endStr];
            }
            
        }else{
            textField.text = toBeString;
        }
    }
}
-(void)funj_setViewCornerRadius:(CGFloat)cornerRadius{
    [self funj_setViewCornerLayer:JFilletMake(0, cornerRadius, COLOR_CREAR)];
}
-(void)funj_setViewCornerLayer:(FilletValue)fillet{
    if(![self isKindOfClass:[UIView class]])return;
    UIView *view = (UIView*)self;

    view.layer.borderWidth=fillet.borderWidth;
    if(fillet.borderColor) view.layer.borderColor=fillet.borderColor.CGColor;
    view.layer.cornerRadius=fillet.cornerRadius;
    view.layer.masksToBounds=YES;
}
-(void)funj_setViewShadowLayer{
    if(![self isKindOfClass:[UIView class]])return;
    UIView *view = (UIView*)self;
    if([view.backgroundColor isEqual:COLOR_WHITE])view.layer.shadowColor = COLOR_TEXT_BLACK.CGColor;
    else view.layer.shadowColor = view.backgroundColor.CGColor;//shadowColor阴影颜色
    view.layer.masksToBounds = NO;
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowOffset = CGSizeMake(3,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowRadius = 4;//阴影半径，默认3
}
-(CAGradientLayer*)funj_setViewGradientLayer:(BOOL)isX :(NSArray<UIColor*>*)colorArr :(NSArray*)locations{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    UIView *view = (UIView*)self;
    gradientLayer.frame = view.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(isX*1, (!isX)*1);
    //设置颜色数组
    gradientLayer.colors = @[(id)[colorArr[0] CGColor],
                             (id)[colorArr[1] CGColor]];
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = locations ; //@[@(0.f), @(1.f)];
    [view.layer insertSublayer:gradientLayer atIndex:0];
    return gradientLayer;
}
@end

@implementation UIView (ViewEx)
-(CGPoint)origin { return self.frame.origin ;}
-(CGSize)size { return self.frame.size ;}
-(CGFloat)height { return self.frame.size.height ;}
-(CGFloat)width { return self.frame.size.width ;}
-(CGFloat)top { return self.frame.origin.y ;}
-(CGFloat)left { return self.frame.origin.x ;}
-(CGFloat)bottom { return self.frame.origin.y + self.frame.size.height ;}
-(CGFloat)right { return self.frame.origin.x + self.frame.size.width ;}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame; frame.origin = origin;  self.frame = frame;
}
-(void)setSize:(CGSize)size{
    CGRect frame = self.frame; frame.size = size;  self.frame = frame;
}
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame; frame.size.height = height;  self.frame = frame;
}
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame; frame.size.width = width;  self.frame = frame;
}
-(void)setTop:(CGFloat)top{
    CGRect frame = self.frame; frame.origin.y = top;  self.frame = frame;
}
-(void)setLeft:(CGFloat)left{
    CGRect frame = self.frame; frame.origin.x = left;  self.frame = frame;
}
-(void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame; frame.origin.y = bottom - frame.size.height;  self.frame = frame;
}
-(void)setRight:(CGFloat)right{
    CGRect frame = self.frame; frame.origin.x = right - frame.size.width;  self.frame = frame;
}
@end

@implementation UITextView(JTextView)

+ (UITextView *)funj_getTextView:(CGRect)frame :(TextFC)textFC{
    JTextView *textView=[[JTextView alloc]initWithFrame:frame];
    if(textFC.textColor){
        textView.textColor=textFC.textColor;
    }
    if(textFC.textFont){
        textView.font=textFC.textFont;
    }
    
    return textView;
}
+ (UITextView *)funj_getTextViewFillet:(CGRect)frame  :(TextFC)textFC :(FilletValue)fillet{
    UITextView *textView=[self funj_getTextView:frame  :textFC];
    [textView funj_setViewCornerLayer:fillet];
    return textView;
}
+(UITextView *)funj_getLinkAttriTextView:(CGRect)frame :(NSString*)content attr:(NSDictionary<NSAttributedStringKey, id> *)attrs :(NSArray*)selectArr/*@[NSRange]*/ a:(id)target{
    UITextView *textView=[self funj_getTextView:frame  :JTextFCZero()];
    textView.scrollEnabled = NO;
    textView.editable = NO;textView.backgroundColor =[UIColor clearColor];
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc]initWithString:content attributes:attrs];
    textView.attributedText = attri;
    textView.textAlignment = NSTextAlignmentCenter;
    
    NSInteger index = 0;
    for(NSValue *value in selectArr){
        NSRange range = [value rangeValue];
        [attri addAttributes:@{NSForegroundColorAttributeName:COLOR_ORANGE} range:range];
        UITextPosition* startPosition = [textView positionFromPosition:textView.beginningOfDocument offset:range.location];
        UITextPosition* endPosition = [textView positionFromPosition:textView.beginningOfDocument offset:range.location+range.length];
        UITextRange* textRange = [textView textRangeFromPosition:startPosition toPosition:endPosition];
        CGRect frame = [textView firstRectForRange:textRange];
        frame.origin.y -= 5;frame.size.height += 10;
        UIButton *actionBt =[UIButton funj_getButtons:frame :nil  :JTextFCZero() :nil :target :@"funj_selectLinkAttriTo:" :10100+(index++) :nil];
        [textView addSubview:actionBt];
    }
    textView.attributedText = attri;
    textView.textAlignment = NSTextAlignmentCenter;
    
    return textView;
}
@end

@implementation UILabel(JLabels)

+ (UILabel *)funj_getLabel:(CGRect)frame :(NSString*)title :(TextFC)textFC{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    if(textFC.textFont){
        [label setFont:textFC.textFont];
    }else{
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    if(textFC.textColor){
        [label setTextColor:textFC.textColor];
    }else{
        [label setTextColor:[UIColor blackColor]];
    }
    label.textAlignment = textFC.alignment;
    
    if(title && ![title isKindOfClass:[NSNull class]])label.text=title;
    label.numberOfLines=0;
    label.backgroundColor=[UIColor clearColor];
    return label;
}
+ (UILabel *)funj_getLabel:(CGRect)frame :(TextFC)textFC{
    UILabel *label=[self funj_getLabel :frame:nil :textFC];
    return label;
    
}
+ (UILabel *)funj_getOneLabel:(CGRect)frame :(TextFC)textFC{
    UILabel *label=[self funj_getLabel:frame :nil :textFC];
    label.numberOfLines=1;
    [label setAdjustsFontSizeToFitWidth:YES];
    return label;
}
-(NSMutableAttributedString*)funj_updateAttributedText:(NSString*)title{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = self.textAlignment;
    //    paragraphStyle.firstLineHeadIndent = 30.0;//设置第一行缩进
    paragraphStyle.paragraphSpacing = 5;
    if(self.numberOfLines != 0)paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor,NSParagraphStyleAttributeName:paragraphStyle}];
    self.attributedText = attri;
    return attri;
}
@end


@implementation UIButton(JButtons)
AlignValue JAlignMake(CGFloat head,CGFloat spacing,CGFloat foot){
    AlignValue align;
    align.head = head;
    align.spacing = spacing;
    align.foot = foot;
    return align;
}

-(void)funj_setBlockToButton:(NSArray*)saveBgImageOrColor :(clickCallBack)block{}

//是否需要点击高亮 是否需要点击时selected变化
-(void)funj_updateButtonSelectStyle:(BOOL)isNeedSelectHightColor :(BOOL)isDefalutNeedToSelectChange{}
//点击button事件后，还原原来的状态。主要是添加 点击button 图片的变化作用，有点击效果
-(void)funj_resetButtonNormalState{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selected = NO;
    });
}
-(void)funj_addNormalDarkImage:(NSString*)image{}

//图片，文本 排列方式
-(void)funj_updateContentImageLayout:(ButtonContentImageLayout)layout s:(CGFloat)spacing{
    [self funj_updateContentImageLayout:layout a:JAlignMake(0, spacing , 0)];
}
-(void)funj_updateContentImageLayout:(ButtonContentImageLayout)layout a:(AlignValue)align{
    CGFloat textWidth =[JAppUtility funj_getTextWidthWithView:self];
    CGFloat selfWidth = self.frame.size.width;
    CGFloat imageWidth = self.imageView.frame.size.width;
    
    CGFloat selfHeight = self.frame.size.height;
    CGFloat imageHeight = self.imageView.frame.size.height;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    switch (layout) {
        case kLEFT_IMAGECONTENT:{// 图文 靠左
            self.imageEdgeInsets = UIEdgeInsetsMake(0, align.head, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, align.spacing+align.head, 0, -align.spacing + align.foot);
        }break;
        case kLEFT_CONTENTIMAGE:{// 文图 靠左
            textWidth = MIN(textWidth, selfWidth - imageWidth -align.spacing-align.head-align.foot);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth+align.head, 0, imageWidth+align.foot);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, textWidth+align.spacing+align.head, 0, -align.spacing+align.foot);
        }break;
        case kCENTER_IMAGECONTENT:{// 图文 靠中间 默认
            align.head = align.foot  = MIN(align.foot, align.head);
            textWidth = MIN(textWidth, selfWidth - imageWidth-align.spacing-align.head*2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, MAX((selfWidth-imageWidth-textWidth-align.spacing)/2, align.head) , 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0,  MAX((selfWidth-imageWidth-textWidth-align.spacing)/2, align.head)+align.spacing , 0, align.foot);
        }break;
        case kCENTER_CONTENTIMAGE:{// 文图 靠中间
            align.head = align.foot  = MIN(align.foot, align.head);
            textWidth = MIN(textWidth, selfWidth - imageWidth-align.spacing-align.head*2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0,  MAX((selfWidth-imageWidth-textWidth-align.spacing)/2, align.head)-imageWidth , 0, imageWidth+align.spacing+align.foot);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, MAX((selfWidth-imageWidth-textWidth-align.spacing)/2, align.head)+align.spacing+textWidth , 0, 0);
        }break;
        case kRIGHT_IMAGECONTENT:{// 图文 靠右
            textWidth = MIN(textWidth, selfWidth - imageWidth-align.spacing-align.foot-align.head);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, selfWidth-align.foot-align.spacing-textWidth-imageWidth, 0, 0);
             self.titleEdgeInsets = UIEdgeInsetsMake(0, selfWidth-textWidth-align.foot-imageWidth, 0, align.foot-1);
        }break;
        case kRIGHT_CONTENTIMAGE:{ // 文图 靠右
            textWidth = MIN(textWidth, selfWidth - imageWidth-align.spacing-align.foot-align.head);
            //上左下右
         self.titleEdgeInsets = UIEdgeInsetsMake(0, selfWidth-textWidth-align.foot-imageWidth*2-align.spacing, 0, 0);
         self.imageEdgeInsets = UIEdgeInsetsMake(0, selfWidth-imageWidth-align.foot, 0, align.foot);
        }break;
        case kTOP_IMAGECONTENT:{// 图文 上下
            align.head = align.foot  = MIN(align.foot, align.head);
            textWidth = MIN(textWidth, selfWidth -align.foot-align.head);
            
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            CGFloat textHeight =[JAppUtility funj_getTextHeightWithView:self  m:self.titleLabel.numberOfLines ==0?selfHeight-imageHeight:30];
            self.imageEdgeInsets = UIEdgeInsetsMake((selfHeight-imageHeight-textHeight)/2-align.spacing/2, (selfWidth-imageWidth)/2-2, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsMake((selfHeight-imageHeight-textHeight)/2+imageHeight+align.spacing/2,(selfWidth-textWidth)/2-imageWidth, 0, 0);
        }break;
            
        case kTOP_CONTENTIMAGE:{ // 文图 上下
            align.head = align.foot  = MIN(align.foot, align.head);
            textWidth = MIN(textWidth, selfWidth -align.foot-align.head);
            
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            CGFloat textHeight =[JAppUtility funj_getTextHeightWithView:self  m:self.titleLabel.numberOfLines ==0?selfHeight-imageHeight:30];
            self.titleEdgeInsets = UIEdgeInsetsMake((selfHeight-imageHeight-textHeight)/2-align.spacing/2, (selfWidth-textWidth)/2-imageWidth-2, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake((selfHeight-imageHeight-textHeight)/2+self.titleLabel.frame.size.height+align.spacing/2, (selfWidth-imageWidth)/2, 0, 0);
        }break;
        case kLEFT_CONTENT_RIGHT_IMAGE:{ // 左文 右图
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            self.titleEdgeInsets =UIEdgeInsetsMake(0, -imageWidth+align.head, 0, imageWidth+align.foot);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, selfWidth-imageWidth-align.foot, 0, -(selfWidth-imageWidth+align.foot));
        }break;
        default:
            break;
    }
}

+(UIButton*)funj_getButton:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(id)delegate :(NSString*)action :(NSInteger)tags{
    
    return [self funj_getButtonItems:frame :title :textFC :bgImageOrColor :NO :delegate :action :tags :nil];
}
+(UIButton*)funj_getButtonBlock:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(NSInteger)tags :(clickCallBack)block{
    
    return [self funj_getButtonItems:frame :title :textFC :bgImageOrColor :NO :nil :nil :tags :block];
    
}
+(UIButton*)funj_getButtons:(CGRect)frame :(NSString*)title :(TextFC)textFC  :(NSArray*)image :(id)delegate :(NSString*)action :(NSInteger)tags :(clickCallBack)setButton{
    UIButton *button=[self funj_getButtonItems:frame :title :textFC :image :YES :delegate :action :tags :nil];
    if(setButton)setButton(button);
    return button;
}

+(UIButton*)funj_getButtonBlocks:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)image :(NSInteger)tags :(clickCallBack)setButton :(clickCallBack)block{
    
    UIButton*button =[self funj_getButtonItems:frame :title :textFC :image :YES :nil :nil :tags :block ];
    if(setButton)setButton(button);
    return button;
    
}
+(UIButton*)funj_getButtonFillet:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(id)delegate :(NSString*)action :(NSInteger)tags :(FilletValue)fillet{
    UIButton *button= [self funj_getButtonItems:frame :title :textFC :bgImageOrColor :NO :delegate :action :tags :nil];
    [button funj_setViewCornerLayer:fillet];
    return button;
}

+(UIButton*)funj_getButtonBlockFillet:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(NSInteger)tags :(FilletValue)fillet :(clickCallBack)block{
    UIButton *button= [self funj_getButtonItems:frame :title :textFC :bgImageOrColor :NO :nil :nil :tags :block];
    [button funj_setViewCornerLayer:fillet];
    return button;
}

+(UIButton*)funj_getButtonItems:(CGRect)frame :(NSString*)title :(TextFC)textFC :(NSArray*)bgImageOrColor :(BOOL)isImage  :(id)delegate :(NSString*)action  :(NSInteger)tags :(clickCallBack)block{
    JButton *button=[[JButton alloc]initWithFrame:frame];
    if(title && ![title isKindOfClass:[NSNull class]]){
        [button setTitle:title forState:UIControlStateNormal];
    }
    if(textFC.textColor){
        [button setTitleColor:textFC.textColor forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    if(textFC.selectTextColor){
        [button setTitleColor:textFC.selectTextColor forState:UIControlStateSelected];
        [button setTitleColor:textFC.selectTextColor forState:UIControlStateHighlighted];
    }
    if(textFC.textFont)button.titleLabel.font=textFC.textFont;
    
    if(bgImageOrColor && [bgImageOrColor count]>=1){
        if([bgImageOrColor[0] isKindOfClass:[NSString class]] && [bgImageOrColor[0] length]>0){
            if(isImage){
                [button setImage:[UIImage imageNamed:bgImageOrColor[0]] forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:bgImageOrColor[0]] forState:UIControlStateNormal];
            }
        }else if([bgImageOrColor[0] isKindOfClass:[UIColor class]]){
            [button setBackgroundColor:bgImageOrColor[0]];
        }
        if(bgImageOrColor && [bgImageOrColor count]>=2){
            if([bgImageOrColor[1] isKindOfClass:[NSString class]] && [bgImageOrColor[1] length]>0){
                if(isImage){
                    [button setImage:[UIImage imageNamed:bgImageOrColor[1]] forState:UIControlStateSelected];
                    [button setImage:[UIImage imageNamed:bgImageOrColor[1]] forState:UIControlStateHighlighted];
                }else{
                    [button setBackgroundImage:[UIImage imageNamed:bgImageOrColor[1]] forState:UIControlStateSelected];
                    [button setBackgroundImage:[UIImage imageNamed:bgImageOrColor[1]] forState:UIControlStateHighlighted];
                }
            }
        }
    }
    button.tag=tags;
    
    //  [button addTarget:button action:NSSelectorFromString(@"clickButton:") forControlEvents:UIControlEventTouchUpInside];
    [button funj_setBlockToButton:bgImageOrColor :block];
    
    if(action){
        [button addTarget:delegate action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
     }
    return button;
    
}
@end



@implementation UIBarButtonItem(JBarButtonItem)

+ (UIBarButtonItem *)funj_getNavPublicButton:(id)target icon:(NSString*)icon action:(NSString*)action {
    UIButton *backButton=[UIButton funj_getButtons:CGRectMake(0, 0, 44, KNavigationBarHeight) :nil :JTextFCMake(nil, nil) :@[icon] :target :action :0 :nil];
    UIBarButtonItem* backBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}
+ (UIBarButtonItem *)funj_getNavPublicButton:(id)target title:(NSString*)title action:(NSString*)action image:(NSString*)image :(clickCallBack) setButton {
    UIButton *backButton=[UIButton funj_getButtons:CGRectMake(0, 0, 44, KNavigationBarHeight) :title :JTextFCMake([UIFont systemFontOfSize:14] , UIColorFromARGB(0x333333,1)) :image?@[image]:nil :target :action :0 :nil];
    if(setButton)setButton(backButton);
    UIBarButtonItem* backBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}

@end


@implementation UIView(Jview)

+(UIView*)funj_getView:(CGRect)frame :(UIColor*)bgColor{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    view.backgroundColor=bgColor;
    return view;
}
+(UIView*)funj_getViewFillet:(CGRect)frame :(UIColor*)bgColor :(FilletValue)fillet{
    UIView *view=[self funj_getView:frame :bgColor];
    [view funj_setViewCornerLayer:fillet];
    return view;
}
@end

@implementation UITextField(JTextField)
+(UITextField*)funj_getTextField:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC :(id)delegate :(NSInteger)tag{
    UITextField *textField=[self funj_getTextField:frame :placeholder :textFC :delegate :tag :UIKeyboardTypeDefault :UIReturnKeyDefault];
    return textField;
}
+(UITextField*)funj_getTextField:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC :(id)delegate :(NSInteger)tag :(UIKeyboardType)keyboardType :(UIReturnKeyType)returnKeyType{
    JTextField *textField=[[JTextField alloc]initWithFrame:frame];
    textField.borderStyle=UITextBorderStyleNone;
    textField.tag=tag;
    
    if(textFC.textFont){
        textField.font=textFC.textFont;
    }else{
        textField.font= [UIFont systemFontOfSize:16];
    }
    if(textFC.textColor){
        textField.textColor=textFC.textColor;
    }else{
        textField.textColor= [UIColor blackColor];
    }
    textField.textAlignment = textFC.alignment;
    
    if(placeholder && ![placeholder isKindOfClass:[NSNull class]]) textField.placeholder=placeholder;
    
    if(delegate) textField.delegate=delegate;
    textField.keyboardType=keyboardType;
    textField.returnKeyType=returnKeyType;
    if(textFC.alignment != NSTextAlignmentCenter){
        UIView *defaultView=[self funj_getView:CGRectMake(0, 0, 10, frame.size.height) :[UIColor clearColor]];
        textField.leftViewMode=UITextFieldViewModeAlways;
        UIView*bgview =[UIView funj_getView:CGRectMake(0, 0, 10, frame.size.height) :COLOR_CREAR];
        [bgview addSubview:defaultView];
        textField.leftView=bgview;
    }
    
    return textField;
}

+(UITextField*)funj_getTextFieldFillet:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC  :(id)delegate :(NSInteger)tag :(FilletValue)fillet{
    UITextField *textField=[self funj_getTextField:frame :placeholder :textFC :delegate :tag :UIKeyboardTypeDefault :UIReturnKeyDefault];
    [textField funj_setViewCornerLayer:fillet];
    return textField;
}

+(UITextField*)funj_getTextFieldFillet:(CGRect)frame :(NSString*)placeholder :(TextFC)textFC  :(id)delegate :(NSInteger)tag :(FilletValue)fillet :(UIKeyboardType)keyboardType :(UIReturnKeyType)returnKeyType{
    UITextField *textField=[self funj_getTextField:frame :placeholder :textFC :delegate :tag :keyboardType :returnKeyType];
    [textField funj_setViewCornerLayer:fillet];
    
    return textField;
}

@end



@implementation UIImageView(JImageView)

+(UIImageView*)funj_getImageView:(CGRect)frame image:(NSString*)image{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    if(image && image.length>0){
        imageView.image=[UIImage imageNamed:image];
    }
    return imageView;
}
+(UIImageView*)funj_getImageViewFillet:(CGRect)frame image:(NSString*)image :(FilletValue)fillet{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    if(image && image.length>0){
        imageView.image=[UIImage imageNamed:image];
    }
    [imageView funj_setViewCornerLayer:fillet];
    return imageView;
}
+(UIImageView*)funj_getImageView:(CGRect)frame bgColor:(UIColor*)bgColor{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    if(bgColor){
        imageView.backgroundColor=bgColor;
    }
    return imageView;
}


+(UIImageView*)funj_getLineImageView:(CGRect)frame{
    UIImageView *lineView=[self funj_getImageView:frame image:nil];
    lineView.backgroundColor=UIColorFromARGB(0xE1E1E1,1);
    return lineView;
}
+(UIImageView*)funj_getBlackAlphaView:(CGRect)frame{
    UIImageView *lineView=[self funj_getImageView:frame bgColor:COLOR_TEXT_BLACK_DARK];
    lineView.alpha = 0.3;
    lineView.userInteractionEnabled = YES;
    return lineView;
}
@end


@implementation UIScrollView(JScrollView)

+ (UIScrollView*)funj_getScrollView:(CGRect)frame :(id)delegate{
    UIScrollView* bgScrollView=[[UIScrollView alloc]initWithFrame:frame];
    if(@available(iOS 11.0,*)){
        bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    bgScrollView.delegate=delegate;
    bgScrollView.showsHorizontalScrollIndicator=NO;
    bgScrollView.showsVerticalScrollIndicator=NO;
    return bgScrollView;
}
@end

@implementation WKWebView(JWKWebView)
-(void)funj_removeScriptMessageHandler:(NSArray*)names{
    for(NSString*name in names){
        [self.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
}
-(void)funj_addScriptMessageHandler:(id<WKScriptMessageHandler>)strongSelf :(NSArray*)names{
    [self funj_removeScriptMessageHandler:names];
    for(NSString*name in names){
        [self.configuration.userContentController addScriptMessageHandler:strongSelf name:name];
    }
}
+ (WKWebView*)funj_getWKWebView:(CGRect)frame :(id)delegate :(NSString*)url{
    return [self funj_getWKWebView:frame :delegate :url :nil];
}
+ (WKWebView*)funj_getWKWebView:(CGRect)frame :(id)delegate :(NSString*)url :(void (^)(WKWebViewConfiguration *config))configCallback{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";  //禁止缩放
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    config.userContentController = wkUController;
    config.allowsInlineMediaPlayback = YES;
    config.allowsAirPlayForMediaPlayback = YES;
    
    if(configCallback)configCallback(config);
    WKWebView* webView=[[WKWebView alloc]initWithFrame:frame configuration:config];
    webView.opaque = NO; //不设置这个值 页面背景始终是白色 设置webview clearColor时使用
    webView.backgroundColor = COLOR_WHITE_DARK;
    webView.navigationDelegate = delegate;
    webView.scrollView.delegate = delegate;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    if(url){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[JAppUtility funj_getCompleteWebsiteURL:url]]];
        [webView loadRequest:request];
    }
    return webView;
}
+(void)funj_deallocWebView:(WKWebView*)webView{
    if(!webView || ![webView isKindOfClass:[WKWebView class]])return;
    if(webView.isLoading)[webView stopLoading];
    WKUserContentController*wkUController = webView.configuration.userContentController;
    [wkUController removeAllUserScripts];
    webView.navigationDelegate = nil;
    webView.scrollView.delegate = nil;
    webView.UIDelegate = nil;
    webView = nil;
}

@end

