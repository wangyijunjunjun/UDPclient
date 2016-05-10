//
//  ViewController.m
//  DowellController
//
//  Created by nex on 4/28/16.
//  Copyright © 2016 dowell. All rights reserved.
//
#import "ViewController.h"
//#import "GCDAsyncUdpSocket.h"
#import "AsyncUdpSocket.h"
@interface ViewController ()<AsyncUdpSocketDelegate>{
    NSString *host ;
    int port;
}
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *recode;
@property (weak, nonatomic) IBOutlet UILabel *recodeLabel;

@property (nonatomic, strong) AsyncUdpSocket *sendSocket;
@property (nonatomic, strong) AsyncUdpSocket *reciveSocket;



@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _reciveSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [_reciveSocket bindToPort:9090 error:nil];
    
    [_reciveSocket receiveWithTimeout:-1 tag:0];
    
    _sendSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    [_sendSocket bindToPort:9090 error:nil];
    
    
    host = @"192.168.6.19";
    port  = 8888;
    //    [self initArray];
    //状态查询 126,4,0,0
    //录播查询126,0,0,0
    //查询当前通道 126,5,0,0
    
}

//-(void)initArray {
//    sighs = [NSArray arrayWithObjects:@"开始直播",@"自动导播",@"暂停录制",@"手动导播",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
//}

/**
 *  接受到消息HOST发送端ip
 *
 */
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
    [_reciveSocket receiveWithTimeout:-1 tag:0];
    return YES;
}

- (IBAction)recodeByHand:(id)sender {
    _recode.selected = !_recode.selected;
    //    [self.];
    //if (isPlus) === if(isPlus==YES)
    //    [self.recode ];
    if(_recode.selected){
        //auto
        [self popupDialog:@"自动导播"];
        _recodeLabel.text = @"自动导播";
        //        char q = (Byte)46;
        //        char w = (Byte)2;
        //        char e = (Byte)0;
        //        Byte autoRecode[4] = {
        //            (Byte)46,(Byte)2,(Byte)0,(Byte)0
        //        };
        //
        
        char autoRecode[] = {46,2,0,0};
        NSData *sendingData = [NSData dataWithBytes:autoRecode length:sizeof(autoRecode)];
        [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
        
    }
    
    if(!_recode.selected){
        [self popupDialog:@"手动导播"];
        _recodeLabel.text = @"手动导播";
        //        Byte recodeByHand[] = {
        //           46,1,0,0
        //            (Byte)46,(Byte)2,(Byte)0,(Byte)0
        //        };
        
        char recodeByHand[] = {46,1,0,0};
        NSData *sendingData = [NSData dataWithBytes:recodeByHand length:sizeof(recodeByHand)];
        [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
        
        
    }
    //查询导播状态:46,0,0,0
}


- (IBAction)live:(id)sender {
    
    //in child thread to send the char* data[]
        Byte live[] = {169,4,0,0};
//    char live[] = {169,4,0,0};
    NSData *sendingData = [NSData dataWithBytes:live length:sizeof(live)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
}
- (IBAction)pause:(id)sender {

    //    Byte pause[] = {
    //        154,0,0,0
    //    };

    char pause[] = {154,0,0,0};
    NSData *sendingData = [NSData dataWithBytes:pause length:sizeof(pause)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];

    [self popupDialog:@"暂停录制!"];

}

- (IBAction)stop:(id)sender {

    //    Byte stop[] = {103,0,0,0};

    char stop[] = {103,0,0,0};
    NSData *sendingData = [NSData dataWithBytes:stop length:sizeof(stop)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];

    [self popupDialog:@"停止录播!"];


}
- (IBAction)startCast:(id)sender {

    //    Byte startcast[] = {102,0,0,0};
    char startcast[] = {102,0,0,0};
    NSData *sendingData = [NSData dataWithBytes:startcast length:sizeof(startcast)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
    [self popupDialog:@"开始录播!"];

}


- (IBAction)teacherFeature:(id)sender {

    //    Byte teacherfeature[] = {40,0,0,0};
    char teacherfeature[]={40,0,0,0};
    NSData *sendingData = [NSData dataWithBytes:teacherfeature length:sizeof(teacherfeature)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
    [self popupDialog:@"老师特写!"];


}

- (IBAction)studentFeature:(id)sender {

    char studentfeature[] = {41,0,0,0};
    NSData *sendingData = [NSData dataWithBytes:studentfeature length:sizeof(studentfeature)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
    

    [self popupDialog:@"学生特写!"];

}

- (IBAction)teacherFullScene:(id)sender {

    char teacherfullscene[] = {
        42,0,0,0
    };
    NSData *sendingData = [NSData dataWithBytes:teacherfullscene length:sizeof(teacherfullscene)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];

    [self popupDialog:@"老师全景!"];


}
- (IBAction)studentFullScene:(id)sender {

    char studentfullscene[] = {
        43,0,0,0
    };
    NSData *sendingData = [NSData dataWithBytes:studentfullscene length:sizeof(studentfullscene)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
    

    [self popupDialog:@"学生全景!"];


}
- (IBAction)blackboardWriting:(id)sender {

    char blackboardwriting[] = {
        44,0,0,0
    };
    NSData *sendingData = [NSData dataWithBytes:blackboardwriting length:sizeof(blackboardwriting)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
    

    [self popupDialog:@"板书!"];


}
- (IBAction)VGA:(id)sender {

    char vga[] = {
        45,0,0,0
    };
    NSData *sendingData = [NSData dataWithBytes:vga length:sizeof(vga)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
    

    [self popupDialog:@"VGA!"];


}

- (IBAction)shutdown:(id)sender {

    char shutdown[] = {
        255,0,0,0
    };
    NSData *sendingData = [NSData dataWithBytes:shutdown length:sizeof(shutdown)];
    [_sendSocket sendData:sendingData toHost:host port:port withTimeout:30 tag:0];
    

    [self popupDialog:@"关机!"];


}


//popup alertDialog
- (void)popupDialog:(NSString*)info{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Title" message:info delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
