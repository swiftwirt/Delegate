//
//  Logger.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation
import GZIP

let log = XCGLogger.defaultInstance()

// Just a static class to manage our logging mechanism.
class Logger {
    
    static let maxLogFilesToKeep = 20
    static var docsFolderCached : String!
    static var presentLogFile = String()
    
    static func docsFolder() -> String {
        if (docsFolderCached == nil) {
            docsFolderCached = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        }
        return docsFolderCached
    }
    
    static func logsFolder() -> String {
        return docsFolder() + "/" + "logs"
    }
    
    static fileprivate func initLogFolder() -> Bool {
        let fileManager = FileManager.default
        var folderPresent = true;
        if !fileManager.fileExists(atPath: logsFolder()) {
            folderPresent = (try? fileManager.createDirectory(atPath: logsFolder(), withIntermediateDirectories: true, attributes: nil)) != nil
        }
        
        if (folderPresent)
        {
            // Compress non-compressed log files
            var logFiles = (try? fileManager.contentsOfDirectory(atPath: logsFolder())) ?? []
            logFiles = logFiles.filter { $0.hasSuffix(".log") }
            
            // Compress the log files, delete the original
            for file in logFiles {
                let path = logsFolder() + "/" + file
                let dataW = try? Data(contentsOf: URL(fileURLWithPath: path))
                if let data = dataW {
                    try? (data as NSData).gzipped()?.write(to: URL(fileURLWithPath: path + ".gz"), options: [.atomic])
                }
                _ = try? fileManager.removeItem(atPath: path)
            }
            
            // CleanUp the compressed log files - leave only maxLogFilesToKeep number of latest
            logFiles = (try? fileManager.contentsOfDirectory(atPath: logsFolder())) ?? []
            logFiles = logFiles.filter { $0.hasSuffix(".log.gz") }
            // Sort more recent first
            logFiles.sort { $0 > $1 } // works, since the filenames are just dates!
            
            if maxLogFilesToKeep < logFiles.count {
                for i in maxLogFilesToKeep ..< logFiles.count {
                    let path = logsFolder() + "/" + logFiles[i]
                    _ = try? fileManager.removeItem(atPath: path)
                }
            }
        }
        
        return folderPresent
    }
    
    static func collectLogFiles() -> Data {
        let fileManager = FileManager.default
        
        // Build up the logs package here
        let joinedData = NSMutableData()
        joinedData.append("FITLOGPACK".data(using: String.Encoding.utf8)!)
        
        // Compress non-compressed log files
        var logFiles = (try? fileManager.contentsOfDirectory(atPath: logsFolder())) ?? []
        logFiles = logFiles.filter { $0.hasSuffix(".gz") }
        logFiles.sort { $0 > $1 }
        
        func nextFileHeader(_ fileName: String) -> Data
        {
            return "\n-=-=**\(fileName)**=-=-\n".data(using: String.Encoding.utf8)!
        }
        
        for file in logFiles {
            joinedData.append(nextFileHeader(file))
            let path = logsFolder() + "/" + file
            joinedData.append((try? Data(contentsOf: URL(fileURLWithPath: path))) ?? Data())
        }
        
        // Append the present log file:
        joinedData.append(nextFileHeader(presentLogFile.replacingOccurrences(of: ".log", with: ".current.log") + ".gz"))
        var path = logsFolder() + "/" + presentLogFile
        var dataW = try? Data(contentsOf: URL(fileURLWithPath: path))
        if let data = dataW {
            joinedData.append((data as NSData).gzipped() ?? Data())
        }
        
        // Append the APICache DB
        path = UserService.dataFilePath
        joinedData.append(nextFileHeader(NSString(string: path).lastPathComponent + ".gz"))
        dataW = try? Data(contentsOf: URL(fileURLWithPath: path))
        if let data = dataW {
            joinedData.append((data as NSData).gzipped() ?? Data())
        }
        
        // Scamble with XOR and a simple key
        let k : [UInt8] = [066,049,098,061,181,244,179,199,210,006,047,218,178,033,028,133,178,220,115,134,216,173,121,155,048,050,253,157,113,007,096,220,069,053,239,244,034,144,042,099,197,041,078,193,222,028,187,227,245,143,039,238,195,001,254,214,241,097,184,128,146,050,067,178,166,199,174,190,051,114,193,130,006,087,242,100,218,211,182,225,074,097,102,064,136,111,134,034,238];
        let unsafeMutablePtr = UnsafeMutablePointer(joinedData.mutableBytes.assumingMemoryBound(to: UInt8.self))
        let b = UnsafeMutableBufferPointer<UInt8>(start: unsafeMutablePtr, count: joinedData.length)
        for i in 0..<joinedData.length {
            b[i] ^= k[i % k.count]
        }
        
        // Return joined and scrambled data
        return (NSData(data: joinedData as Data) as Data)
    }
    
    static func logSomeBasics () {
        let device = UIDevice.current
        log.info("Running on '\(device.name)' which is an '\(LoggerObjCHelper.deviceCode())' running '\(device.systemName) \(device.systemVersion)'")
        #if INTERNAL_BUILD
            log.info("INTERNAL BUILD")
        #else
            log.info("APP STORE BUILD")
        #endif
        let locale = Locale.current
        log.info("Device locale localeIdentifier: \(locale.identifier)")
        log.info("Device locale pref.langs: \(Locale.preferredLanguages)")
        log.info("UTC date is: \(Date())")
    }
    
    static func setUpLogging() {
        if !initLogFolder() {
            return;
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd__HH.mm.ss"
        presentLogFile = dateFormatter.string(from: Date()) + ".log"
        let logFileLocation = logsFolder() + "/" + presentLogFile
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        log.dateFormatter = dateFormatter
        log.setup(.info, showLogIdentifier: false, showFunctionName: false, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: logFileLocation as AnyObject?, fileLogLevel: .debug)
        
        // Initial logs that tell us more about the system we're running on.
        logSomeBasics()
    }
}
