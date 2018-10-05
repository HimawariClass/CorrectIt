//
//  FileMagate.swift
//  CorrectIt
//
//  Created by Taillook on 2018/07/13.
//  Copyright © 2018年 HimawariClass. All rights reserved.
//

import Foundation

struct FileManage {
    let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    func getFiles(path: String) -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path).filter { $0.range(of: ".png") != nil || $0.range(of: ".jpg") != nil }.sorted { $0 < $1 }
        } catch {
            return []
        }
    }
    
    func getFolders(path: String) -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path).filter { $0.range(of: ".") == nil }
        } catch {
            return []
        }
    }
}
