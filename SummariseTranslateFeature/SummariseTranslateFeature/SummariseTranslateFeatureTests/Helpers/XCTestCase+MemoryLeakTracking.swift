//
//  XCTestCase+MemoryLeakTracking.swift
//  SummariseTranslateFeatureTests
//
//  Created by Salvatore Milazzo on 07/02/24.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
