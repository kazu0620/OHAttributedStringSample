//
//  ViewController.m
//  OHAttributedStringSample
//
//  Created by sakamoto kazuhiro on 2016/04/22.
//  Copyright © 2016年 Sakamoto Kazuhiro. All rights reserved.
//

#import "ViewController.h"
#import <OHAttributedStringAdditions/OHAttributedStringAdditions.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *hogeTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *hoge = [[self class] setLinkDecorationTo:self.hogeTextView];
    NSLog(@"HOGEHOGE");
    
    
    
    
    
    self.hogeTextView.attributedText = hoge;
    [[self class] setLinkDecorationTo:self.hogeTextView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  テキストをリンク色に装飾する
 */
+ (NSMutableAttributedString *) setLinkDecorationTo:(UITextView *)textView{
    NSMutableAttributedString *attributedText = [[self class]linkElementsAttributedStringWithTargetString:textView.text].mutableCopy;
    [attributedText setFont:textView.font];
    return attributedText;
}

+ (NSAttributedString *) linkElementsAttributedStringWithTargetString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [NSMutableAttributedString attributedStringWithString:string];
    
    // 正規表現を用いて対象の文字列からURL部分を抽出する
    NSArray *URLMatchResults = [[self class ]matchedURLsWithText:string];
    
    // 抽出したURL部分にリンク用の属性をSETしておく
    for( NSTextCheckingResult *match in URLMatchResults ){
        NSString *URLString = [string  substringWithRange:[match rangeAtIndex:0]];
        [attributedString setURL:[NSURL URLWithString:URLString] range:[match rangeAtIndex:0]];
        [attributedString setTextColor:[UIColor blueColor] range:[match rangeAtIndex:0]];
    }
    
    return attributedString;
}


/**
 *  タップされた座標がURLを踏んだ箇所であればNSURLを返す
 */
+ (NSURL *) URLWithLabelTappedPosition:(CGPoint)tappedPosition
                                 label:(UILabel *)label
{
    NSLog(@"--------------------------------");
    NSLog(@"LABEL FRAME %@", NSStringFromCGRect(label.frame));

    // MEMO: このcharacterIndexAtPoint　が NSNotFound(NSIntegerMax)を返してしまうために
    // URLを取得することが出来ていない。
    NSUInteger tappedCharNumber = [label characterIndexAtPoint:tappedPosition];
    
    NSLog(@"Tap Char Number %@", @(tappedCharNumber));
    
    if ( tappedCharNumber != NSNotFound ) {
        NSURL *tappedURL = [label.attributedText URLAtIndex:tappedCharNumber effectiveRange:NULL];
        if (tappedURL){
            return tappedURL;
        }
    }
    return nil;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    NSLog(@"URL %@", url.absoluteString);
    return NO;
}

/**
 *  正規表現でStringの中からURL部分を見つけ出すUtil
 */
+ (NSArray *) matchedURLsWithText:(NSString *)text {
    NSRegularExpression *regex = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    return [regex matchesInString:text
                          options:0
                            range:NSMakeRange(0,[text length])
            ];
}


@end
