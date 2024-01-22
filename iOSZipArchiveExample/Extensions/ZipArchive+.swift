//
//  ZipArchive.swift
//  ShowNote
//
//  Created by 영준 이 on 2015. 12. 3..
//  Copyright © 2015년 leesam. All rights reserved.
//

import UIKit
import ZipArchive

extension ZipArchive{
    //    func addDirToZip(file: String!, newname: String! = nil) -> Bool{
    //    }
    func addDirToZip(_ dir: URL, newPath: URL? = nil, progressHandler: ((Int, Int, String) -> Void)? = nil) -> Bool{
        var value = false;
        var newPath = newPath;
        //var dirUrl = NSURL(string: file);
        
        guard progressHandler == nil else{
            let zipList = self.listToZip(dir, newPath: newPath);
            
            var i = 1, cnt = zipList.count;
            for zmap in zipList{
                autoreleasepool{
                    self.addFile(toZip: zmap.filePath, newname: zmap.zipPath);
                    progressHandler!(i, cnt, zmap.zipPath);
                    i += 1;
                }
            }
            
            value = true;
            return value;
        }
        
        if newPath == nil{
            newPath = URL(string: "./", relativeTo: dir);
        }
        //var newUrl = NSURL(string: newname);
        
        do{
            let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: []);
            
            for file in files{
//                var last = file.lastPathComponent;
                let subPath = newPath!.appendingPathComponent(file.lastPathComponent);
                
                if file.isDirectory(){
                    self.addDirToZip(file, newPath: subPath);
                }
                else{
//                    var path = subPath.path;
                    self.addFile(toZip: file.path, newname: subPath.relativePath);
                    print("Compress path[%@] -> [%@]", file.path, subPath.relativePath);
                }
            }
            value = true;
        }catch{
        }
        //self.addFileToZip(<#T##file: String!##String!#>, newname: <#T##String!#>)
        return value;
    }
    
    func listToZip(_ dir: URL, newPath: URL? = nil) -> [(filePath: String, zipPath: String)]{
        var values : [(filePath: String, zipPath: String)] = [];
        var newPath = newPath;
        
        if newPath == nil{
            newPath = URL(string: "./", relativeTo: dir);
        }
        //var newUrl = NSURL(string: newname);
        
        do{
            let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: []);
            
            for file in files{
//                var last = file.lastPathComponent;
                let subPath = newPath!.appendingPathComponent(file.lastPathComponent);
                
                if file.isDirectory(){
                    values.append(contentsOf: self.listToZip(file, newPath: subPath));
                }
                else{
//                    var path = subPath.path;
                    //self.addFileToZip(file.path, newname: subPath.relativePath);
                    values.append((filePath: file.path, zipPath: subPath.relativePath));
                    print("Compress path[%@] -> [%@]", file.path, subPath.relativePath);
                }
            }
        }catch{
            
        }
        
        return values;
    }
    
    func UnzipOpenFileCheckPassword(_ zipFile: String, password: String) -> Bool{
        var value = false;

        guard self.unzipOpenFile(zipFile, password: password) else {
            return value;
        }
        
        value = !self.getZipFileContents().isEmpty;
        
        return value;
    }
}
