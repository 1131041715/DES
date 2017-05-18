//
//  ViewController.m
//  encrypt
//
//  Created by 大碗豆 on 16/12/19.
//  Copyright © 2016年 大碗豆. All rights reserved.
//

#import "ViewController.h"
#import "des.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *data = @"54 54 4d 4a 5f 32 33 34 01 01";
    
    NSString *result = [des encryptUseDES:data key:@"SDtt1234"];
    
    NSLog(@"--------%@",result);
    
    NSArray *tempArr = [data componentsSeparatedByString:@" "];
    
    NSString *denc = [des decryptUseDES:result key:@"SDtt1234" length:tempArr.count * 2];
    
    NSLog(@"--------%@",denc);
    
    

    NSString *string1 = [NSString stringWithFormat:@"5D"];
    
    const char *result1 = [string1 UTF8String];
    
//    char字符转成NSstring
    
//    char a[10] = "3Er4";
//    
//    NSString *string = [NSString stringWithUTF8String:a];
    
//    将char类型字符转成十进制类型，然后需要什么样的进制类型都可以直接转换了
    
    unsigned long num = strtoul(result1, 0, 16);
    
    NSLog(@"%lu",num);
    
    NSLog(@"%0lx",num);
    
    NSLog(@"%0lX",num);
  
}

//从字符串中取字节数组
+(NSData*)StringToByte:(NSString*)string
{
    
    NSArray *stringUrlOne = [string componentsSeparatedByString:@" "];
    int len = (int)((stringUrlOne.count - 1)/8 +1) * 8;
    Byte dataB[len];
    NSMutableData* byteT=[NSMutableData data];
    
//    int a;
    
    for (NSInteger i = 0; i < stringUrlOne.count; i++) {
        
        //十六进制转化成十进制
        dataB[i] = strtoul([stringUrlOne[i] UTF8String],0,16);
    }
    
    for (NSInteger j = stringUrlOne.count; j < len; j ++) {
        dataB[j] = 0;
    }
    
    [byteT appendBytes:dataB length:len];
    
    return byteT;
}

//十进制到16进制的转换
+ (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
