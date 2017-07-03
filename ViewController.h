//
//  ViewController.h
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 29/05/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <CoreBluetooth/CoreBluetooth.h>
static UIColor * customColor;
@interface ViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralManagerDelegate,CBPeripheralDelegate>
{
    
    NSMutableArray * mu_blename;
    NSMutableArray * mu_servicelist;
    NSMutableArray * mu_rssi;
    
    NSMutableDictionary * dic_serChar;
    NSTimer * tim_clearlist;
    UIRefreshControl* refreshControl;
}
@property (nonatomic, strong) CBCentralManager *bleManager;
@property (nonatomic,strong) CBPeripheral *blePeripheral;
@property (nonatomic, weak) IBOutlet UITableView * tbl_blelist;
@property (nonatomic, weak) IBOutlet UIView *viw_tabbar;


-(IBAction)btn_scan:(id)sender;



@end

