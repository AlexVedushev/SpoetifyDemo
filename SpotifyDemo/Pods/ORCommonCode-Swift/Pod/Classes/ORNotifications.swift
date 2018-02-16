//
//  ORNotifications.swift
//  Pods
//
//  Created by Maxim Soloviev on 16/04/16.
//
//

import Foundation

public func or_addObserver(_ observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject? = nil) {
    let notificationName: Notification.Name? = aName != nil ? Notification.Name(aName!) : nil
    NotificationCenter.default.addObserver(observer, selector: aSelector, name: notificationName, object: anObject)
}

public func or_removeObserver(_ observer: AnyObject, name aName: String?, object anObject: AnyObject? = nil) {
    let notificationName: Notification.Name? = aName != nil ? Notification.Name(aName!) : nil
    NotificationCenter.default.removeObserver(observer, name: notificationName, object: anObject)
}

public func or_postNotification(_ name: String, object anObject: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: anObject, userInfo: userInfo)
}
