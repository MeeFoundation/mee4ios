//
//  clientTests.swift.swift
//  mee-ios-clientTests
//
//  Created by Anthony Ivanov on 21.11.23..
//

import XCTest
@testable import mee_ios_client

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func DISABLED_testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func DISABLED_testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func setupCore() async -> MeeAgentStore {
        let core = MeeAgentStore()
        try? await core.removeAllData()
        return core
    }
    
    func testCoreHasZeroConnectors() async {
        let core = await setupCore()
        let connectors = await core.getAllConnectors()
        XCTAssertTrue(connectors.count == 0)
    }
    
    func setupNavigationViewModel() async -> NavigationViewModel {
        let core = await setupCore()
        
        let navigationViewModel = await NavigationViewModel()
        let appState = AppState()
        let consentState = ConsentState()
        let launchedBefore = true
        let hadConnectionsBefore = true
        let navigationState = NavigationState()
        await navigationViewModel.setup(appState: appState, core: core, consentState: consentState, launchedBefore: launchedBefore, hadConnectionsBefore: hadConnectionsBefore, navigationState: navigationState)
        return navigationViewModel
    }
    
    @MainActor func testAddOneSiopConnector() async {
        let navigationViewModel = await setupNavigationViewModel()
        await navigationViewModel.processUrl(url: meeSiopUrl)
        XCTAssertTrue(navigationViewModel.navigationState?.currentPage == .consent)
        XCTAssertEqual(navigationViewModel.data?.consent.clientId.isEmpty, false)
        XCTAssertEqual(navigationViewModel.hadConnectionsBefore, true)
    }
    
    @MainActor func testProcessNonValidUrl() async {
        let navigationViewModel = await setupNavigationViewModel()
        await navigationViewModel.processUrl(url: nonValidUrl)
        XCTAssertTrue(navigationViewModel.navigationState?.currentPage == .mainPage)
        XCTAssertEqual(navigationViewModel.data?.consent.clientId.isEmpty, true)
        XCTAssertTrue(navigationViewModel.appState?.toast?.type == .error)
    }
    
    @MainActor func testProcessNonValidRequest() async {
        let navigationViewModel = await setupNavigationViewModel()
        await navigationViewModel.processUrl(url: nonValidRequest)
        XCTAssertTrue(navigationViewModel.navigationState?.currentPage == .mainPage)
        XCTAssertEqual(navigationViewModel.data?.consent.clientId.isEmpty, true)
        XCTAssertTrue(navigationViewModel.appState?.toast?.type == .error)
    }
}
