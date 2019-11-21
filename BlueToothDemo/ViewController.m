#import "ViewController.h"


@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate,GetPeripheralInfoDelegate>



@end

@implementation ViewController

- (IBAction)swtich:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSLog(@"--:%@",[button currentTitle]);
    if ([[button currentTitle] isEqual:@"开"]) {
        [self searchlinkDevice];
        NSString *tex = @"开启扫描...";
        tex = [ tex stringByAppendingString:  @"\r\n"];
        _showText.text=tex;

        [button setTitle:@"关" forState:UIControlStateNormal];
        _showText.text=tex;

    }else{
        NSString *tex = _showText.text;
        tex = [ tex stringByAppendingString:  @"\r\n-----------关闭扫描---------\r\n"];
        _showText.text=tex;


        [self stopScan];
        [button setTitle:@"开" forState:UIControlStateNormal];




    }



}






- (CBCentralManager *)centeralManager
{
    if (!_centeralManager) {
        _centeralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                queue:nil];
    }
    
    return _centeralManager;
}

//搜索蓝牙设备
- (void)searchlinkDevice
{
    // 实现代理
    // 扫描设备
    //    _centeralManager = [[CBCentralManager alloc] initWithDelegate:self
    //                                                            queue:nil];
    
    if(self.centeralManager.state == CBManagerStatePoweredOff) {
        // 蓝牙关闭的
        
    } else if(self.centeralManager.state == CBManagerStateUnsupported) {
        // 设备不支持蓝牙
    } else if(self.centeralManager.state == CBManagerStatePoweredOn ||
              self.centeralManager.state == CBManagerStateUnknown) {
        
        // 开启的话开始扫描蓝牙设备
        [self.centeralManager scanForPeripheralsWithServices:nil options:nil];
        
        double delayInSeconds = 20.0;
        
        // 扫描20s后未扫描到设备停止扫描
        dispatch_time_t popTime =
        dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           [self stopScan];
                       });
    }
}

#pragma mark - 中心设备manager回调 -

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOn:
        {
            // 扫描外围设备
            [self.centeralManager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
            
        default:
            NSLog(@"设备蓝牙未开启");
            break;
    }
}

#pragma mark - 发现设备Delegate -

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    /**
     *  在ios中蓝牙广播信息中通常会包含以下4中类型的信息。ios的蓝牙通信协议中默认不接受其他类型的广播信息。因此需要注意的是，如果需要在扫描设备时，通过蓝牙设备的Mac地址来唯一辨别设备，那么需要与蓝牙设备的硬件工程师沟通好：将所需要的Mac地址放到一下几种类型的广播信息中。
     kCBAdvDataIsConnectable = 1;
     kCBAdvDataLocalName = SN00000003;
     kCBAdvDataManufacturerData = <43474d01>;
     kCBAdvDataTxPowerLevel = 0;
     */
    
    //    //获取mac
//        NSLog(@"peripheral%@ ",peripheral);
//        NSLog(@"名%@ ",peripheral.name);
//        NSLog(@"UUID%@ ",peripheral.identifier.UUIDString);
//        NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//        NSString *aStr= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////        NSString *mac = [self hexadecimalString:data];
//
//        aStr = [aStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSLog(@"aStr:%@",aStr);
//        NSLog(@"advertisementData:%@",advertisementData);

    
    NSString *bName =advertisementData[@"kCBAdvDataLocalName"];
    NSString *tempdata =advertisementData[@"kCBAdvDataManufacturerData"];//可能为空
    NSString *bdata =[NSString stringWithFormat:@"%@",tempdata];
    NSString *bUUID=peripheral.identifier.UUIDString;
    
    
    NSString *tex = _showText.text;
    tex = [ tex stringByAppendingString:  @"名称:"];
    tex = [ tex stringByAppendingString:  bName!=NULL?bName:@""];
    tex = [ tex stringByAppendingString:  @"\r\n"];
    
    tex = [ tex stringByAppendingString:  @"ID:"];
    tex = [ tex stringByAppendingString:  bUUID!=NULL?bUUID:@""];
    
    tex = [ tex stringByAppendingString:  @"\r\n"];
    tex = [ tex stringByAppendingString:  @"报文:\r\n"];
    tex = [ tex stringByAppendingString:  bdata!=NULL?bdata:@""];
    tex = [ tex stringByAppendingString:  @"\r\n----------------------------------------------\r\n"];
    
    _showText.text=tex;
    
    
//    NSLog(@"%@|%@", advertisementData[@"kCBAdvDataLocalName"],advertisementData[@"kCBAdvDataManufacturerData"]);
    
    // 设备的UUID（peripheral.identifier）是由两个设备的mac通过算法得到的，所以不同的手机连接相同的设备，它的UUID都是不同的，无法标识设备
    // 苹果与蓝牙设备连接通信时，使用的并不是苹果蓝牙模块的Mac地址，使用的是苹果随机生成的十六进制码作为手机蓝牙的Mac与外围蓝牙设备进行交互。如果蓝牙设备与手机在一定时间内多次通信，那么使用的是首次连接时随机生成的十六进制码作为Mac地址，超过这个固定的时间段，手机会清空已随机生成的Mac地址，重新生成。
    // 也就是说外围设备是不能通过与苹果手机的交互时所获取的蓝牙Mac地址作为手机的唯一标识的。
    
    [self.centeralManager connectPeripheral:peripheral options:nil];
    
    
}




#pragma mark - 停止扫描 -

- (void)stopScan
{
    [self.centeralManager stopScan];
}

@end




