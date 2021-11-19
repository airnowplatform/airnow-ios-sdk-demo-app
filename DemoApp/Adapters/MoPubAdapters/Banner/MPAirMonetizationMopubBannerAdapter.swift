//
//  MPAirMonetizationMopubBannerAdapter.swift
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


@objc(MPAirMonetizationMopubBannerAdapter)
public class MPAirMonetizationMopubBannerAdapter: MPInlineAdAdapter, MPThirdPartyInlineAdAdapter, MPAdapterConfiguration, AirMonetizationAdDelegate {
    
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
    private var currentBannerAd: AirMotetizationAd?
    
    public override func enableAutomaticImpressionAndClickTracking() -> Bool {
        return false
    }
    
    public override func requestAd(with size: CGSize, adapterInfo info: [AnyHashable : Any], adMarkup: String?) {
        MPLogging.logEvent(MPLogEvent(message: "Requesting Ad form AirMonetization", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        if currentBannerAd != nil {
            currentBannerAd?.removeFromViewController()
            currentBannerAd?.stop()
            currentBannerAd?.dismiss()
            currentBannerAd = nil
        }
        
        guard let adapterInfo = MPAirMonetizationMoPubAdapterInfo(remote: info, local: localExtras) else {
            let error = MPAirMonetizationMoPubAdapterError.noApiKeyOrAppId
            MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                               source: nil,
                               from: self.classForCoder)
            self.delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        
        var requestPlacementName: String? = nil
        if let placement = self.placementName {
            requestPlacementName = placement
        } else if let placement = adapterInfo.placementName {
            requestPlacementName = placement
        }
        
        currentBannerAd = AirMonetizationInappBanner.inappBanner(withBannerSize: size)
        if let requestPlacementName = requestPlacementName {
            currentBannerAd?.setPlacementName(placementName: requestPlacementName)
        }
        currentBannerAd?.setSource(source: "MoPub")
        currentBannerAd?.delegate = self
        currentBannerAd?.load()
    }
    
    
    //MARK: - AirMonetizationAdDelegate Protocol
    public func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Banner Received", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.inlineAdAdapter(self, didLoadAdWithAdView: ad.view)
        currentBannerAd?.show()
    }
    
    public func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Banner Did Show", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.inlineAdAdapterDidTrackImpression(self)
    }
    
    public func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Banner Did Click", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.inlineAdAdapterDidTrackClick(self)
    }
    
    public func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Banner Closed", level: .debug),
                           source: nil,
                           from: self.classForCoder)
        
        self.delegate?.inlineAdAdapterDidEndUserAction(self)
    }
    
    public func adDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Banner Did Complete", level: .debug),
                           source: nil,
                           from: self.classForCoder)
    }
    
    public func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        MPLogging.logEvent(MPLogEvent(message: "AirMonetization Banner Did Dismiss", level: .debug),
                           source: nil,
                           from: self.classForCoder)
    }
    
    public func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = MPAirMonetizationMoPubAdapterError.bannerNotAvailable
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: error)
    }
    
    public func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization MoPub Adapter Banner] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = MPAirMonetizationMoPubAdapterError.bannerNotAvailable
        MPLogging.logEvent(MPLogEvent(message: error.description, level: .debug),
                           source: nil,
                           from: self.classForCoder)
        self.delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: error)
    }
    
}
