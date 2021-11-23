//
//  ListViewModelTests.swift
//  MarvelTests
//
//  Created by Srikanth Adavalli on 11/22/21.
//

import Foundation
import XCTest
@testable import Marvel

class ListViewModelTests: XCTestCase {
    var viewModel: ListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MockListViewModel()
    }
    
    func testGetResults() {
        let expectation = self.expectation(description: "ListViewModel")
        var results: [Results] = []
        
        viewModel.getResults(offset: 100) {
            results = $0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        XCTAssertEqual(results.first?.id, 100)
        XCTAssertEqual(results.first?.name, "Marvel")
        XCTAssertEqual(results.first?.thumbnail.path, "www.google")
        XCTAssertEqual(results.first?.thumbnail.thumbnailExtension, "com")
        XCTAssertEqual(results.first?.urls.first?.type, "Google")
        XCTAssertEqual(results.first?.urls.first?.url, "www.google.com")
    }
    
    func testGetImages() {
        let expectation = self.expectation(description: "ListViewModel")
        var actualImage: UIImage?
        
        guard let result = (viewModel as! MockListViewModel).results().first else {
            XCTFail("failed to fetch `results`")
            return
        }
        
        viewModel.getImages(result: result) { image in
            actualImage = image
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssertEqual(actualImage, UIImage(named: "notAvailable"))
    }
}
