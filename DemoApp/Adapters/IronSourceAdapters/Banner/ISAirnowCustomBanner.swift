//
//  ISAirnowCustomBanner.swift
//  AirnowMediationWithIS
//
//  Created by Gusakovsky, Sergey on 15.12.21.
//

import Foundation
import ObjectiveC.runtime
import AirMonetizationSDK

@objc(ISAirnowCustomBanner)
public class ISAirnowCustomBanner: ISBaseAdAdapter, AirMonetizationAdDelegate {
        
    @objc private var banner: AirMotetizationAd?
    
    @objc private weak var adapterDelegate: ISAdapterAdDelegate? = nil
    
    @objc public override func loadAd(with adData: ISAdData, delegate: ISAdapterAdDelegate) {
        guard
            let apiKey = adData.configuration[ISAdapterConstants.ExtraKey.APIKey] as? String,
            let appId = adData.configuration [ISAdapterConstants.ExtraKey.appID] as? String
        else
        {
            delegate.adDidFailToLoadWith(
                .internal,
                errorCode: Int32(ISAdapterErrors.missingParams.rawValue),
                errorMessage: ISAirMonetizationAdapterError.noApiKeyOrAppId.description
            )
            return
        }
        
        //MARK: - TODO
        AirMonetization.shared.setAPIKey(key: apiKey, appID: appId)
        AirMonetization.shared.setTestMode(testMode: false)
        
        self.adapterDelegate = delegate
        
        DispatchQueue.main.async {
            if self.banner != nil {
                self.banner?.removeFromViewController()
                self.banner?.stop()
                self.banner?.dismiss()
                self.banner = nil
            }
            
            self.banner = AirMonetizationInappBanner.inappBanner()
            if let placementName = adData.configuration[ISAdapterConstants.ExtraKey.placementName] as? String {
                self.banner?.setPlacementName(placementName: placementName)
            }
            
            self.banner?.setSource(source: "IronSource")
            self.banner?.delegate = self
            self.banner?.load()
        }
    }
    
    @objc public override func isAdAvailable(with adData: ISAdData) -> Bool {
        return banner?.isCanOpen ?? false
    }
    
    @objc public override func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISAdapterAdDelegate) {
        
    }

    //MARK: - AirMonetizationAdDelegate Protocol
    public func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidLoad()
        if let banner = banner, banner.isCanOpen {
            banner.show()
        }
    }
    
    public func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidOpen()
    }
    
    public func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidClick()
        adapterDelegate?.adDidClose()
    }
    
    public func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidClose()
    }
    
    public func adDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function)")
        #endif
    }
    
    public func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        adapterDelegate?.adDidFailToLoadWith(
            .internal,
            errorCode: Int32(ISAdapterErrors.internal.rawValue),
            errorMessage: ISAirMonetizationAdapterError.interstitialNotAvailable.description
        )
    }
    
    public func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Banner] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        adapterDelegate?.adDidFailToShowWithErrorCode(
            Int32(ISAdapterErrors.missingParams.rawValue),
            errorMessage: ISAirMonetizationAdapterError.interstitialNotAvailable.description
        )
    }
    
}
