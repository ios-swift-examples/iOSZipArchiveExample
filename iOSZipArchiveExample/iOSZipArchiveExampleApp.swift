//
//  iOSZipArchiveExampleApp.swift
//  iOSZipArchiveExample
//
//  Created by 영준 이 on 1/16/24.
//

import SwiftUI

struct iOSZipArchiveExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Test")
        }
    }
}

@main
struct TestProxy {
    static func main() {
        guard let _ = NSClassFromString("XCTestCase") else {
            iOSZipArchiveExampleApp.main()
            return
        }
        
        TestApp.main()
    }
}
