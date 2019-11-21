#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>
@protocol PeripheralOperationDelegate <NSObject>

@optional

@end

@protocol GetPeripheralInfoDelegate <NSObject>

@optional
@end




@interface ViewController : UIViewController
/**
 *  GetPeripheralDataDelegate 代理
 */
@property (nonatomic, weak) id <GetPeripheralInfoDelegate> delegate;

/**
 *  GetCGMDataDelegate 代理
 */
@property (nonatomic, weak) id <PeripheralOperationDelegate> operationDelegate;

/**
 *  中心设备
 */
@property (nonatomic, strong) CBCentralManager *centeralManager;



/**
 *  连接的外围设备
 */
@property (nonatomic, strong) CBPeripheral *connectPeripheral;




/**
 *  停止扫描
 */
- (void)stopScan;



/**
 *  扫描设备
 */
- (void)searchlinkDevice;

@property (weak, nonatomic) IBOutlet UITextView *showText;

- (IBAction)swtich:(id)sender;
@end




