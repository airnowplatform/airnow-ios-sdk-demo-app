//
//  AirMonetizationAdapterErrorCode.swift
//  DemoApp
//
//  Created by Gusakovsky, Sergey on 21.09.21.
//

import Foundation

/// Enumeration defining possible errors in Teads adapter.
public enum AirMonetizationAdapterErrorCode: Int {
    case pidNotFound = 1010
    case SDKCredentialsNotFound
    case loadingFailure
}

extension NSError {

    static func from(code: AirMonetizationAdapterErrorCode,
                     description: String,
                     domain: String) -> Error {

        let userInfo = [NSLocalizedDescriptionKey: description,
                        NSLocalizedFailureReasonErrorKey: description]

        return NSError(domain: domain,
                       code: code.rawValue,
                       userInfo: userInfo)
    }
}
