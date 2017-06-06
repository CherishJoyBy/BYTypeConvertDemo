//
//  ViewController.m
//  BYTypeConvertDemo
//
//  Created by lby on 2017/1/16.
//  Copyright © 2017年 lby. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* 测试代码*/
    
    // NSString - NSData
    NSString *testStr1 = @"better";
    NSData *testData1 = [testStr1 dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"testData:%@",testData1);
    
    // NSData - NSString
    NSString *testStr2 = [[NSString alloc] initWithData:testData1 encoding:NSUTF8StringEncoding];
    NSLog(@"testStr:%@",testStr2);
    
    // NSDate - Byte数组
    NSString *testStr3 = @"better";
    NSData *testData2 = [testStr3 dataUsingEncoding: NSUTF8StringEncoding];
    Byte *testByte1 = (Byte *)[testData2 bytes];
    for (int i = 0; i < [testData2 length]; i++)
    {
        NSLog(@"%d",testByte1[i]);
    }
    
    // Byte数组 - Data
    Byte byteArr[] = {98,101,116,116,101,114};
    NSData *testData3 = [[NSData alloc] initWithBytes:byteArr length:sizeof(byteArr)/sizeof(Byte)];
    NSLog(@"%@",testData3);
    
    // Byte数组 - int数组
    int intArr[6];
    for (NSInteger i = 0; i < sizeof(byteArr)/sizeof(Byte); i++)
    {
        intArr[i] = byteArr[i];
        NSLog(@"intArr[%ld] = %d",i,intArr[i]);
    }
    
    // 10 - 16
    NSString *testHexStr = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%x",190]];
    NSLog(@"%@",testHexStr);
    
    // 16 -10
    NSUInteger testData4 = strtoul([testHexStr UTF8String],0,16);
    NSLog(@"%zd",testData4);
    
    // 10 - 16
    NSLog(@"%@",[self convertHexStrWithDecimal:703710]);
    
    // 16 - 10
    NSLog(@"%@",[self convertDecimalWithHexStr:@"AbCdE"]);
}

// 十六进制转十进制
- (NSString *)convertDecimalWithHexStr:(NSString *)hexStr
{
    int decimal = 0;
    UniChar hexChar = ' ';
    NSInteger hexLength = [hexStr length];
    
    for (NSInteger i = 0; i < hexLength; i++)
    {
        int base;
        hexChar = [hexStr characterAtIndex:i];
        
        if (hexChar >= '0' && hexChar <= '9')
        {
            // 0 的Ascll - 48
            base = (hexChar - 48);
        }
        else if (hexChar >= 'A' && hexChar <= 'F')
        {
            // A 的Ascll - 65
            base = (hexChar - 55);
        }
        else
        {
            // a 的Ascll - 97
            base = (hexChar - 87);
        }
        decimal = decimal + base * pow(16, hexLength - i - 1);
    }
    
    return [NSString stringWithFormat:@"%d",decimal];
}

// 十进制转十六进制
- (NSString *)convertHexStrWithDecimal:(NSInteger)decimal
{
    NSMutableString *HexStr = [NSMutableString string];
    NSString *currentStr = [NSString string];
    
    // 余数
    NSInteger remainder = 0;
    // 商
    NSInteger quotient = 0;
    do
    {
        // 余数
        remainder = decimal % 16;
        quotient = decimal / 16;
        switch (remainder)
        {
            case 10:
                currentStr = @"a";
                break;
            case 11:
                currentStr = @"b";
                break;
            case 12:
                currentStr = @"c";
                break;
            case 13:
                currentStr = @"d";
                break;
            case 14:
                currentStr = @"e";
                break;
            case 15:
                currentStr = @"f";
                break;
            default:
                currentStr = [NSString stringWithFormat:@"%zd",remainder];
                break;
        }
        // 将获得的字符串插入第一个位置
        [HexStr insertString:currentStr atIndex:0];
        // 将商作为新的计算值.
        decimal = quotient;
    } while (quotient != 0);
    
    return HexStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
