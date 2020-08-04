//
//  JPickView.m
//  bimsopFM
//
//  Created by Jeffrey on 15/4/2.
//  Copyright © 2019 Jeffrey. All rights reserved.
//

#import "JPickView.h"
#import "JDateTime.h"
#import "JHttpReqHelp.h"
#import "JFileManageHelp.h"
#define kToobarHeight 40
#define kCountriesAndCity @"countriesAndcity"
@interface JPickView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    callBackSelector m_callback;
    PickType m_pickType;
    UIView *m_bgPickView;
    
    NSArray *m_contentKey,*m_idKey;
}
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;

@end
@implementation JPickView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame: frame]){
        UIImageView *m_m_blackImageView=[UIImageView funj_getBlackAlphaView:CGRectMake(0, 0, KWidth, KHeight)];
        //        [m_m_blackImageView funj_whenTouchedDown:^(UIView *sender) {
        //            [self removeFromSuperview];
        //        }];
          m_m_blackImageView.tag = 70;
        [self addSubview:m_m_blackImageView];
        _m_resultDic=[[NSMutableDictionary alloc]init];
        m_bgPickView=[UIView funj_getView:CGRectZero : [UIColor whiteColor] ];
        [self addSubview:m_bgPickView];m_bgPickView.tag = 71;
        [self  funj_addToolBar];
    }
    return self;
}

-(instancetype)initWithPlistName:(NSString *)plistName callback:(callBackSelector)callback{
    if(self=[super init]){
        self.plistName=plistName;
        m_pickType=PickPlistName;
        m_callback=callback;
        NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        self.plistArray=[[NSArray alloc] initWithContentsOfFile:path];//@[@[],@[]]
        NSAssert([[self.plistArray firstObject] isKindOfClass:[NSArray class]], @"plistArray 数组可能存在异常");
        [self funj_addSubm_pickerView];
        [self setFrameWith];
    }
    return self;
}

-(instancetype)initWithPlistType:(PickType )plistType callback:(callBackSelector)callback{
    if(self=[super init]){
        m_pickType=plistType;
        m_callback=callback;
        
        if(m_pickType==OnlyDate || m_pickType==DateAndTime || m_pickType==OnlyTime){
            self.plistArray=[self  funj_fillWithCalendar:m_pickType];
        }else{
            return self;
        }
        [self funj_addSubm_pickerView];
        [self setFrameWith];
    }
    return self;
}

-(instancetype)initWithPlistArray:(NSArray<NSArray*> *)plistarray callback:(callBackSelector)callback{
    if(self=[super init]){
        self.plistArray=plistarray; //@[@[],@[]]
        NSAssert([[self.plistArray firstObject] isKindOfClass:[NSArray class]], @"plistArray 数组可能存在异常2");
        m_callback=callback;
        m_pickType=PickPlistArray;
        [self funj_addSubm_pickerView];
        [self setFrameWith];
    }
    return self;
}
-(void)setFrameWith{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _m_pickerView.frame.size.height+kToobarHeight;
    CGFloat toolViewY ;
    toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    self.frame=CGRectMake(0, 0, KWidth, KHeight-KStatusBarHeight);
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    m_bgPickView.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
    m_bgPickView .backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:m_bgPickView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = m_bgPickView.bounds;
    maskLayer.path = maskPath.CGPath;
    m_bgPickView.layer.mask = maskLayer;
}
-(void)funj_setPickTitle:(NSString *)title :(NSArray *)contentName :(NSArray *)contentId{
    UILabel *titleLabel =[m_bgPickView viewWithTag:3902];
    titleLabel.text = title;
    m_contentKey = contentName;m_idKey = contentId;
}
-(void)funj_addToolBar{
    UILabel *titleLabel =[UILabel funj_getLabel:CGRectMake(80, 0, KWidth-80*2, kToobarHeight) :JTextFCMakeAlign(PUBLIC_FONT_SIZE17, COLOR_TEXT_BLACK, NSTextAlignmentCenter)];
    [m_bgPickView addSubview:titleLabel];titleLabel.tag =3902;
    
    UIButton *closeBt =[UIButton funj_getButtons:CGRectMake(KWidth-80, 0, 80, kToobarHeight) :nil  :JTextFCZero() :@[@"backBt2_h"] :self  :@"remove" :74 :^(UIButton *button) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0 );
    }];
    [m_bgPickView addSubview:closeBt];
    UIImageView *line =[UIImageView funj_getLineImageView:CGRectMake(0, kToobarHeight-1, KWidth, 1)];
    [m_bgPickView addSubview:line];
    
}
-(void)funj_addSubm_pickerView{
    _m_pickerView=[[UIPickerView alloc] init];
    _m_pickerView.backgroundColor=[UIColor lightGrayColor];
    _m_pickerView.delegate=self;
    _m_pickerView.dataSource=self;
    _m_pickerView.backgroundColor=[UIColor whiteColor];
    _m_pickerView.frame=CGRectMake(0, kToobarHeight,KWidth, _m_pickerView.frame.size.height);
    [m_bgPickView addSubview:_m_pickerView];
    [_m_pickerView reloadAllComponents];
}
-(NSArray*)funj_fillWithCalendar:(PickType)type{
    NSMutableArray* year=[[NSMutableArray alloc]init];
    NSMutableArray *month=[[NSMutableArray alloc]init];
    NSMutableArray* day=[[NSMutableArray alloc]init];
    NSMutableArray *hours=[[NSMutableArray alloc]init];
    NSMutableArray* minutes=[[NSMutableArray alloc]init];
    int count=0;
    for(int i=1949;i<=2100 ;i++){
        count++;
        [year addObject:[NSString stringWithFormat:@"%d",i]];
        if(count<=12) [month addObject:[NSString stringWithFormat:@"%02d",count]];
        if(count<=31) [day addObject:[NSString stringWithFormat:@"%02d",count]];
        if(count<=24) [hours addObject:[NSString stringWithFormat:@"%02d",count-1]];
        if(count<=60) [minutes addObject:[NSString stringWithFormat:@"%02d",count-1]];
        if(count > 60 && (!(type == DateAndTime || type == OnlyDate)))break;
    }
    if(type==DateAndTime){
        return @[year,month,day,hours,minutes];
    }else if(type==OnlyDate){
        return @[year,month,day];
    }else if(type==OnlyTime){
        return @[hours,minutes];
    }
    return @[];
}

