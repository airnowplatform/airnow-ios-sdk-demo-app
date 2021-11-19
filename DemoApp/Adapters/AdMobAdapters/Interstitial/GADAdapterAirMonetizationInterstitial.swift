//
//  GADAdapterAirMonetizationInterstitial.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 21.09.21.
//

import Foundation
import GoogleMobileAds
import AirMonetizationSDK

/// Class adapting AirMonetization interstitial to work with Google Mobile Ads mediation.
@objc public final class GADAdapterAirMonetizationInterstitial: NSObject, GADCustomEventInterstitial {
    
    // MARK: - Members
    private var currentInterstital: AirMotetizationAd?
    
    //MARK: - Delegate
    @objc public weak var delegate: GADCustomEventInterstitialDelegate?
    
    //MARK: - Init
    @objc required public override init() {
        super.init()
    }
    
    // MARK: - GADCustomEventInterstitial Protocol
    public func requestAd(withParameter serverParameter: String?, label serverLabel: String?, request: GADCustomEventRequest) {
        
        // Prepare AirMonetization SDK settings
        guard let serverParameter = serverParameter,
              let data = serverParameter.data(using: .utf8),
              let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let airMonetizationSettings = try? AirMonetizationAdapterSettings.instance(fromAdmobParameters: jsonDictionary)
        else {
            let error = NSError.from(code: .SDKCredentialsNotFound,
                                     description: "AirMonetization SDK integration error. Check if SDK Credentials is added to Google console.",
                                     domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
            delegate?.customEventInterstitial(self, didFailAd: error)
            return
        }
        
        if currentInterstital != nil {
            currentInterstital?.removeFromViewController()
            currentInterstital?.stop()
            currentInterstital?.dismiss()
            currentInterstital = nil
        }
        currentInterstital = AirMonetizationInterstitial.interstitial()
        if let placementName = airMonetizationSettings.placementName {
            currentInterstital?.setPlacementName(placementName: placementName)
        }
        
        currentInterstital?.setSource(source: "AdMob")
        currentInterstital?.delegate = self
        currentInterstital?.load()
        
    }
    
    public func present(fromRootViewController rootViewController: UIViewController) {
        if let interstitial = currentInterstital, interstitial.isCanOpen {
            interstitial.show()
        }
    }
    
}

extension GADAdapterAirMonetizationInterstitial: AirMonetizationAdDelegate {
    public func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventInterstitialDidReceiveAd(self)
    }
    
    public func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventInterstitialWasClicked(self)
    }
    
    public func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventInterstitialWillDismiss(self)
    }
    
    public func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        delegate?.customEventInterstitialDidDismiss(self)
    }
    
    public func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = NSError.from(code: .loadingFailure,
                                 description: error,
                                 domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
        delegate?.customEventInterstitial(self, didFailAd: error)
    }
    
    public func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization AdMob Adapter Interstitial] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        let error = NSError.from(code: .loadingFailure,
                                 description: error,
                                 domain: GADAdapterAirMonetizationConstants.kGADMAdapterAirMonetizationErrorDomain)
        delegate?.customEventInterstitial(self, didFailAd: error)
    }
    
}
