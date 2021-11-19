//
//  AirMotetizationAd+uninstall.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 27.09.21.
//

import Foundation
import AirMonetizationSDK

extension AirMotetizationAd {
    func uninstallPreviousAd() {
        self.removeFromViewController()
        self.stop()
        self.dismiss()
    }
}
