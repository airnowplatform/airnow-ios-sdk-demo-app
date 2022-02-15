//
//  ISAirnowCustomInterstitial.swift
//  AirnowMediationWithIS
//
//  Created by Gusakovsky, Sergey on 14.12.21.
//

import Foundation
import ObjectiveC.runtime
import AirMonetizationSDK

//MARK: - Use this interstitial adapter only for IronSource SDK version less then 7.2.0
@objc(ISAirnowCustomInterstitial)
public class ISAirnowCustomInterstitial: ISBaseAdAdapter, AirMonetizationAdDelegate {

    @objc private var interstitialAd: AirMotetizationAd?

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
            if self.interstitialAd != nil {
                self.interstitialAd?.removeFromViewController()
                self.interstitialAd?.stop()
                self.interstitialAd?.dismiss()
                self.interstitialAd = nil
            }

            self.interstitialAd = AirMonetizationInterstitial.interstitial()
            if let placementName = adData.configuration[ISAdapterConstants.ExtraKey.placementName] as? String {
                self.interstitialAd?.setPlacementName(placementName: placementName)
            }

            self.interstitialAd?.setSource(source: "IronSource")
            self.interstitialAd?.delegate = self
            self.interstitialAd?.load()
        }
    }

    @objc public override func isAdAvailable(with adData: ISAdData) -> Bool {
        return interstitialAd?.isCanOpen ?? false
    }

    @objc public override func showAd(with viewController: UIViewController, adData: ISAdData, delegate: ISAdapterAdDelegate) {
        if let interstitialAd = interstitialAd, interstitialAd.isCanOpen {
            interstitialAd.show()
        }
    }

    //MARK: - AirMonetizationAdDelegate Protocol
    public func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
    }

    public func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidLoad()
    }

    public func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidOpen()
    }

    public func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidClick()
        adapterDelegate?.adDidClose()
    }

    public func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidClose()
    }

    public func adDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
    }

    public func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function)")
        #endif
        adapterDelegate?.adDidClose()
    }

    public func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        adapterDelegate?.adDidFailToLoadWith(
            .internal,
            errorCode: Int32(ISAdapterErrors.internal.rawValue),
            errorMessage: ISAirMonetizationAdapterError.interstitialNotAvailable.description
        )
    }

    public func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization IronSource Adapter Interstitial] AirMonetizationAdDelegate: \(#function). Error: \(error)")
        #endif
        adapterDelegate?.adDidFailToShowWithErrorCode(
            Int32(ISAdapterErrors.missingParams.rawValue),
            errorMessage: ISAirMonetizationAdapterError.interstitialNotAvailable.description
        )
    }

}
