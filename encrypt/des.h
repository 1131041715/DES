//
//  des.h
//  encrypt
//
//  Created by 大碗豆 on 16/12/19.
//  Copyright © 2016年 大碗豆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface des : NSObject


// nsData 转16进制
//+ (NSString*)stringWithHexBytes2:(NSData *)sender length:(NSInteger)index;

/****** 加密 ******/
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;
/****** 解密 ******/
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key length:(NSInteger)index;


@end
