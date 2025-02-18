//
//  RoadmapViewModel.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

final class RoadmapViewModel: ObservableObject {
    @Published private(set) var features: [RoadmapFeature] = []
    private let configuration: RoadmapConfiguration

    init(configuration: RoadmapConfiguration) {
        self.configuration = configuration
        loadFeatures(roadmapJSONURL: configuration.roadmapJSONURL)
    }

    func loadFeatures(roadmapJSONURL: URL) {
        Task { @MainActor in
            if configuration.shuffledOrder {
                self.features = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch().shuffled()
            } else {
                self.features = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch()
            }
        }
    }

    func featureViewModel(for feature: RoadmapFeature) -> RoadmapFeatureViewModel {
        .init(feature: feature, configuration: configuration)
    }
}
