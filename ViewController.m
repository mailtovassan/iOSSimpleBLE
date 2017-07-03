//
//  ViewController.m
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 29/05/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import "ViewController.h"
#import "BLEDetails.h"
#import "BLEServiceList.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize bleManager,blePeripheral,viw_tabbar,tbl_blelist;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   customColor = [UIColor colorWithRed:255.0f/255.0f green:85.0f/255.0f blue:7.0f/255.0f alpha:1.0f];

    
    [self BLEInit];
    [tbl_blelist reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    
    
    bleManager.delegate = self;
    blePeripheral.delegate = self;
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = customColor;
    [tbl_blelist addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(tblrefresh) forControlEvents:UIControlEventValueChanged];

    
}
#pragma mark -
#pragma mark BLE Delegates

-(void)BLEInit
{
    bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    mu_blename = [[NSMutableArray alloc] init];
    mu_servicelist = [[NSMutableArray alloc] init];
    mu_rssi = [[NSMutableArray alloc] init];
    dic_serChar = [[NSMutableDictionary alloc] init];
    
}

/*
 Invoked whenever the central manager's state has been updated.
 
 CBCentralManagerStatePoweredOn
 CBCentralManagerStatePoweredOff

 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        
        /*
         Scan can done by two way
         One is scan for all avaible BLE devices
         Second scan BLE device which has service UDID (Service UDIDs are listed in ble advertising data. Ask firmware engg advertising data / Check it in Light blue App)
         */
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber  numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];

        
        //1
        [bleManager scanForPeripheralsWithServices:nil options:options];
        
        //2
       /* NSArray * services=[NSArray arrayWithObjects:
                            [CBUUID UUIDWithString:@"0x1803"],
                            [CBUUID UUIDWithString:@"0xAA11"],
                            nil];
        
        [bleManager scanForPeripheralsWithServices:services options:nil];*/
        
    }
    else if (central.state == CBCentralManagerStatePoweredOff)
    {
        
        
    }
    else
    {
        [self showalertboxwithTitle:@"BLE is Not ON" Message:@"Kindly switch ON the BLE" Cancelbtntitle:@"Setting" OtherBtntitle:@"OK"];
    }
}

-(void)centralManager:(nonnull CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    
    NSLog(@"BT Range Name:%@ : %@",peripheral.name,RSSI);
    
    if (peripheral.state == CBPeripheralStateConnected)
    {
        NSLog(@"BT  Status : Connected");
    }
    if (peripheral.state == CBPeripheralStateDisconnected)
    {
        NSLog(@"BT  Status : DisConnected");
    }
    

    
    
    if (![mu_blename containsObject:peripheral])
    {
        [mu_blename addObject:peripheral];
        NSString *servicelist = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
        if (servicelist!=nil)
            [mu_servicelist addObject:servicelist];
        else
        {
            NSArray *myArray = [[NSArray alloc] initWithObjects:@"Zero Services", nil];
            [mu_servicelist addObject:myArray];
        }
        [mu_rssi addObject:[NSString stringWithFormat:@"%@",RSSI]];
        
        [tbl_blelist reloadData];
    }
    else
    {
        // Update RSSI Value
        
       /* NSUInteger indexv =[mu_blename indexOfObject:peripheral];
        
        [mu_rssi replaceObjectAtIndex:indexv withObject:[NSString stringWithFormat:@"%@",RSSI]];
        [tbl_blelist reloadData];*/

    }
    
}

-(void)centralManager:(nonnull CBCentralManager *)central didConnectPeripheral:(nonnull CBPeripheral *)peripheral
{
    
    if (peripheral.state == CBPeripheralStateConnected)
    {
        NSLog(@"BLE  Status : Connected");
        
       peripheral.delegate = self;
        
        if (!peripheral.services)
        {
            [self peripheral:peripheral didDiscoverServices:nil];
        }
        else
        {
            //[peripheral discoverServices:@[[CBUUID UUIDWithString:CUSTOM_UUID]]];
        }
    }
    if (peripheral.state == CBPeripheralStateDisconnected)
    {
        NSLog(@"BLE  Status : Disconnected");
    }
    
    
    [peripheral discoverServices:nil];
    
}


