//
//  LinkOperation.h
//  Weinei-iPhone
//
//  Created by 徐正权 on 16/3/25.
//  Copyright © 2016年 cml. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

@protocol PeripheralOperationDelegate <NSObject>

@optional



@end

@protocol GetPeripheralInfoDelegate <NSObject>

@optional


@end

@interface LinkOperation : NSObject


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

/**
 *  保存扫描数据
 */
@property (nonatomic, strong) NSString *showData;


@end
