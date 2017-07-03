//
//  BLEDetails.h
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 29/05/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface BLEDetails : ViewController <CBPeripheralDelegate,CBCentralManagerDelegate>
{
    NSMutableArray * mu_data;
}

@property(nonatomic, strong) CBCentralManager * BLEManager;
@property(nonatomic, strong) CBPeripheral * BLEPeripheral;

@property (weak, nonatomic) IBOutlet UILabel *lbl_blename;

@property (weak, nonatomic) IBOutlet UITableView *tbl_data;
- (IBAction)bnt_back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bnt_write;
- (IBAction)btn_write:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viw_write;
- (IBAction)btn_writecancel:(id)sender;
- (IBAction)btn_writesend:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_write;
@end
