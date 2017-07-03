//
//  BLECharprop.h
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 19/06/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface BLECharprop : ViewController<CBCentralManagerDelegate,CBPeripheralManagerDelegate>
{
    NSMutableArray * mu_tbldata;
    NSMutableArray * mu_timesnap;
}
@property (nonatomic, strong) CBCentralManager *bleManager;
@property (nonatomic,strong) CBPeripheral *blePeripheral;
@property (nonatomic, strong)CBCharacteristic * char_selected;



@property (weak, nonatomic) IBOutlet UILabel *lbl_read;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Write;

@property (weak, nonatomic) IBOutlet UILabel *lbl_writeRes;

@property (weak, nonatomic) IBOutlet UILabel *lbl_notify;
@property (weak, nonatomic) IBOutlet UILabel *lbl_charUDID;

@property (weak, nonatomic) IBOutlet UIButton *btnn_Write;

@property (weak, nonatomic) IBOutlet UIButton *btnn_notify;

@property (weak, nonatomic) IBOutlet UITableView *tbl_writenotify;



- (IBAction)btn_back:(id)sender;
- (IBAction)btn_write:(id)sender;
- (IBAction)btn_notify:(id)sender;




@end
