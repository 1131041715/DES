//
//  des.m
//  encrypt
//
//  Created by 大碗豆 on 16/12/19.
//  Copyright © 2016年 大碗豆. All rights reserved.
//

#import "des.h"


@implementation des
#pragma mark - DES_Mothed
/******************************************************************************
 函数描述 : 文本数据进行DES加密
 ******************************************************************************/
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
//    @"54 54 4d 4a 5f 32 33 34 01 01"
    
    //处理要加密的数据
    NSString *ciphertext = nil;
    NSData *textData = [self stringToByte:clearText];
    Byte *testByte = (Byte *)[textData bytes];
   /*
    for(int i=0;i<[textData length];i++){
        NSLog(@"%d",testByte[i]);
        int a = testByte[i];
        NSLog(@"%d\n",a);
    }
    */
    
    
    NSUInteger dataLength = [textData length];
//    NSLog(@"~~~~~~~~%zd",dataLength);
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    //处理key
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSASCIIStringEncoding);
    NSData *data = [key dataUsingEncoding:enc];
    Byte *byte = (Byte *)[data bytes];
    /*
    for (int i=0 ; i<[data length]; i++) {
        NSLog(@"byte = %d",byte[i]);
    }
     */

    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          byte, kCCBlockSizeDES,
                                          NULL,
                                          testByte  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    //buffer里面存放加密结果
    //ECBMode加密模式
    
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)dataLength];
        /*
        Byte *testByte = (Byte *)[data bytes];
        for(int i=0;i<[data length];i++){
            NSLog(@"%d",testByte[i]);
            int a = testByte[i];
            NSLog(@"%@\n",a);
        }
         */
        ciphertext = [self stringWithHexBytes1:data];
        
    }else{
        NSLog(@"DES加密失败");
    }
    
    free(buffer);
    return ciphertext;
}

//加密时将nsdata转成16进制字符串
+ (NSString*)stringWithHexBytes1:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    NSString *tempOne = [hexBytes lowercaseString];
    
    NSString *result = [self result:tempOne];
    
    free(strbuf);
    return result;
}

//分割字符串
+ (NSString *)result:(NSString *) tempOne {
    
    NSString *tempTow = [NSString new];
    
    NSString *result = [tempOne substringWithRange:(NSRange){0,2}];
    
    for (NSInteger i = 1; i < [tempOne length]/2; i++) {
        NSRange rang = {i*2,2};
        tempTow = [tempOne substringWithRange:rang];
        result = [result stringByAppendingFormat:@" %@",tempTow];
    }
    return result;
}



/******************************************************************************
 函数描述 : 文本数据进行DES解密
 ******************************************************************************/
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key length:(NSInteger)index
{
    
    //@"4a 9a 89 07 2d 99 97 d5 66 f7 d5 34 7a 3f da 89"
    NSString *cleartext = nil;
//    NSData *textData = [self parseHexToByteArray:plainText];
    NSData *textData = [self stringToByte:plainText];
        Byte *testByte = (Byte *)[textData bytes];
    /*

    for(int i=0;i<[textData length];i++){
        NSLog(@"%d",testByte[i]);
                int a = testByte[i];
                NSLog(@"%d\n",a);
    }
     */
    
    
    
    NSUInteger dataLength = [textData length];
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSASCIIStringEncoding);
    NSData *data = [key dataUsingEncoding:enc];
    Byte *byte = (Byte *)[data bytes];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode ,
                                          byte, kCCKeySizeDES,
                                          NULL,
                                          testByte  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)dataLength];
        
        
        cleartext = [self stringWithHexBytes2:data length:index];
    }else{
        NSLog(@"DES解密失败");
    }
    
    free(buffer);
    return cleartext;
}

//解密时nsdata转成16进制字符串
+ (NSString*)stringWithHexBytes2:(NSData *)sender length:(NSInteger )index{
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    NSString *tempOne = [hexBytes lowercaseString];

    NSString *tempTow = [NSString new];
    
    NSString *result = [tempOne substringWithRange:(NSRange){0,2}];
    
    for (NSInteger i = 1; i < index/2; i++) {
        NSRange rang = {i*2,2};
        tempTow = [tempOne substringWithRange:rang];
        result = [result stringByAppendingFormat:@" %@",tempTow];
    }
    free(strbuf);
    return result;
}



//从字符串中取字节数组
+(NSData*)stringToByte:(NSString*)string
{
    
    NSArray *stringUrlOne = [string componentsSeparatedByString:@" "];
    int len = (int)((stringUrlOne.count - 1)/8 +1) * 8;
    Byte dataB[len];
    NSMutableData* byteT=[NSMutableData data];
  
    
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
@end
