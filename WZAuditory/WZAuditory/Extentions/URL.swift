//
//  URL.swift
//  Papr
//
//  Created by Joan Disho on 21.11.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

extension URL {
    
    ///查询这个URL中某个key对应的value
    func value(for queryKey: String) -> String? {
        let stringURL = self.absoluteString
        guard let items = URLComponents(string: stringURL)?.queryItems else { return nil }
        for item in items where item.name == queryKey {///这...sqlite的语法
            return item.value
        }
        return nil
    }

    //为这个url拼加自定义的字段  &key1=value1&key2=value2
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = urlComponents.queryItems ?? []

        queryItems += parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}
