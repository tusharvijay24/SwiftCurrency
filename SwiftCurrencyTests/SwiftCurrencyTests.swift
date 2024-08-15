//
//  SwiftCurrencyTests.swift
//  SwiftCurrencyTests
//
//  Created by Tushar on 15/08/24.
//

import XCTest
@testable import SwiftCurrency

final class SwiftCurrencyTests: XCTestCase {
    
    var viewModel: CurrencyViewModel!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var mockWebServiceHelper: MockWebServiceHelper!
    
    override func setUpWithError() throws {
        mockUserDefaultsManager = MockUserDefaultsManager()
        mockWebServiceHelper = MockWebServiceHelper()
        viewModel = CurrencyViewModel(userDefaultsManager: mockUserDefaultsManager, webServiceHelper: mockWebServiceHelper)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockUserDefaultsManager = nil
        mockWebServiceHelper = nil
    }
    
    func testFetchInitialData_WhenDataIsAvailable_ShouldUseLocalData() throws {
        mockUserDefaultsManager.shouldRefreshDataResult = false
        mockUserDefaultsManager.loadExchangeRatesResult = ["USD": 1.0, "EUR": 0.85]
        
        viewModel.fetchInitialData()
        
        XCTAssertEqual(viewModel.exchangeRates.count, 2)
        XCTAssertEqual(viewModel.exchangeRates["USD"], 1.0)
        XCTAssertEqual(viewModel.exchangeRates["EUR"], 0.85)
    }
    
    
    func testConvertCurrency_ShouldUpdateConvertedAmounts() throws {
        viewModel.exchangeRates = ["USD": 1.0, "EUR": 0.85]
        viewModel.selectedCurrency = "USD"
        viewModel.convertCurrency(amount: 100.0)
        XCTAssertEqual(viewModel.convertedAmounts["EUR"], 85.0)
    }
    
    func testClearData_ShouldResetUIAndClearExchangeRates() throws {
        mockUserDefaultsManager.shouldRefreshDataResult = true
        mockUserDefaultsManager.loadExchangeRatesResult = ["USD": 1.0, "EUR": 0.85]
        let expectation = self.expectation(description: "Data Cleared")
        viewModel.onDataCleared = {
            expectation.fulfill()
        }
        viewModel.fetchInitialData()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(viewModel.exchangeRates.isEmpty)
        XCTAssertTrue(viewModel.availableCurrencies.isEmpty)
        XCTAssertTrue(viewModel.convertedAmounts.isEmpty)
        XCTAssertNil(viewModel.selectedCurrency)
    }
    
    func testFetchInitialData_WhenAPIFetchFails_ShouldHandleError() throws {
        mockUserDefaultsManager.shouldRefreshDataResult = true
        mockWebServiceHelper.shouldReturnError = true
        
        let expectation = self.expectation(description: "Fetch data from API with error")
        
        viewModel.onError = { error in
            XCTAssertEqual(error.localizedDescription, "TestError")
            expectation.fulfill()
        }
        
        viewModel.fetchInitialData()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.exchangeRates.count, 0)
    }
}
