//
//  GADMAdapterAirMonetizationBanner.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 21.09.21.
//

import Foundation
import AirMonetizationSDK
import GoogleMobileAds

/// Class adapting AirMonetization banner to work with Google Mobile Ads mediation.
@objc public final class GADAdapterAirMonetizationBanner: NSObject, GADCustomEventBanner {

    // MARK: - Members
    private var currentBanner: AirMotetizationAd?
    
    //MARK: - Delegate
    @objc public weak var delegate: GADCustomEventBannerDelegate?
    
    //MARK: - Init
    @objc required public override init() {
        super.init()
    }
    
    // MARK: - GADCustomEventBanner Protocol
    @objc public func requestAd(_ adSize: GADAdSize, parameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        
        // Prepare AirMonetization SDK settings
        guard let serverParameter = serverParameter,
              let data = serverParameter.data(using: .utf8),
              let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let airMonetizationSettings = try? AirMonetizationAdapterSettings.instance(fromAdmobParameters: jsonDictionary)
        else {
            let error = NSError.from(code: .SDKCredentialsNotFound,
                                     description: "AirMonetization SDK integration error. Check if SDK Credentials is added to Google console.",
                                     domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
            delegate?.customEventBanner(self, didFailAd: error)
            return
        }
        
        if currentBanner != nil {
            currentBanner?.removeFromViewController()
            currentBanner?.stop()
            currentBanner?.dismiss()
            currentBanner = nil
        }
        
        let bannerSize = AirMonetizationBannerSize(width: Int(adSize.size.width),
                                                   height: Int(adSize.size.height))
        currentBanner = AirMonetizationInappBanner.inappBanner(withBannerSize: bannerSize)
        
        if let placementName = airMonetizationSettings.placementName {
            currentBanner?.setPlacementName(placementName: placementName)
        }
        
        currentBanner?.setSource(source: "AdMob")
        currentBanner?.delegate = self
        currentBanner?.load()
    }
    

}

extension GADAdapterAirMonetizationBanner: AirMonetizationAdDelegate {
    public func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        if let banner = currentBanner, banner.isCanOpen {
            banner.show()
            delegate?.customEventBanner(self, didReceiveAd: banner.view)
        }
    }
    
    public func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventBannerWasClicked(self)
    }
    
    public func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventBannerWasClicked(self)
        delegate?.customEventBannerDidDismissModal(self)
    }
    
    public func adDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventBannerWillDismissModal(self)
    }
    
    public func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventBannerDidDismissModal(self)
    }
    
    public func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = NSError.from(code: .loadingFailure,
                                 description: error,
                                 domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
        delegate?.customEventBanner(self, didFailAd: error)
    }
    
    public func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Banner] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = NSError.from(code: .loadingFailure,
                                 description: error,
                                 domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
        delegate?.customEventBanner(self, didFailAd: error)
    }
    
}
