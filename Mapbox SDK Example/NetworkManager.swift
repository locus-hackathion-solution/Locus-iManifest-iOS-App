//
//  NetworkManager.swift
//  Mapbox SDK Example
//
//  Created by Pankaj Kulkarni on 04/08/19.
//  Copyright © 2019 iManifest. All rights reserved.
//

import Foundation

struct NetworkManager {



    @discardableResult static private func taskForGETRequest<ResponseType: Decodable>(url: URL,
                                                                              responseType: ResponseType.Type,
                                                                              completionHandler: @escaping (ResponseType?, Error?) -> Void) ->
        URLSessionTask {

            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                handleTaskResponse(data: data, response: response, error: error, completionHandler: completionHandler)

            }
            task.resume()
            return task
    }

    static private func handleTaskResponse<ResponseType: Decodable> (data: Data?,
                                                             response: URLResponse?,
                                                             error: Error?,
                                                             completionHandler: @escaping (ResponseType?, Error?) -> Void) {

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            #warning("PK: Something horribly went wrong and haven't received the reply!")
            fatalError("Something horribly went wrong and haven't received the reply!")
        }

        print("HTTP Status Code: \(statusCode)")

        guard let data = data else {
            DispatchQueue.main.async {
                completionHandler(nil, error)
            }
            return
        }

        printReceivedJSON(data: data)

        if statusCode == 200 {
            // Recieved OK response
            let decoder = JSONDecoder()
            do {
                let responseData = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseData, nil)
                }

            } catch {
                print("Error decoding JSON data (status: OK(200). \(error)")
                // Error decoding response
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }

        } else {

            completionHandler(nil, error)
        }
    }

    static private func printReceivedJSON(data: Data) {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            print("Recieved JSON data is: \(jsonData)")
        } catch {
            print("printReceivedJSON: Error decoding data. Error: \(error)")
        }
    }

    static func getRoute(completion: @escaping (Routes?, Error?) -> Void) {
        let url = URL(string: "http://167.71.110.120/routes")!
        taskForGETRequest(url: url, responseType: Routes.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }

    }

}
