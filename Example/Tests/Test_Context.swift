//
//  Test_Context.swift
//  EasyDi
//
//  Created by Andrey Zarembo-godzyatskiy on 28.04.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import EasyDi

class Test_Context: XCTestCase {

    func testDefaultContext() {
        
        class TestAssembly: Assembly {
        }
        
        let assemblyInstance1 = TestAssembly.instance()
        let assemblyInstance2 = TestAssembly.instance()
        
        XCTAssertTrue(assemblyInstance1 === assemblyInstance2)
    }
    
    
    func testSameContext() {
        
        class TestAssembly: Assembly {
        }
        
        let context: DIContext = DIContext()
        let assemblyInstance1 = TestAssembly.instance(from: context)
        let assemblyInstance2 = TestAssembly.instance(from: context)
        
        XCTAssertTrue(assemblyInstance1 === assemblyInstance2)
    }
    
    func testDifferentContexts() {
        
        class TestAssembly: Assembly {
        }
        
        let assemblyInstance1 = TestAssembly.instance()
        
        let context: DIContext = DIContext()
        let assemblyInstance2 = TestAssembly.instance(from: context)
        
        XCTAssertFalse(assemblyInstance1 === assemblyInstance2)
    }
        
}
