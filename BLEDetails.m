//
//  BLEDetails.m
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 29/05/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import "BLEDetails.h"

@implementation BLEDetails
@synthesize BLEManager,BLEPeripheral,lbl_blename,viw_write,txt_write;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    mu_data = [[NSMutableArray alloc] init];
    
    lbl_blename.text = BLEPeripheral.name;
    
    viw_write.hidden =YES;
}
- (IBAction)bnt_back:(id)sender
{
//    if (BLEPeripheral)
//    {
//        if (BLEPeripheral.state == CBPeripheralStateConnected)
//        {
//            [BLEManager cancelPeripheralConnection:BLEPeripheral];
//            BLEPeripheral = nil;
//        }
//    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)btn_write:(id)sender
{
    viw_write.hidden =NO;

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
    return [mu_data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text=[mu_data objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    

    
}

- (IBAction)btn_writecancel:(id)sender
{
    viw_write.hidden =YES;

    
}

- (IBAction)btn_writesend:(id)sender
{
    viw_write.hidden =YES;
    
}
@end
