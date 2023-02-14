//
//  DataManager.swift
//  SimpleText
//
//  Created by Max094_Reikeb on 08/10/2022.
//

import Foundation
import SwiftUI

class DataManager: ObservableObject {

    @Published var data: [Data] = []

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("data.data")
    }

    static func load(completion: @escaping (Result<[Data], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let yourData =  try JSONDecoder().decode([Data].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(yourData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(datas: [Data], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(datas)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(datas.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    var savedText: String {
        set {
            let newDatas = Data(savedText: newValue)
            if !data.isEmpty { data.removeFirst() }
            data.append(newDatas)
            DataManager.save(datas: data) { result in
                if case .failure(let failure) = result {
                    fatalError(failure.localizedDescription)
                }
            }
        }
        get { data.first?.savedText ?? "" }
    }
}
