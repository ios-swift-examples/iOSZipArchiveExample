//
//  URL+.swift
//  iOSZipArchiveExample
//
//  Created by 영준 이 on 1/19/24.
//

import Foundation

extension URL{
    func isDirectory() -> Bool{
        var is_dir : ObjCBool = ObjCBool.init(false);
        FileManager.default.fileExists(atPath: self.path, isDirectory: &is_dir);
        
        return is_dir.boolValue;
    }
}
