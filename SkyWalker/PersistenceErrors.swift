//
//  PersistenceErrors.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 12/5/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import Foundation

enum PersistenceErrors: Error {
    case INTERNET_ERROR, SERVER_ERROR, INVALID_CREDENTIALS, INVALID_URL
}
