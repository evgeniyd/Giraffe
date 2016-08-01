//
//  UIKitExtensions.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import ReactiveCocoa

struct AssociationKey {
    static var hidden: UInt8 = 1
    static var alpha: UInt8 = 2
    static var text: UInt8 = 3
    static var image: UInt8 = 4
    static var title: UInt8 = 5
    static var enabled: UInt8 = 6
    static var selected: UInt8 = 7
    static var animated: UInt8 = 8
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T
    
    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    return associatedProperty!
}

func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithNext { newValue in
                setter(newValue)
        }
        return property
    }
}

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
    }
}

extension UIImageView {
    public var rac_image: MutableProperty<UIImage?> {
        return lazyMutableProperty(self, key: &AssociationKey.image, setter: { self.image = $0 }, getter: { self.image })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text) {
            
            self.addTarget(self, action: #selector(UITextField.changed), forControlEvents: UIControlEvents.EditingChanged)
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithNext { newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    func changed() {
        rac_text.value = self.text!
    }
}

extension UINavigationItem {
    public var rac_title: MutableProperty<String?> {
        return lazyMutableProperty(self, key: &AssociationKey.title, setter: { self.title = $0 }, getter: { self.title })
    }
}

extension UIBarButtonItem {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.enabled, setter: { self.enabled = $0 }, getter: { self.enabled  })
    }
    
    // TODO: return valid value in rac_selected getter
    public var rac_selected: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.selected,
                                   setter: { self.image = $0 ? UIImage(named: "familyhl") : UIImage(named: "family") },
                                   getter: { self.enabled /*fake*/  }
        )
    }
}

extension UIActivityIndicatorView {
    public var rac_animated: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.animated, setter: { $0 ? self.startAnimating() : self.stopAnimating() }, getter: { self.isAnimating() })
    }
}

extension UISearchBar: UISearchBarDelegate {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text, factory: {
            self.delegate = self;
            self.rac_signalForSelector(#selector(UISearchBarDelegate.searchBar(_:textDidChange:)), fromProtocol: UISearchBarDelegate.self)
                .toSignalProducer()
                .startWithResult { [weak self] _ in
                    self?.changed()
            }
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer.startWithResult { result in
                self.text = result.value
            }
            return property
        })
    }
    
    func changed() {
        rac_text.value = self.text ?? ""
    }
    
    func rac_searchBarSearchButtonClicked(callback: ((UISearchBar) -> Void)) {
        self.rac_signalForSelector(#selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:)), fromProtocol: UISearchBarDelegate.self)
            .toSignalProducer()
            .startWithResult { result in
                guard let tuple = result.value as? RACTuple else { return }
                guard let searchBar = tuple.first as? UISearchBar else { return }
                
                callback(searchBar)
        }
    }
    
    func rac_searchBarCancelButtonClicked(callback: ((UISearchBar) -> Void)) {
        self.rac_signalForSelector(#selector(UISearchBarDelegate.searchBarCancelButtonClicked(_:)), fromProtocol: UISearchBarDelegate.self)
            .toSignalProducer()
            .startWithResult { result in
                guard let tuple = result.value as? RACTuple else { return }
                guard let searchBar = tuple.first as? UISearchBar else { return }
                
                callback(searchBar)
        }
    }
}
