//
//  ISAirnowCustomAdapter.swift
//  AirnowMediationWithIS
//
//  Created by Gusakovsky, Sergey on 14.12.21.
//

import Foundation
import ObjectiveC.runtime
import AirMonetizationSDK

@objc(ISAirnowCustomAdapter)
public class ISAirnowCustomAdapter: ISBaseNetworkAdapter {
    
    @objc public override func networkSDKVersion() -> String! {
        return AirMonetization.shared.sdkVersion
    }
    
    @objc public override func adapterVersion() -> String! {
        return ISAdapterConstants.version
    }
    
    @objc public override func `init`(_ adData: ISAdData!, delegate: ISNetworkInitializationDelegate!) {
        delegate.onInitDidSucceed()
    }
    
}