-(void)remove{
    [self removeFromSuperview];
}
-(void)show{
    [[JAppViewTools funj_getKeyWindow] addSubview:self];
}
-(void)funj_doneClick{
    
    NSInteger index = [self.m_pickerView selectedRowInComponent:0];
    [self pickerView:nil didSelectRow:index inComponent:0];
    m_callback(_m_resultDic,YES);
    [self removeFromSuperview];
}
#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.plistArray.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if((m_pickType==DateAndTime ||m_pickType==OnlyDate) && component==2){
        NSInteger index0=[pickerView selectedRowInComponent:0];
        int year=[[_plistArray[0][index0] substringWithRange:NSMakeRange(0, 4)]intValue];
        
        NSInteger index1=[pickerView selectedRowInComponent:1];
        int month=[[_plistArray[1][index1] substringWithRange:NSMakeRange(0, 2)]intValue];
        return  [JDateTime funj_GetNumberOfDayByYear:year andByMonth:month];
    }else{
        return [self.plistArray[component] count];
    }
    return 0;
}
#pragma mark UIm_pickerViewdelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString *title=nil;
    CGFloat width=0;
    id content =_plistArray[component][row];
    if([content isKindOfClass:[NSDictionary class]]){
        NSAssert((m_contentKey[component] && m_idKey[component]), @"对象中key为空");
        title = [content valueForKey:m_contentKey[component]];
    }else{
        title = content;
    }
    width=[JAppUtility funj_getTextWidth:title textFont:[UIFont systemFontOfSize:20]]+10;
    UILabel *label=[UILabel funj_getLabel:CGRectMake(0, 0, width,30) :title:JTextFCMakeAlign([UIFont systemFontOfSize:20] ,nil, NSTextAlignmentCenter)];
    return label;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString* resultString=@"",*resultId=@"";
    NSString *conti = @"-";
    for (int i=0; i<_plistArray.count;i++) {
        if((m_pickType == DateAndTime && i >=3) || m_pickType == OnlyTime) conti = @":";
        NSString *title=nil,*idkey = nil;
        id content =_plistArray[i][[self.m_pickerView selectedRowInComponent:i]];
        if([content isKindOfClass:[NSDictionary class]]){
            title = [content valueForKey:m_contentKey[i]];
            idkey = [content valueForKey:m_idKey[i]];
        }else{
            title = content;
        }
        if(title)resultString=[NSString stringWithFormat:@"%@%@%@",resultString,conti,title];
        if(idkey) resultId =[NSString stringWithFormat:@"%@%@%@",resultId,conti,idkey];
    }
    if(resultString.length>0 ) resultString =[resultString substringFromIndex:1];
    if(resultId.length>0 ) resultId =[resultId substringFromIndex:1];
    
    [_m_resultDic setObject:resultString forKey:@"data"];
    [_m_resultDic setObject:resultId forKey:@"idKey"];
    
    if(pickerView)m_callback(_m_resultDic,NO);
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return KWidth/MAX(1, self.plistArray.count);
}

-(void)funj_setDefaultPicker:(NSArray*)array{
    for(int i=0;i<[array count];i++){
        NSArray *arr=_plistArray[i];
        for(int j=0;j<[arr count];j++){
            NSString *idkey = nil;
            if([arr[j] isKindOfClass:[NSString class]]){
                idkey = arr[j];
            }else if([arr[j] isKindOfClass:[NSDictionary class]]){
                NSAssert((m_contentKey[i] && m_idKey[i]), @"对象中m_idKey为空");
                idkey = [arr[j] objectForKey:m_idKey[i]];
            }
            if(idkey && [[NSString stringWithFormat:@"%@",idkey] isEqualToString: [NSString stringWithFormat:@"%@",array[i]]]){
                [_m_pickerView selectRow:j inComponent:i animated:YES];
                [_m_pickerView selectedRowInComponent:i];
                break;
            }
        }
    }
    [_m_pickerView reloadAllComponents];
}
-(void)dealloc{
    [self removeFromSuperview];
}

@end
