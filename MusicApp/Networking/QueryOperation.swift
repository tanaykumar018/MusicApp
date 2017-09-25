//
//  QueryOperation.swift
//  MusicApp
//
//  Created by Tanay Kumar on 9/24/17.
//  Copyright © 2017 Tanay Kumar. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]
typealias QueryResult = ([Track]?, String) -> ()

class QueryOperation: AsyncOperation {
    let defaultSession = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    private let url: URL
    private let completion: QueryResult?
    private var tracks: [Track] = []
    var errorMessage = ""
    
    init(url: URL, completion: @escaping QueryResult) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        task = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.task = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let completion = self.completion {
                self.updateSearchResults(data)
                completion(self.tracks, self.errorMessage)
                self.state = .finished
            }
        }
        task?.resume()
    }
    
    // MARK: - Helper method
    private func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        tracks.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options:[]) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
                let previewURLString = trackDictionary["previewUrl"] as? String,
                let previewURL = URL(string: previewURLString),
                let name = trackDictionary["trackName"] as? String,
                let artist = trackDictionary["artistName"] as? String {
                tracks.append(Track(name: name, artist: artist, previewURL: previewURL))
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
    
}


