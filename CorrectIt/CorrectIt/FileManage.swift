//
//  FileManage.swift
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
            return try FileManager.default.contentsOfDirectory(atPath: path).filter { $0.range(of: ".png") != nil || $0.range(of: ".jpg") != nil || $0.range(of: ".jpeg") != nil }.sorted { $0 < $1 }
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
    
    func createDirectory(basePath: String, dir: String) {
        let documentsPath = URL(fileURLWithPath: basePath)
        let path = documentsPath.appendingPathComponent(dir)
        do
        {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
    }
    
    func saveImage(path: String, image: UIImage) {
        let pngImageData = image.pngData()

        do {
            try pngImageData?.write(to: URL(fileURLWithPath: path), options: .atomic)
        }
        catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
