//
//  DirectBannersViewController.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 27.09.21.
//

import UIKit
import AirMonetizationSDK

class DirectBannersViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var inAppBannerView: UIView!
    @IBOutlet weak var loadNewAdButton: ShadowButton!
    @IBOutlet weak var inappBannerButton: ShadowButton!
    @IBOutlet weak var inlineBannerButton: ShadowButton!
    
    //MARK: - Properties
    private var banner: AirMotetizationAd? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard banner != nil else { return }
        banner?.uninstallPreviousAd()
        banner = nil
    }
    
    @IBAction func loadAdAction(_ sender: UIButton) {
        guard banner != nil else { return }
        banner?.load()
    }
    
    @IBAction func loadInAppBannerAdAction(_ sender: UIButton) {
        if banner != nil {
            banner?.uninstallPreviousAd()
            banner = nil
        }
        banner = AirMonetizationInappBanner.inappBanner()
        /**
         *  YOU CAN ADD PLACEMENT NAME FOR BANNERS
         *  banner?.setPlacementName(placementName: "PLACEMENT_NAME")
         */
        banner?.delegate = self
        banner?.load()
    }
    
    @IBAction func loadInlineBannerAdAction(_ sender: UIButton) {
        if banner != nil {
            banner?.uninstallPreviousAd()
            banner = nil
        }
        banner = AirMonetizationInlileBanner.inlineBanner(bannerView: inAppBannerView)
        /**
         *  YOU CAN ADD PLACEMENT NAME FOR BANNERS
         *  banner?.setPlacementName(placementName: "PLACEMENT_NAME")
         */
        banner?.delegate = self
        banner?.load()
    }
    
    private func disableButtons() {
        self.showActivityIndicator()
        self.inappBannerButton.disable()
        self.inlineBannerButton.disable()
        self.loadNewAdButton.disable()
    }
    
    private func enableButtons() {
        self.hideActivityIndicator()
        self.inappBannerButton.enable()
        self.inlineBannerButton.enable()
        self.loadNewAdButton.enable()
    }
    
}

extension DirectBannersViewController: AirMonetizationAdDelegate {
    //MARK: - AirMotetizationAdDelegate
    func adDidStartLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function)")
        #endif
        disableButtons()
    }

    func adDidFinishLoad(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function)")
        #endif
        enableButtons()
        banner?.show()
    }

    func adDidShow(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidClick(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidClose(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidComplete(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidDismiss(ad: AirMotetizationAd) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function)")
        #endif
    }

    func adDidFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function), error: \(error)")
        #endif
        enableButtons()
    }
    
    func adDidShowFailWithError(ad: AirMotetizationAd, error: String) {
        #if DEBUG
        print("[AirMonetization Direct Banner] AirMotetizationAdDelegate: \(#function), error: \(error)")
        #endif
        enableButtons()
    }
}
