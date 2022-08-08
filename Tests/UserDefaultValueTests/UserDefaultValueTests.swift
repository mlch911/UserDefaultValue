import XCTest
@testable import UserDefaultValue

final class UserDefaultValueTests: XCTestCase {
    func test() throws {
		UserDefaults.resetStandardUserDefaults()
		
		XCTAssertEqual(UserDefaults.testString, "")
		XCTAssertEqual(UserDefaults.testInt, 0)
		XCTAssertEqual(UserDefaults.testDouble, 0.0)
		
		UserDefaults.testString = "Hello, World!"
		UserDefaults.testInt = 100
		UserDefaults.testDouble = 99.99
		
		XCTAssertEqual(UserDefaults.testString, "Hello, World!")
		XCTAssertEqual(UserDefaults.testInt, 100)
		XCTAssertEqual(UserDefaults.testDouble, 99.99)
    }
}

extension UserDefaults {
	@UserDefaultValue(key: "testString")
	static var testString = ""
	
	@UserDefaultValue(key: "testInt")
	static var testInt = 0
	
	@UserDefaultValue(key: "testDouble")
	static var testDouble = 0.0
}
