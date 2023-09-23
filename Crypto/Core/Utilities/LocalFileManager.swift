//
//  LocalFileManager.swift
//  Crypto
//
//  Created by Surya on 18/09/23.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let shared = LocalFileManager()
    private init() {}
    
    func saveImage(image: UIImage,
                   imageName: String,
                   folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        do {
            try data.write(to: url)
        } catch {
            print("Error in saving image: \(url) with error: \(error)")
        }
    }
    
    
    func getImage(imageName: String,
                  folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print("Error in creating folder : \(folderName) with error: \(error)")
            }
        }
    }
    
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil }
        return url.appendingPathComponent(folderName)
    }

    private func getURLForImage(imageName: String,
                                folderName: String) -> URL? {
         getURLForFolder(folderName: folderName)?
            .appendingPathComponent(imageName)
    }
    
}
