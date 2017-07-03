//
//  BLECharprop.m
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 19/06/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import "BLECharprop.h"

@implementation BLECharprop
@synthesize lbl_read,lbl_Write,lbl_notify,lbl_charUDID,lbl_writeRes,tbl_writenotify,btnn_Write,btnn_notify,blePeripheral,bleManager,char_selected;


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [bleManager stopScan];
    customColor = [UIColor colorWithRed:255.0f/255.0f green:85.0f/255.0f blue:7.0f/255.0f alpha:1.0f];

    
    mu_tbldata = [[NSMutableArray alloc] init];
    mu_timesnap = [[NSMutableArray alloc]init];
    
    blePeripheral.delegate = self;
    bleManager.delegate = self;
    
    [lbl_writeRes setAlpha:0.4];
    [lbl_Write setAlpha:0.4];
    [lbl_read setAlpha:0.4];
    [lbl_notify setAlpha:0.4];
    [btnn_notify setAlpha:0.4];
    [btnn_notify setEnabled:NO];
    
    lbl_charUDID.text = [NSString stringWithFormat:@"%@",char_selected.UUID];
    
    
    if (char_selected.properties == CBCharacteristicPropertyWrite)
    {
        [lbl_Write setAlpha:1.0];
    }
    if (char_selected.properties == CBCharacteristicPropertyWriteWithoutResponse)
    {
        [lbl_writeRes setAlpha:1.0];
    }
    if (char_selected.properties == CBCharacteristicPropertyRead)
    {
        [lbl_read setAlpha:1.0];
        [blePeripheral readValueForCharacteristic:char_selected];
    }
    if (char_selected.properties == CBCharacteristicPropertyNotify)
    {
        [btnn_notify setAlpha:1.0];
        [btnn_notify setEnabled:YES];
        [lbl_notify setAlpha:1.0];
    }

    
}


#pragma mark -
#pragma Tbl Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mu_timesnap count];
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
    
    cell.textLabel.text=[mu_tbldata objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [mu_timesnap objectAtIndex:indexPath.row];
    cell.textLabel.textColor = customColor;
    cell.detailTextLabel.textColor = customColor;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -
#pragma mark BLE Delegate
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    NSData *data = characteristic.value;
    NSLog(@"Recieved Value: %@",data);
    
    NSString *MyString;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    MyString = [dateFormatter stringFromDate:now];
    NSLog(@" Time : %@",MyString);
    
    
    NSString * dataStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (data!=nil && dataStr!=nil)
    {
     
        NSUInteger len = 20;
        
        Byte *byteData = (Byte*)malloc(len);
        
        memcpy(byteData, [data bytes], len);


        
            [mu_tbldata insertObject:dataStr atIndex:0];
            [mu_timesnap insertObject:MyString atIndex:0];
       
        
        
        [tbl_writenotify reloadData];

        
    }
   
    
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error
{
    
}
#pragma mark-
#pragma mark Action
- (IBAction)btn_back:(id)sender
{
    [blePeripheral setNotifyValue:NO forCharacteristic:char_selected];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btn_write:(id)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Write Data"
                                                                              message: @"Type your input"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Max Temp";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    NSArray * textfields = alertController.textFields;
                                    UITextField * namefield = textfields[0];
                                    NSLog(@"Inputs:%@",namefield.text);
                                    
                                    
                                    NSString *writestr = namefield.text;
                                    if (!([writestr length]>20))
                                    {
                                        
                                        
                                        
                                        NSUInteger len =[writestr length];
                                        
                                        unichar by_writeinput[len+1];
                                        [writestr getCharacters:by_writeinput range:NSMakeRange(0, len)];
                                        Byte *bytes = malloc(sizeof(*bytes) * (len+1));
                                        Byte *bytes_port =  malloc(sizeof(*bytes)*len);
                                        
                                        for( int i = 0;i <len;i++)
                                        {
                                            
                                            bytes_port[i] = by_writeinput[i];
                                            
                                        }

                                        
                                        NSData *data_port = [NSData dataWithBytesNoCopy:bytes_port length:len freeWhenDone:YES];
                                        [blePeripheral writeValue:data_port forCharacteristic:char_selected type:CBCharacteristicPropertyWriteWithoutResponse];
                                    }
                                    

                                    

                                    
                                }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(NSInteger) getInt:(Byte) data
{
    NSInteger returnInt = data;
    
    if(returnInt < 0)
    {
        return returnInt + 256;
    }
    return returnInt;
}


- (IBAction)btn_notify:(id)sender
{
    [blePeripheral setNotifyValue:YES forCharacteristic:char_selected];
}
@end
