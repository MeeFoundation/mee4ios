//
//  clientTests.swift.swift
//  mee-ios-clientTests
//
//  Created by Anthony Ivanov on 21.11.23..
//

import XCTest
@testable import mee_ios_client

class NavigationViewModelTests: XCTestCase {
   
    var core: MeeAgentStore!
    var navigationViewModel: NavigationViewModel!
    var appState: AppState!
    var consentState: ConsentState!
    var launchedBefore: Bool!
    var hadConnectionsBefore: Bool!
    var navigationState: NavigationState!
    
    override func setUp() async throws {
        core = MeeAgentStore()
        try await core.removeAllData()
        navigationViewModel = await NavigationViewModel()
        appState = AppState()
        consentState = ConsentState()
        launchedBefore = true
        hadConnectionsBefore = true
        navigationState = NavigationState()
        await navigationViewModel.setup(appState: appState, core: core, consentState: consentState, launchedBefore: launchedBefore, hadConnectionsBefore: hadConnectionsBefore, navigationState: navigationState)
    }
    
    override func tearDown() async throws {
        try await core.removeAllData()
        core = nil
        navigationViewModel = nil
        appState = nil
        consentState = nil
        launchedBefore = nil
        hadConnectionsBefore = nil
        navigationState = nil
    }
    
    func testCoreHasZeroConnectors() async {
        let connectors = await core.getAllConnectors()
        XCTAssertEqual(connectors.count, 0)
    }
    
    @MainActor func testProcessValidSiopUrl() async {
        
        await navigationViewModel.processUrl(url: meeSiopUrl)
        
        XCTAssertEqual(navigationViewModel.navigationState?.currentPage, .consent, "Valid siop url should redirect app to the consent screen.")
        XCTAssertEqual(navigationViewModel.data?.consent.clientId.isEmpty, false, "Consent should not be empty.")
        XCTAssertNotEqual(navigationViewModel.appState?.toast?.type, .error, "Valid url should not display an error toast message.")
    }
    
    @MainActor func testProcessNonValidUrl() async {
        await navigationViewModel.processUrl(url: nonValidUrl)
        
        XCTAssertEqual(navigationState.currentPage, .mainPage, "Non valid url should not get us out of the current screen.")
        XCTAssertEqual(consentState.consent.clientId.isEmpty, true, "Non valid url consent data should be empty.")
        XCTAssertEqual(appState.toast?.type, .error, "Non valid url should display an error toast message.")
    }
    
    @MainActor func testProcessNonValidRequest() async {
        await navigationViewModel.processUrl(url: nonValidRequest)
        
        XCTAssertEqual(navigationViewModel.navigationState?.currentPage, .mainPage, "Non valid url should not get us out of the current screen.")
        XCTAssertEqual(navigationViewModel.data?.consent.clientId.isEmpty, true, "Non valid url consent data should be empty.")
        XCTAssertEqual(navigationViewModel.appState?.toast?.type, .error, "Non valid url should display an error toast message.")
    }
    
}
