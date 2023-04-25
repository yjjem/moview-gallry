//
//  MovieService.swift
//  remy-movie
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class MovieService: MovieServiceInterface {
    
    private var tasks: [URLSessionTask] = []
    private let manager: Networkable
    
    init(manger: Networkable) {
        self.manager = manger
    }
    
    deinit {
        tasks.forEach {
            $0.cancel()
        }
    }
    
    // MARK: Function(s)
    
    func loadMovieList(
        page: Int,
        of category: ListCategory,
        completion: @escaping (Result<[Movie]?, NetworkError>) -> Void
    ) {
        
        let endPoint = makeEndPoint(path: .movieList(category), queryItems: [.page: String(page)])
        
        let task = manager.load(url: endPoint.url, method: .get) { [weak self] response in
            guard let self = self else { return }
            let decodeResult = self.tryDecodeAndValidate(response: response, as: MovieList.self)
            completion(decodeResult.map { $0.asMovieList() })
        }
        
        if let task {
            tasks.append(task)
        }
    }
    
    func loadVideoList(
        movieId: Int,
        completion: @escaping (Result<[Video]?, NetworkError>) -> Void
    ) {
        
        let endPoint = makeEndPoint(path: .videoList(movieId), queryItems: nil)
        
        let task = manager.load(url: endPoint.url, method: .get) { [weak self] response in
            guard let self = self else { return }
            let decodeResult = self.tryDecodeAndValidate(response: response, as: VideoList.self)
            completion(decodeResult.map { $0.asVideList() })
        }
        
        if let task {
            tasks.append(task)
        }
    }
    
    
    // MARK: Private Function(s)
    
    private func makeEndPoint(path: Path, queryItems: [EndPoint.QueryKey: String]?) -> EndPoint {
        
        var queries = queryItems ?? [:]
        queries[.apiKey] = MainBundle.apiKey
        
        return EndPoint(
            host: TmdbAPIDetails.defaultHost,
            path: path.fullPath,
            queryItems: queries
        )
    }
    
    private func tryDecodeAndValidate<T: Decodable>(
        response: Result<Data, NetworkError>,
        as type: T.Type
    ) -> Result<T, NetworkError> {
        
        switch response {
        case .success(let data):
            return data.tryDecode(as: type)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension MovieService {
    enum Path {
        case movieList(ListCategory)
        case videoList(Int)
        
        var fullPath: String {
            let mainPath = TmdbAPIDetails.defaultPath
            
            switch self {
            case .movieList(let category): return mainPath + category.path
            case .videoList(let id): return mainPath + "/\(id)/videos"
            }
        }
    }
}
