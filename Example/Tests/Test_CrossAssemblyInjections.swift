//
//  Test_CrossAssemblyInjections.swift
//  EasyDi
//
//  Created by Andrey Zarembo on 17.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import EasyDi

class Test_CrossAssemblyInjections: XCTestCase {
    
    class TestObject {
        
        var childObject:TestChildObject? = nil
        var childObjects:[TestChildObject] = []
        
    }
    
    class TestChildObject {
        
        weak var parentObject: TestObject? = nil
    }
    
    class TestObjectAssembly: Assembly {
        
        
        lazy var testChildObjectAssembly:TestChildObjectAssembly = self.context.assembly()

        var testObject: TestObject {
            return define(init: TestObject()) {
                
                $0.childObject = self.testChildObjectAssembly.testChildObject
                $0.childObjects = [
                    self.testChildObjectAssembly.testChildObject,
                    self.testChildObjectAssembly.testChildObjectPrototype,
                    self.testChildObjectAssembly.testChildObjectPrototype
                ]
            }
        }
    }
    
    class TestChildObjectAssembly: Assembly {
        
        var testObjectAssembly:TestObjectAssembly {
            return TestObjectAssembly.instance(from: self.context)
        }
        
        var testChildObject: TestChildObject {
            return define(init: TestChildObject()) {
                $0.parentObject = self.testObjectAssembly.testObject
            }
        }
        
        var testChildObjectPrototype: TestChildObject {
            return define(scope: .prototype, init: TestChildObject()) {
                $0.parentObject = self.testObjectAssembly.testObject
            }
        }
    }
    
    func testChildObjectIsCreates() {
        // Here and next contexts are used not to share any assembly instances between tests
        let context = DIContext()
        let testObject = TestObjectAssembly.instance(from: context).testObject
        XCTAssertNotNil(testObject.childObject)
    }
    
    func testParentObjectAssignedAndValud() {
        
        let context = DIContext()
        let testObject = TestObjectAssembly.instance(from: context).testObject
        XCTAssertNotNil(testObject.childObject?.parentObject)
        XCTAssert(testObject === testObject.childObject?.parentObject)
    }
    
    func testChildNotRecreated() {
        
        let context = DIContext()
        let testObject = TestObjectAssembly.instance(from: context).testObject
        XCTAssert(testObject.childObject === testObject.childObjects.first)
    }
    
    func testParentIsSameForAllChildren() {
        
        let context = DIContext()
        let testObject = TestObjectAssembly.instance(from: context).testObject
        for child in testObject.childObjects {
            XCTAssert(testObject === child.parentObject)
        }
    }
}
