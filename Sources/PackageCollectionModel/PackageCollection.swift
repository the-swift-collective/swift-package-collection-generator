//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Package Collection Generator open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift Package Collection Generator project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Package Collection Generator project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import PackageModel

public enum JSONPackageCollectionModel {}

extension JSONPackageCollectionModel {
    public enum V1 {}

    /// Representation of `PackageCollection` JSON schema version
    public enum FormatVersion: String, Codable {
        case v1_0 = "1.0"
    }
}

extension JSONPackageCollectionModel.V1 {
    public struct PackageCollection: Equatable, Codable {
        /// The name of the package collection, for display purposes only.
        public let title: String

        /// A description of the package collection.
        public let _description: String?

        /// An array of keywords that the collection is associated with.
        public let keywords: [String]?

        /// An array of package metadata objects
        public let packages: [Package]

        /// The version of the format to which the collection conforms.
        public let formatVersion: JSONPackageCollectionModel.FormatVersion

        /// The revision number of this package collection.
        public let revision: Int?

        /// The ISO 8601-formatted datetime string when the package collection was generated.
        public let generatedAt: Date

        /// The author of this package collection.
        public let generatedBy: Author?

        /// Creates a `PackageCollection`
        public init(
            title: String,
            description: String? = nil,
            keywords: [String]? = nil,
            packages: [Package],
            formatVersion: JSONPackageCollectionModel.FormatVersion,
            revision: Int? = nil,
            generatedAt: Date = Date(),
            generatedBy: Author? = nil
        ) {
            precondition(formatVersion == .v1_0, "Unsupported format version: \(formatVersion)")

            self.title = title
            self._description = description
            self.keywords = keywords
            self.packages = packages
            self.formatVersion = formatVersion
            self.revision = revision
            self.generatedAt = generatedAt
            self.generatedBy = generatedBy
        }

        private enum CodingKeys: String, CodingKey {
            case title
            case _description = "description"
            case keywords
            case packages
            case formatVersion
            case revision
            case generatedAt
            case generatedBy
        }

        public struct Author: Equatable, Codable {
            /// The author name.
            public let name: String

            /// Creates an `Author`
            public init(name: String) {
                self.name = name
            }
        }
    }
}

extension JSONPackageCollectionModel.V1.PackageCollection {
    public struct Package: Equatable, Codable {
        /// The URL of the package. Currently only Git repository URLs are supported.
        public let url: URL

        /// A description of the package.
        public let _description: String?

        /// An array of keywords that the package is associated with.
        public let keywords: [String]?

        /// An array of version objects representing the most recent and/or relevant releases of the package.
        public let versions: [Version]

        /// The URL of the package's README.
        public let readmeURL: URL?

        /// Creates a `Package`
        public init(
            url: URL,
            description: String? = nil,
            keywords: [String]? = nil,
            versions: [Version],
            readmeURL: URL? = nil
        ) {
            self.url = url
            self._description = description
            self.keywords = keywords
            self.versions = versions
            self.readmeURL = readmeURL
        }

        private enum CodingKeys: String, CodingKey {
            case url
            case _description = "description"
            case keywords
            case versions
            case readmeURL
        }
    }
}

extension JSONPackageCollectionModel.V1.PackageCollection.Package {
    public struct Version: Equatable, Codable {
        /// The semantic version string.
        public let version: String

        /// The name of the package.
        public let packageName: String

        /// An array of the package version's targets.
        public let targets: [Target]

        /// An array of the package version's products.
        public let products: [Product]

        /// The tools (semantic) version specified in `Package.swift`.
        public let toolsVersion: String

        /// An array of the package version’s supported platforms specified in `Package.swift`.
        public let minimumPlatformVersions: [PlatformVersion]?

        /// An array of platforms in which the package version has been tested and verified.
        public let verifiedPlatforms: [Platform]?

        /// An array of Swift versions that the package version has been tested and verified for.
        public let verifiedSwiftVersions: [String]?

        /// The package version's license.
        public let license: License?

        /// Creates a `Version`
        public init(
            version: String,
            packageName: String,
            targets: [Target],
            products: [Product],
            toolsVersion: String,
            minimumPlatformVersions: [PlatformVersion]? = nil,
            verifiedPlatforms: [Platform]? = nil,
            verifiedSwiftVersions: [String]? = nil,
            license: License? = nil
        ) {
            self.version = version
            self.packageName = packageName
            self.targets = targets
            self.products = products
            self.toolsVersion = toolsVersion
            self.minimumPlatformVersions = minimumPlatformVersions
            self.verifiedPlatforms = verifiedPlatforms
            self.verifiedSwiftVersions = verifiedSwiftVersions
            self.license = license
        }
    }

    public struct Target: Equatable, Codable {
        /// The target name.
        public let name: String

        /// The module name if this target can be imported as a module.
        public let moduleName: String?

        /// Creates a `Target`
        public init(name: String, moduleName: String? = nil) {
            self.name = name
            self.moduleName = moduleName
        }
    }

    public struct Product: Equatable, Codable {
        /// The product name.
        public let name: String

        /// The product type.
        public let type: ProductType

        /// An array of the product’s targets.
        public let targets: [String]

        /// Creates a `Product`
        public init(
            name: String,
            type: ProductType,
            targets: [String]
        ) {
            self.name = name
            self.type = type
            self.targets = targets
        }
    }

    public struct PlatformVersion: Equatable, Codable {
        /// The name of the platform (e.g., macOS, Linux, etc.).
        public let name: String

        /// The semantic version of the platform.
        public let version: String

        /// Creates a `PlatformVersion`
        public init(name: String, version: String) {
            self.name = name
            self.version = version
        }
    }

    public struct Platform: Equatable, Codable {
        /// The name of the platform (e.g., macOS, Linux, etc.).
        public let name: String

        /// Creates a `Platform`
        public init(name: String) {
            self.name = name
        }
    }

    public struct License: Equatable, Codable {
        /// License name (e.g., Apache-2.0, MIT, etc.)
        public let name: String

        /// The URL of the license file.
        public let url: URL

        /// Creates a `License`
        public init(name: String, url: URL) {
            self.name = name
            self.url = url
        }
    }
}