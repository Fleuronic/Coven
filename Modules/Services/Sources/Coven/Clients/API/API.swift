// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Catena
import Catenary
import Schemata
import PersistDB
import SociableWeaver

public struct API {
	let apiKey: String

	public init(apiKey: String) {
		self.apiKey = apiKey
	}
}

// MARK: -
extension API: GraphQLAPI {
	// MARK: GraphQLAPI
	public func queryString<Fields: Catena.Fields>(for query: GraphQL.Query<Fields>) -> String {
		/*ey):\(query.valueString))"
			body = "{\(fields)}"
		case let .mutation(mutation):
			let keys = keys(for: mutation, returning: Fields.self)
			let pairs = zip(keys, mutation.valueStrings).map { key, value in
				"\(key):\(value)"
			}
			arguments = "(\(pairs.joined(separator: ",")))"
			switch mutation {
			case .insert:
				body = "{\(fields)}"
			default:
				body = "{returning{\(fields)}}"
			}
		}*/

		let name = name(of: query)
		let fields = Fields
			.projection
			.keyPaths
			.map(Fields.Model.schema.properties)
			.map { $0.map(\.path) }


		switch query {
		case let .query(query):
			let base = Object(name) {
				ForEachWeavable(
					fields.map(\.objectWeavable)
				) { $0 }
			}
			let query = query
				.predicates
				.map(\.dictionary)
				.reduce(base) {
					$0.argument(
						key: "where",
						value: $1.named
					)
				}
			return Weave(.query) { query }.description
		case let .mutation(mutation):
			return ""
		}
	}

	// MARK: API
	public var baseURL: URL {
		URL(string: "https://coven-dev.hasura.app/v1/graphql")!
	}
}

// MARK: -
private extension API {
	func name<Fields: Catena.Fields>(of query: GraphQL.Query<Fields>) -> String {
		let tableName = Fields.Model.schema.name
		switch query {
		case .query:
			return tableName
		case let .mutation(mutation):
			let name = "\(mutation)_\(tableName)"
			switch mutation {
			case .insert:
				return "\(name)_one"
			case .delete, .update:
				return name
			}
		}
	}

	func keys<Fields: Catena.Fields>(for mutation: GraphQL.Query<Fields>.Mutation, returning fieldsType: Fields.Type) -> [String] {
		switch mutation {
		case .insert:
			return ["object"]
		case .update:
			return ["where", "_set"]
		case .delete:
			return ["where"]
		}
	}
}

// MARK: -
private extension String {
	var operatorName: String {
		switch self {
		case "==":
			return "_eq"
		default:
			return self
		}
	}
}

// MARK: -
private extension [String] {
	var objectWeavable: ObjectWeavable {
		let head = self[0]
		let tail = Array(self[1...])
		if count == 1 {
			return Field(head)
		} else {
			return Object(head) { tail.objectWeavable }
		}
	}
}

// MARK: -
private extension [String: Any] {
	var named: Self {
		.init(
			uniqueKeysWithValues: map { key, value in
				(key.operatorName, (value as? [String: Any])?.named ?? value)
			}
		)
	}
}

