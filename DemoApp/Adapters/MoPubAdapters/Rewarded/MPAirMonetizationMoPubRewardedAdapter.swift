//
//  MPAirMonetizationMoPubRewardedAdapter.swift
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

@objc(MPAirMonetizationMopubRewardedAdapter)
public class MPAirMonetizationMoPubRewardedAdapter: MPFullscreenAdAdapter, MPThirdPartyFullscreenAdAdapter, MPAdapterConfiguration, AirMonetizationRewardedAdDelegate {
    
    //MARK: -  MPAdapterConfiguration Protocol
    private var placementName: String? = nil
    
    public var adapterVersion: String {
        return Constants.version
    }
    public var biddingToken: String? {
        return nil
    }
    public var moPubNetworkName: String {
        return Constants.networkName
    }
    public var moPubRequestOptions: [String : String]? {
        return nil
    }
    public var networkSdkVersion: String {
        return AirMonetizationAdapterSettings.sdkVersion
    }
    
    public func initializeNetwork(withConfiguration configuration: [String : Any]?, complete: ((Error?) -> Void)? = nil) {
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
        self.placementName = configuration["placement_name"] as? String
        complete?(nil)
    }
    
    public func addMoPubRequestOptions(_ options: [String : String] = [:]) {
        
    }
    
    public static func setCachedInitializationParameters(_ parameters: [String : Any]?) {
        
    }
    
    public static func cachedInitializationParameters() -> [String : Any]? {
        return nil
    }
    
    
    // MARK: - Members
    private var currentRewardedAd: AirMotetizationAd?
    
    public override var isRewardExpected: Bool {
        return true
    }
    
    @objc public override func requestAd(withAdapterInfo info: [AnyHashable : Any], adMarkup: String?) {
        MPLogging.logEvent(MPLogEvent(message: "Requesting Ad form AirMonetization", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        if currentRewardedAd != nil {
            currentRewardedAd?.removeFromViewController()
            currentRewardedAd?.stop()
            currentRewardedAd?.dismiss()
            currentRewardedAd = nil
        }
        
        guard let adapterInfo = MPAirMonetizationMoPubAdapterInfo(remote: info, local: localExtras) else {
            let error = MPAirMonetizationMoPubAdapterError.noApiKeyOrAppId
            MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                               source: nil,
                               from: self.classForCoder)
            self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        
        var requestPlacementName: String? = nil
        if let placement = self.placementName {
            requestPlacementName = placement
        } else if let placement = adapterInfo.placementName {
            requestPlacementName = placement
        }

        guard let requestPlacementName = requestPlacementName else {
            let error = MPAirMonetizationMoPubAdapterError.placementNameForRewardedNotFound
            MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                               source: nil,
                               from: self.classForCoder)
            self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        
        currentRewardedAd = AirMonetizationRewarded.rewarded(placementName: requestPlacementName)
        currentRewardedAd?.setSource(source: "MoPub")
        if let userID = adapterInfo.rewardedUserId {
            currentRewardedAd?.setUserId(userId: userID)
        }
        currentRewardedAd?.rewardDelegate = self
        currentRewardedAd?.load()
    }
    
    public override func presentAd(from viewController: UIViewController) {
        if let rewardedAd = currentRewardedAd, rewardedAd.isCanOpen {
            MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Will Present", level: .debug),
                               source: nil,
                               from: self.classForCoder)
            rewardedAd.show()
            self.delegate?.fullscreenAdAdapterAdWillPresent(self)
            self.delegate?.fullscreenAdAdapterAdWillAppear(self)
        }
    }
    
    
    //MARK: - AirMonetizationRewardedAdDelegate Protocol
    public func rewardedAdDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
    }
    
    public func rewardedAdDidFinishLoad(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). RewardName: \(rewardName). RewardValue: \(rewardValue)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Received", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterDidLoadAd(self)
    }
    
    public func rewardedAdDidReceiveReward(ad: AirMotetizationAd, rewardName: String, rewardValue: Int) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). RewardName: \(rewardName). RewardValue: \(rewardValue)")
        #endif
        guard let reward = MPReward(currencyType: rewardName, amount: NSNumber(value: rewardValue)) else {
            return
        }
        
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Completed: \(reward)", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(self, willRewardUser: reward)
    }
    
    public func rewardedAdDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Opened", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.fullscreenAdAdapterAdDidPresent(self)
        self.delegate?.fullscreenAdAdapterAdDidAppear(self)
        self.delegate?.fullscreenAdAdapterDidTrackImpression(self)
    }
    
    public func rewardedAdDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Did Click", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.fullscreenAdAdapterDidReceiveTap(self)
        self.delegate?.fullscreenAdAdapterDidTrackClick(self)
    }
    
    public func rewardedAdDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Closed", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidDisappear(self)
    }
    
    public func rewardedAdDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Did Complete", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdWillDismiss(self)
    }
    
    public func rewardedAdDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Rewarded Did Dismiss", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidDismiss(self)
    }
    
    public func rewardedAdDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = MPAirMonetizationMoPubAdapterError.rewardedNotAvailable
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
    }
    
    public func rewardedAdDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Rewarded] AirMonetizationRewardedAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = MPAirMonetizationMoPubAdapterError.rewardedNotAvailable
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(self, didFailToShowAdWithError: error)
    }
    
}
