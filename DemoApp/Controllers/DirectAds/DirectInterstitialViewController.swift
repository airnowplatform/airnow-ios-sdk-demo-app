//
//  DirectInterstitialViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 27.09.21.
//

import UIKit
import AirMonetizationSDK

class DirectInterstitialViewController: UIViewController {

    //MARK: - Properties
    private var interstitial: AirMotetizationAd? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard interstitial != nil else { return }
        interstitial?.uninstallPreviousAd()
        interstitial = nil
    }
    
    @IBAction func loadAdAction(_ sender: UIButton) {
        guard interstitial != nil else { return }
        interstitial?.load()
    }
    
    @IBAction func loadInterstitialAdAction(_ sender: UIButton) {
        if interstitial != nil {
            interstitial?.uninstallPreviousAd()
            interstitial = nil
        }
        interstitial = AirMonetizationInterstitial.interstitial()
        /**
         *  YOU CAN ADD PLACEMENT NAME FOR INTERSTITIAL
         *  interstitial?.setPlacementName(placementName: "PLACEMENT_NAME")
         */
        interstitial?.delegate = self
        interstitial?.load()
    }
    
    @IBAction func showInterstitialAd(_ sender: UIButton) {
        if let interstitial = interstitial, interstitial.isCanOpen {
            interstitial.show()
        }
    }
    
}

extension DirectInterstitialViewController: AirMonetizationAdDelegate {
    
    //MARK: - AirMotetizationAdDelegate
    func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Interstitial] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Interstitial] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Interstitial] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Interstitial] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Interstitial] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidComplete(ad: AirMotetizationAd) {
        print("AirMotetizationAdDelegate: \(#function)")
    }

    func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Interstitial] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization Direct Interstitial] AirMotetizationAdDelegate: \(#function), error: \(error)")
        #endif
    }
    
    func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function), error: \(error)")
        #endif
    }
}
