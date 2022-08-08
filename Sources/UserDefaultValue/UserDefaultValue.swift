//
//  UserDefaultValue.swift
//  HBTools
//
//  Created by mlch911 on 2021/8/12.
//

import Foundation

@propertyWrapper
public struct UserDefaultValue<T> {
    public let key: String
    public let defaultValue: T
	public let userDefaults: UserDefaults

	public init(key: String, userDefaults: UserDefaults = .standard, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
		self.userDefaults = userDefaults
        guard UserDefaults.standard.object(forKey: key) is T else {
            self.wrappedValue = defaultValue
            return
        }
    }

    public init(wrappedValue: T, key: String, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = wrappedValue
		self.userDefaults = userDefaults
        guard userDefaults.object(forKey: key) is T else {
            self.wrappedValue = wrappedValue
            return
        }
    }

    public var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        nonmutating set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    // 语法糖。假设有变量 a，使用 $a 即可访问到 projectedValue 属性。此处将 projectedValue 指向 struct 本身，即可通过 $a 访问 struct 本身。
    public var projectedValue: Self { self }
}

@propertyWrapper
public struct UserDefaultOptionalValue<T> {
    public let key: String
	public let userDefaults: UserDefaults

    public init(key: String, userDefaults: UserDefaults = .standard) {
		self.key = key
		self.userDefaults = userDefaults
    }

    public init(wrappedValue: T?, key: String, userDefaults: UserDefaults = .standard) {
        self.key = key
		self.userDefaults = userDefaults
        guard userDefaults.object(forKey: key) is T else {
            self.wrappedValue = wrappedValue
            return
        }
    }

    public var wrappedValue: T? {
        get { UserDefaults.standard.object(forKey: self.key) as? T }
        nonmutating set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    // 语法糖。假设有变量 a，使用 $a 即可访问到 projectedValue 属性。此处将 projectedValue 指向 struct 本身，即可通过 $a 访问 struct 本身。
    public var projectedValue: Self { self }
}
