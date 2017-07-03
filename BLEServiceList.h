//
//  BLEServiceList.h
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 08/06/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLECharprop.h"
@interface BLEServiceList : ViewController<CBCentralManagerDelegate,CBPeripheralManagerDelegate>
{
    
}
@property(nonatomic, strong)NSMutableDictionary * dic_Charlist;
@property(nonatomic, strong)NSMutableDictionary * dic_Charlist1;
@property (nonatomic, strong) CBCentralManager *bleManager;
@property (nonatomic,strong) CBPeripheral *blePeripheral;
@property (nonatomic, weak) IBOutlet UITableView * tbl_serlist;
@property (nonatomic, weak) IBOutlet UILabel *lbl_bleName;
-(IBAction)btn_back:(id)sender;
@end
