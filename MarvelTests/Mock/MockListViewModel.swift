//
//  MockListViewModel.swift
//  MarvelTests
//
//  Created by Srikanth Adavalli on 11/22/21.
//

import XCTest
@testable import Marvel

class MockListViewModel: ListViewModel {
    func getResults(offset: Int, _ closure: @escaping ([Results]) -> Void) {
        closure(results())
    }
    
    func getImages(result: Results, closure: @escaping (UIImage?) -> ()) {
        closure(UIImage(named: "notAvailable"))
    }
    
    func results() -> [Results] {
        return [
            Results(
                id: 100,
                name: "Marvel",
                thumbnail: Thumbnail(path: "www.google", thumbnailExtension: "com"),
                urls: [URLElement(type: "Google", url: "www.google.com")]
            )
        ]
    }
}
