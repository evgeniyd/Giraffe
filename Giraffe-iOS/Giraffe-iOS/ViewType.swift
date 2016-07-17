//
//  ViewType.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

protocol ViewType {
    associatedtype VM: ViewModelType
    var viewModel: VM { get }
    func setupBindings()
}
