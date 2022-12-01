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

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        guard UserDefaults.standard.object(forKey: key) is T else {
            self.wrappedValue = defaultValue
            return
        }
    }

    public init(wrappedValue: T, key: String) {
        self.key = key
        self.defaultValue = wrappedValue
        guard UserDefaults.standard.object(forKey: key) is T else {
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

    public init(key: String) {
        self.key = key
    }

    public init(wrappedValue: T?, key: String) {
        self.key = key
        guard UserDefaults.standard.object(forKey: key) is T else {
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

/// Wrapper for Codable Model to store as Data in UserDefaults.
@propertyWrapper
public struct UserDefaultCodableValue<T> where T: Codable {
    public let key: String
    public let defaultValue: T

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        guard UserDefaults.standard.object(forKey: key) is T else {
            self.wrappedValue = defaultValue
            return
        }
    }

    public init(wrappedValue: T, key: String) {
        self.key = key
        self.defaultValue = wrappedValue
        guard let data = UserDefaults.standard.object(forKey: key) as? Data, let _ = try? JSONDecoder().decode(T.self, from: data) else {
            self.wrappedValue = wrappedValue
            return
        }
    }

    public var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return self.defaultValue }
            return (try? JSONDecoder().decode(T.self, from: data)) ?? self.defaultValue
        }
        nonmutating set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // 语法糖。假设有变量 a，使用 $a 即可访问到 projectedValue 属性。此处将 projectedValue 指向 struct 本身，即可通过 $a 访问 struct 本身。
    public var projectedValue: Self { self }
}

/// Wrapper for Codable Model to store as Data in UserDefaults.
@propertyWrapper
public struct UserDefaultCodableOptionalValue<T> where T: Codable {
    public let key: String

    public init(key: String) {
        self.key = key
    }

    public init(wrappedValue: T?, key: String) {
        self.key = key
        guard UserDefaults.standard.object(forKey: key) is T else {
            self.wrappedValue = wrappedValue
            return
        }
    }

    public var wrappedValue: T? {
        get {
            guard let data = UserDefaults.standard.object(forKey: self.key) as? Data else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        nonmutating set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // 语法糖。假设有变量 a，使用 $a 即可访问到 projectedValue 属性。此处将 projectedValue 指向 struct 本身，即可通过 $a 访问 struct 本身。
    public var projectedValue: Self { self }
}
