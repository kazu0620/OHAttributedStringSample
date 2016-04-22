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
@property (weak, nonatomic) IBOutlet UILabel *hogeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self class] setLinkDecorationTo:self.hogeLabel];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLabel:(UIGestureRecognizer *)recognizer{
        CGPoint tappedPoint = [recognizer locationInView:self.hogeLabel];
    NSURL *tappedURL    = [[self class] URLWithLabelTappedPosition:tappedPoint label:self.hogeLabel];
    // !!! URLをタップしたらtappedURLにURLが入っていてほしい !!!
    // しかし入ってない。
    NSLog(@"TAP URL %@", tappedURL);
}

/**
 *  テキストをリンク色に装飾する
 */
+ (void) setLinkDecorationTo:(UILabel *)label {
    NSMutableAttributedString *attributedText = [[self class]linkElementsAttributedStringWithTargetString:label.text].mutableCopy;
    [attributedText setFont:label.font];
    [attributedText setTextColor:label.textColor];
    label.attributedText = attributedText;
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
    // MEMO: このcharacterIndexAtPoint　が NSNotFound(NSIntegerMax)を返してしまうために
    // URLを取得することが出来ていない。
    NSUInteger tappedCharNumber = [label characterIndexAtPoint:tappedPosition];
    
    
    if ( tappedCharNumber != NSNotFound ) {
        NSURL *tappedURL = [label.attributedText URLAtIndex:tappedCharNumber effectiveRange:NULL];
        if (tappedURL){
            return tappedURL;
        }
    }
    return nil;
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
