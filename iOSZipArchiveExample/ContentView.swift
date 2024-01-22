//
//  ContentView.swift
//  iOSZipArchiveExample
//
//  Created by 영준 이 on 1/16/24.
//

import SwiftUI
import ZipArchive

struct ContentView: View {
    let manager = FileManager.default
    
    @State var isArchived = false
    @State var isProcessing = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button {
                isArchived ? unarchive() : archive()
            } label: {
                Text(isArchived ? "unzip" : "zip")
            }.disabled(isProcessing)
        }
        .padding()
    }
    
    func archive() {
        isProcessing = true
        
        defer {
            isProcessing = false
        }
        
        guard let documentUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        print("document", documentUrl.path())
        
        let zipFileUrl = documentUrl.appending(path: "test.zip")
        
        let zip = ZipArchive()

        print("creating zip", zipFileUrl.path())
        if zip.createZipFile2(zipFileUrl.path(), append: false) {
            print("create zip", zipFileUrl.path())
        }
        zip.compression = .best
        
        defer {
            zip.closeZipFile2()
        }
        
        guard let imageFile = Bundle.main.url(forResource: "icon", withExtension: "jpg") else {
            return
        }
        
        print("image", imageFile.path())
        
        let testDir = documentUrl.appending(path: "test")
        let clonedImageFile: URL = testDir.appending(path: imageFile.lastPathComponent)
        
        if !manager.fileExists(atPath: testDir.path(), isDirectory: nil) {
            try? manager.createDirectory(at: testDir, withIntermediateDirectories: true)
            print("create new dir", testDir.path())
        }
        
        if manager.fileExists(atPath: testDir.path(), isDirectory: nil) {
            try? manager.copyItem(at: imageFile, to: clonedImageFile)
            print("copy file to new path", clonedImageFile.path())
        }
        
        print("adding new file into zip", clonedImageFile.lastPathComponent)
        if (zip.addFile(toZip: clonedImageFile.path(), newname: clonedImageFile.lastPathComponent)) {
            print("new file is appended into zip", clonedImageFile.path())
        }
        
        try? manager.removeItem(at: testDir)
        
        isArchived = true
    }
    
    func unarchive() {
        isProcessing = true
        
        defer {
            isProcessing = false
        }
        
        guard let documentUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        print("document", documentUrl.path())
        
        let zipFileUrl = documentUrl.appending(path: "test.zip")
        
        let zip = ZipArchive()

        print("opening zip", zipFileUrl.path())
        if zip.unzipOpenFile(zipFileUrl.path()) {
            print("opened zip", zipFileUrl.path())
        }
        
        defer {
            zip.closeZipFile2()
        }
        
        let unzipDirUrl = zipFileUrl.deletingPathExtension()
        print("creating zip dir", unzipDirUrl.path())
        try? manager.createDirectory(at: unzipDirUrl, withIntermediateDirectories: true)
        print("created zip dir", unzipDirUrl.path())
        
        print("unzipping to dir", unzipDirUrl.path())
        if zip.unzipFile(to: unzipDirUrl.path(), overWrite: true) {
            print("unzipped zip", zipFileUrl)
        }
        
        try? manager.removeItem(at: zipFileUrl)
        
        isArchived = false
    }
}

#Preview {
    ContentView()
}
