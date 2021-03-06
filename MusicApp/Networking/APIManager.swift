//
//  APIManager.swift
//  MusicApp
//
//  Created by Tanay Kumar on 9/24/17.
//  Copyright © 2017 Tanay Kumar. All rights reserved.
//

import Foundation

class APIManager {
    
    private let queue = OperationQueue()
    var downloadsSession: URLSession!
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        queue.cancelAllOperations()
        // create QueryOperation
        if var url = URLComponents(string: "https://itunes.apple.com/search") {
            url.query = "media=music&entity=song&term=\(searchTerm)"
            let op = QueryOperation(url: url.url!) { tracks, error in
                DispatchQueue.main.async {
                    completion(tracks, error)
                }
            }
            queue.addOperation(op)
        }
    }
    
    var tracks: [Track] = []
    var activeDownloads: [URL: Download] = [:]
    var errorMessage = ""
    
    // MARK: - Download methods called by TrackCell delegate methods
    
    // Called when the Download button for a track is tapped
    func startDownload(_ track: Track) {
        let download = Download(url: track.previewURL)
        download.task = downloadsSession.downloadTask(with: track.previewURL)
        download.task!.resume()
        download.isDownloading = true
        activeDownloads[download.url] = download
    }
    
    // Called when the Pause button for a track is tapped
    func pauseDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        if download.isDownloading {
            download.task?.cancel(byProducingResumeData: { data in
                download.resumeData = data
            })
            download.isDownloading = false
        }
    }
    
    // Called when the Cancel button for a track is tapped
    func cancelDownload(_ track: Track) {
        if let download = activeDownloads[track.previewURL] {
            download.task?.cancel()
            activeDownloads[track.previewURL] = nil
        }
    }
    
    // Called when the Resume button for a track is tapped
    func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
            download.task!.resume()
            download.isDownloading = true
        } else {
            download.task = downloadsSession.downloadTask(with: download.url)
            download.task!.resume()
            download.isDownloading = true
        }
    }
    
    // MARK: - Helper methods
    // This method generates a permanent local file path to save a track to by appending
    // the lastPathComponent of the URL (i.e. the file name and extension of the file)
    // to the path of the app’s Documents directory.
    func localFilePath(for url: URL) -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    // This method checks if the local file exists at the path generated by localFilePath(_:)
    func localFileExists(for track: Track) -> Bool {
        let localUrl = localFilePath(for: track.previewURL)
        var isDir: ObjCBool = false
        return FileManager.default.fileExists(atPath: localUrl.path, isDirectory: &isDir)
    }
    
}

