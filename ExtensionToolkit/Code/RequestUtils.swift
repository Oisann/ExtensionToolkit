//
//  RequestUtils.swift
//  ExtensionToolkit
//
//  Created by Trainee on 13/03/2018.
//  Copyright © 2018 Trainee. All rights reserved.
//

import Foundation

public class RequestUtils {
    public static func download(_ url: URL, session: URLSession, completionHandler: @escaping(_ json: [String: Any]) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: url, completionHandler: { data, res, err in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else {
                print("nodata")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                completionHandler(json)
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }).resume()
    }
}
