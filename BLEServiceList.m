//
//  BLEServiceList.m
//  iOSSimpleBLE
//
//  Created by C17Q31UUFVH5 on 08/06/17.
//  Copyright © 2017 B2i Studio. All rights reserved.
//

#import "BLEServiceList.h"

@implementation BLEServiceList
@synthesize bleManager,blePeripheral,tbl_blelist,dic_Charlist,dic_Charlist1,lbl_bleName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lbl_bleName.text = blePeripheral.name;
    customColor = [UIColor colorWithRed:255.0f/255.0f green:85.0f/255.0f blue:7.0f/255.0f alpha:1.0f];

}

#pragma mark -
#pragma mark Table Deleg

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    NSArray * allKeys = [dic_Charlist1 allKeys];
    return [allKeys count];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSMutableArray *sectionAnimals = [[NSMutableArray alloc]init];
    NSArray * allKeys = [dic_Charlist1 allKeys];
    NSMutableArray*temparr = [NSMutableArray arrayWithArray:allKeys];
    NSString *sectionTitle = [NSString stringWithFormat:@"%@",(NSString*)[temparr objectAtIndex:section]];
    sectionAnimals = [dic_Charlist1 valueForKey:sectionTitle];
    
    return [sectionAnimals count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * allKeys = [dic_Charlist1 allKeys];
    NSMutableArray*temparr = [NSMutableArray arrayWithArray:allKeys];
    NSString * serviceid = [NSString stringWithFormat:@"%@",[temparr objectAtIndex:section]];
    return serviceid;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = customColor;

    NSMutableArray *sectionAnimals = [[NSMutableArray alloc]init];
    NSArray * allKeys = [dic_Charlist1 allKeys];
    NSMutableArray*temparr = [NSMutableArray arrayWithArray:allKeys];
    NSString *sectionTitle = [NSString stringWithFormat:@"%@",(NSString*)[temparr objectAtIndex:indexPath.section]];
    sectionAnimals = [dic_Charlist1 valueForKey:sectionTitle];
    
    CBCharacteristic *characteristic = [sectionAnimals objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",characteristic.UUID];
    

    
    return cell;
}
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSMutableArray *sectionAnimals = [[NSMutableArray alloc]init];
    NSArray * allKeys = [dic_Charlist1 allKeys];
    NSMutableArray*temparr = [NSMutableArray arrayWithArray:allKeys];
    NSString *sectionTitle = [NSString stringWithFormat:@"%@",(NSString*)[temparr objectAtIndex:indexPath.section]];
    sectionAnimals = [dic_Charlist1 valueForKey:sectionTitle];
    
    CBCharacteristic *characteristic = [sectionAnimals objectAtIndex:indexPath.row];
    
    
    BLECharprop  * ServiceList = [self.storyboard instantiateViewControllerWithIdentifier:@"BLECharprop"];
    
    ServiceList.blePeripheral = blePeripheral;
    ServiceList.bleManager = bleManager;
    ServiceList.char_selected = characteristic;
    [bleManager stopScan];
    
    [self presentViewController:ServiceList animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = customColor;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}
-(void)setDic_Charlist:(NSMutableDictionary *)dic_Charlist12
{
    dic_Charlist1 = dic_Charlist12;
}
-(IBAction)btn_back:(id)sender
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
