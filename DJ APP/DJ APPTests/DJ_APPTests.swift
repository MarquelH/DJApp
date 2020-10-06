//
//  DJ_APPTests.swift
//  DJ APPTests
//
//  Created by arturo ho on 8/24/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import XCTest
import Firebase
@testable import DJ_APP

class DJ_APPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDJLogin() {
        let djLoginController = DJLoginController()
        djLoginController.usernameTextField.text = "HelloHello@gmail.com"
        djLoginController.passwordTextField.text = "123456"
        djLoginController.handleLogin()
        XCTAssert(Auth.auth().currentUser != nil)
    }
    
    func testUserLogin() {
        let listenerLoginController = LoginController()
        listenerLoginController.usernameTextField.text = "user123@google.com"
        listenerLoginController.handleGuestEnter()
        XCTAssert(Auth.auth().currentUser != nil)
    }
    
}
