//
//  AirMonetizationRewardedAdapterConfiguration.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 24.09.21.
//

import Foundation
import AirMonetizationSDK
#if canImport(MoPubSDK)
import MoPubSDK
#else
import MoPub
#endif

@objc public class MPAirMonetizationAdapterConfiguration: MPBaseAdapterConfiguration {
    
    override public var adapterVersion: String {
        return Constants.version
    }
    
    override public var biddingToken: String? {
        return nil
    }
    
    override public var moPubNetworkName: String {
        return Constants.networkName
    }
    
    override public var networkSdkVersion: String {
        return AirMonetizationAdapterSettings.sdkVersion
    }

    override public func initializeNetwork(withConfiguration configuration: [String : Any]?, complete: ((Error?) -> Void)? = nil) {
        guard let configuration = configuration,
              let apiKey = configuration["api_key"] as? String,
              let appId = configuration["app_id"] as? String,
              let testMode = configuration["test_mode"] as? Bool
        else {
            let error = MPAirMonetizationMoPubAdapterError.noApiKeyOrAppId
            complete?(error)
            return
        }
        AirMonetization.shared.setAPIKey(key: apiKey, appID: appId)
        AirMonetization.shared.setTestMode(testMode: testMode)
        complete?(nil)
    }
}
