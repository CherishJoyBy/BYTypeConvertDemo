# BYTypeConvertDemo

### 本文介绍了常见的类型转换.

#### 一.NSString和NSData的互相转换.

- NSString 转 NSData.

```objc
NSString *testStr1 = @"better";
NSData *testData1 = [testStr1 dataUsingEncoding:NSUTF8StringEncoding];
NSLog(@"testData:%@",testData1);
```

结果:

```objc
2017-06-06 17:37:44.950912+0800 test1[9204:3141182] testData:<62657474 6572>
```

- NSData 转 NSString.

```objc
NSString *testStr2 = [[NSString alloc] initWithData:testData1 encoding:NSUTF8StringEncoding];
NSLog(@"testStr:%@",testStr2);
```

结果:

```objc
2017-06-06 17:37:44.951103+0800 test1[9204:3141182] testStr:better
```

#### 二.NSData和Byte互相转换.

- NSData 转 Byte数组.

```objc
NSString *testStr3 = @"better";
NSData *testData2 = [testStr3 dataUsingEncoding: NSUTF8StringEncoding];
Byte *testByte1 = (Byte *)[testData2 bytes];
for (int i = 0; i < [testData2 length]; i++)
{
    NSLog(@"%d",testByte1[i]);
}
```

结果:

```objc
2017-06-06 17:37:44.951213+0800 test1[9204:3141182] 98
2017-06-06 17:37:44.951250+0800 test1[9204:3141182] 101
2017-06-06 17:37:44.951283+0800 test1[9204:3141182] 116
2017-06-06 17:37:44.951314+0800 test1[9204:3141182] 116
2017-06-06 17:37:44.951345+0800 test1[9204:3141182] 101
2017-06-06 17:37:44.951376+0800 test1[9204:3141182] 114
```

说明:

NSData默认含有bytes的只读属性,可直接调用.

```objc
@property (readonly) const void *bytes NS_RETURNS_INNER_POINTER;
```

- Byte数组 转 NSData.

```objc
Byte byteArr[] = {98,101,116,116,101,114};
NSData *testData3 = [[NSData alloc] initWithBytes:byteArr length:sizeof(byteArr)/sizeof(Byte)];
NSLog(@"%@",testData3);
```

结果:

```objc
2017-06-06 17:44:21.302122+0800 test1[9209:3143384] <62657474 6572>
```

#### 三. 十六进制和十进制互相转换.

- 十六进制 转 十进制 (`系统方法`)

```objc
NSUInteger testData4 = strtoul([testHexStr UTF8String],0,16);
NSLog(@"%zd",testData4);
```

结果:

```objc
2017-06-06 18:22:00.746316+0800 test1[9286:3154681] 190
```

strtoul说明:

```objc
//参数1：字符串起始地址.
//参数2：返回字符串有效数字的结束地址,这也是为什么要用二级指针的原因.
//参数3：转换基数.当base=0,自动判断字符串的类型,并按10进制输出.
strtoul(const char *__str, char **__endptr, int __base);
```

- 十进制 转 十六进制 (`系统方法`)

```objc
NSString *testHexStr = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%x",190]];
NSLog(@"%@",testHexStr);
```

结果:

```objc
2017-06-06 18:22:00.746256+0800 test1[9286:3154681] be
```

说明:

转换结果不带`0X`前缀,如果需要带`0X`前缀,且是小写字母,使用`%#x`打印格式,若是大写字母,使用`%#X`打印格式.

- 十六进制 转 十进制 (自己实现 -- 出自[<iOS开发>之类型转换](http://www.jianshu.com/p/abd5e7f9b878))

```objc
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
```

调用:

```objc
NSLog(@"%@",[self convertDecimalWithHexStr:@"AbCdE"]);
```

结果:

```objc
2017-06-07 00:59:06.852111+0800 十六进制转十进制[9450:3194324] 703710
```

- 十进制 转 十六进制 (自己实现 -- 出自[<iOS开发>之类型转换](http://www.jianshu.com/p/abd5e7f9b878))

```objc
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
```

调用:

```objc
NSLog(@"%@",[self convertHexStrWithDecimal:703710]);
```

结果:

```objc
2017-06-07 00:59:06.851867+0800 十六进制转十进制[9450:3194324] abcde
```

### 欢迎访问简书 : [o惜乐o](http://www.jianshu.com/p/abd5e7f9b878)
