//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

protocol WebApiRequest {
    
    associatedtype Response: Codable
    
    var urlString: String { get }
    var method: WebApiRequestMethod { get }
    var parameters: [String : Any]? { get }
    
    func parse(_ data: Data) throws -> Response?
}
