//
//  ViewController.m
//  DowellController
//
//  Created by nex on 4/28/16.
//  Copyright © 2016 dowell. All rights reserved.
//

#import "ViewController.h"
#import "KSocket.h"

@interface ViewController ()<KSocketDelegate,UITextFieldDelegate>{
    KSocket *socket;
//    GCDAsyncUdpSocket *udpSocket;
}
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *recode;
@property (weak, nonatomic) IBOutlet UILabel *recodeLabel;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //get KSocket instance
    
//    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    socket  = [KSocket sharedInstance];
    socket.delegate = self;
    
    [self connectAction];
    
    }
//connect socket
-(void)connectAction{
    if(![socket isRunning]){
        
        
//        if ([socket connect:<#(NSString *)#> port:<#(int)#>]) {
//            []
//        }
        
//        [socket connect:@"192.168.0.125" port:9600];
        [socket connect:@"192.168.6.19" port:9090];
    }
    
}



//send byte array
-(void)sendAction:(char*)data{
    
    if ([socket isRunning] == NO) {
        [self connectAction];
    }
    
    if (data == nil) {
        return;
    }
    
    NSData *sendingData = [NSData dataWithBytes:data length:sizeof(data)];
    [socket sendData:sendingData];
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
        char autoRecode[] = {
            
        };
        [self sendAction:autoRecode];
    }

    if(!_recode.selected){
        [self popupDialog:@"手动导播"];
        _recodeLabel.text = @"手动导播";
        char recodeByHand[] = {
            
        };
        [self sendAction:recodeByHand];
    }
  
    
}


- (IBAction)live:(id)sender {
    
    //in child thread to send the char* data[]
    char live[] = {
        169,4,
        0,0};
    [self sendAction:live];
    [self popupDialog:@"开始直播!"];
    
    
}
- (IBAction)pause:(id)sender {
    
    char pause[] = {
        175,4,0,0
    };
    [self sendAction:pause];
    [self popupDialog:@"暂停直播!"];

    
}
- (IBAction)stop:(id)sender {
    
    char stop[] = {
        0x22,0x55
    };
    [self sendAction:stop];
    [self popupDialog:@"停止直播!"];
    

}


- (IBAction)teacherFeature:(id)sender {
    
    char teacherfeature[] = {
        40,0,0,0
    };
    [self sendAction:teacherfeature];
    [self popupDialog:@"老师特写!"];
    

}

- (IBAction)studentFeature:(id)sender {
    
    char studentfeature[] = {
       41,0,0,0
    };
    [self sendAction:studentfeature];
    [self popupDialog:@"学生特写!"];
    

}

- (IBAction)teacherFullScene:(id)sender {
    
    char teacherfullscene[] = {
        42,0,0,0
    };
    [self sendAction:teacherfullscene];
    [self popupDialog:@"老师全景!"];
    

}
- (IBAction)studentFullScene:(id)sender {
    
    char studentfullscene[] = {
        43,0,0,0
    };
    [self sendAction:studentfullscene];
    [self popupDialog:@"学生全景!"];
    

}
- (IBAction)blackboardWriting:(id)sender {
    
    char blackboardwriting[] = {
        44,0,0,0
    };
    [self sendAction:blackboardwriting];
    [self popupDialog:@"板书!"];
    

}
- (IBAction)VGA:(id)sender {
    
    char vga[] = {
        45,0,0,0
    };
    [self sendAction:vga];
    [self popupDialog:@"VGA!"];
    

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