#pragma mark-
#pragma mark peripheral Delegate
-(void)peripheral:(nonnull CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    
    // Imported method for initial service
    
//    if (!error)
//    {
//        for (CBService * ser in peripheral.services)
//        {
//            NSLog(@"Discovered service: %@", ser.UUID);
//            [peripheral discoverCharacteristics:nil forService:ser];
//            
//            /*
//             This part helps you to find out the peripheral has specified service or not
//             */
//            
//           /* if ([ser.UUID isEqual:[CBUUID UUIDWithString:@"0xAABB"]])
//            {}else
//            {
//                [self showalertboxwithTitle:@"This is not valid Device !" Message:nil Cancelbtntitle:@"OK" OtherBtntitle:nil];
//            }*/
//        }
//    }
    
    for(CBService* svc in peripheral.services)
    {
        if(svc.characteristics)
            [self peripheral:peripheral didDiscoverCharacteristicsForService:svc error:nil]; //already discovered characteristic before, DO NOT do it again
        else
            [peripheral discoverCharacteristics:nil
                                     forService:svc]; //need to discover characteristics
    }
    
    // [self.cManager cancelPeripheralConnection:peripheral];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    // Deal with errors (if any)
    if (error)
    {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSMutableArray * mu_perchar = [[NSMutableArray alloc]init];
    
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Discovered Char: %@", characteristic.UUID);
        
        [mu_perchar addObject:characteristic];
        
        // Set Notification for spec service
        
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AACC"]])
//        {
//            // If it is, subscribe to it
//          //  [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
    }
    [dic_serChar setObject:mu_perchar forKey:[NSString stringWithFormat:@"%@",service.UUID]];
    
    //NSArray * allKeys = [dic_serChar allKeys];
   // NSLog(@"Count : %lu", (unsigned long)[allKeys count]);
    
    
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

#pragma mark -
#pragma mark Tbl

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mu_blename count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = customColor;
    cell.detailTextLabel.textColor = customColor;
    
    
    CBPeripheral* currentPer = [mu_blename objectAtIndex:indexPath.row];
    cell.textLabel.text = (currentPer.name ? currentPer.name : @"Unknown");
    if ([mu_servicelist objectAtIndex:indexPath.row])
    {
        NSString *servicelist = [[mu_servicelist objectAtIndex:indexPath.row] componentsJoinedByString:@","];
        if (servicelist!=nil)
        {
            
            NSString * detailStr = [NSString stringWithFormat:@"RSSI ::: %@",[mu_rssi objectAtIndex:indexPath.row]];
            detailStr = [detailStr stringByAppendingFormat:@"   Services :::  ( %@ )",servicelist];
            
            cell.detailTextLabel.text = detailStr;
        }
   
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    
    [bleManager connectPeripheral:[mu_blename objectAtIndex:indexPath.row] options:nil];
    [bleManager stopScan];
    
    [self performSelector:@selector(callCharScreen:) withObject:[mu_blename objectAtIndex:indexPath.row] afterDelay:5.0];
    
}





-(void)callCharScreen:(CBPeripheral *)peripheral
{
        BLEServiceList  * ServiceList = [self.storyboard instantiateViewControllerWithIdentifier:@"BLEServiceList"];
    
        ServiceList.blePeripheral = peripheral;
        ServiceList.bleManager = bleManager;
        ServiceList.dic_Charlist =dic_serChar;
    [ServiceList setDic_Charlist:dic_serChar];
        [bleManager stopScan];

        [self presentViewController:ServiceList animated:YES completion:nil];
}

-(void)showalertboxwithTitle:(NSString*)Title Message:(NSString*)message Cancelbtntitle:(NSString*)canbtntitle OtherBtntitle:(NSString*)othbtnTitle
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:Title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    if (othbtnTitle!=nil)
    {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:othbtnTitle
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
    }
    
    if (canbtntitle!=nil)
    {
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:canbtntitle
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        
        [alert addAction:noButton];
    }
    
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btn_scan:(id)sender
{
    
    [mu_rssi removeAllObjects];
    [mu_blename removeAllObjects];
    [mu_servicelist removeAllObjects];
    [tbl_blelist reloadData];
}
-(void)tblrefresh
{
    [mu_rssi removeAllObjects];
    [mu_blename removeAllObjects];
    [mu_servicelist removeAllObjects];
    [refreshControl endRefreshing];
    [tbl_blelist reloadData];
    
    
}

@end
