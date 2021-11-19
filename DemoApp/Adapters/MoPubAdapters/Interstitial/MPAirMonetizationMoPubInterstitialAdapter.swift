//
//  MPAirMonetizationMoPubInterstitialAdapter.swift
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

@objc(MPAirMonetizationMoPubInterstitialAdapter)
public class MPAirMonetizationMoPubInterstitialAdapter: MPFullscreenAdAdapter, MPThirdPartyFullscreenAdAdapter, MPAdapterConfiguration, AirMonetizationAdDelegate {
    
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
    private var currentInterstitialAd: AirMotetizationAd?
    
    public override var isRewardExpected: Bool {
        return false
    }
    
    @objc public override func requestAd(withAdapterInfo info: [AnyHashable : Any], adMarkup: String?) {
        MPLogging.logEvent(MPLogEvent(message: "Requesting Ad form AirMonetization", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        if currentInterstitialAd != nil {
            currentInterstitialAd?.removeFromViewController()
            currentInterstitialAd?.stop()
            currentInterstitialAd?.dismiss()
            currentInterstitialAd = nil
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
        
        currentInterstitialAd = AirMonetizationInterstitial.interstitial()
        if let requestPlacementName = requestPlacementName {
            currentInterstitialAd?.setPlacementName(placementName: requestPlacementName)
        }
        currentInterstitialAd?.setSource(source: "MoPub")
        currentInterstitialAd?.delegate = self
        currentInterstitialAd?.load()
    }
    
    public override func presentAd(from viewController: UIViewController) {
        if let interstitialAd = currentInterstitialAd, interstitialAd.isCanOpen {
            MPLogging.logEvent(MPLogEvent(message: "AirMonetization Interstitial Will Present", level: .debug),
                               source: nil,
                               from: self.classForCoder)
            interstitialAd.show()
            self.delegate?.fullscreenAdAdapterAdWillPresent(self)
            self.delegate?.fullscreenAdAdapterAdWillAppear(self)
        }
    }
    
    
    //MARK: - AirMonetizationAdDelegate Protocol
    public func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Interstitial Received", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterDidLoadAd(self)
    }
    
    public func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Interstitial Opened", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.fullscreenAdAdapterAdDidPresent(self)
        self.delegate?.fullscreenAdAdapterAdDidAppear(self)
        self.delegate?.fullscreenAdAdapterDidTrackImpression(self)
    }
    
    public func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Interstitial Did Click", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.fullscreenAdAdapterDidReceiveTap(self)
        self.delegate?.fullscreenAdAdapterDidTrackClick(self)
    }
    
    public func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Interstitial Closed", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidDisappear(self)
    }
    
    public func adDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Interstitial Did Complete", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdWillDismiss(self)
    }
    
    public func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Interstitial Did Dismiss", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapterAdDidDismiss(self)
    }
    
    public func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = MPAirMonetizationMoPubAdapterError.interstitialNotAvailable
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
    }
    
    public func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Interstitial] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = MPAirMonetizationMoPubAdapterError.interstitialNotAvailable
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.fullscreenAdAdapter(self, didFailToShowAdWithError: error)
    }
    
}
