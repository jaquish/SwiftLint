import SourceKittenFramework

public struct AthenaPreferThemedCellsRule: OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static var description: RuleDescription { ruleDescription() }

    private static func ruleDescription(
        replace typeName: String? = nil,
        with themedTypeName: String? = nil
    ) -> RuleDescription {
        let baseDescription = "Use Themed variants of cells to handle ThemeTrait changes."
        let descriptionText: String
        if let typeName = typeName, let themedTypeName = themedTypeName {
            descriptionText = "Use \(themedTypeName) instead of \(typeName)." + baseDescription
        } else {
            descriptionText = baseDescription
        }

        return RuleDescription(
            identifier: "athena_use_themed_cells",
            name: "Athena Use Themed Cells",
            description: descriptionText,
            kind: .idiomatic,
            nonTriggeringExamples: [
                Example("func sections() {\n let cell0 = ButtonImageThemedCellModel() }\n")
            ],
            triggeringExamples: [
                Example("func sections() {\n let cell0 = ButtonImageCellModel() }\n")
            ]
        )
    }

    // Use file validator since we need `expressionKind == .call`
    public func validate(file: SwiftLintFile) -> [StyleViolation] {
        return file.structureDictionary.traverseDepthFirst { subDict in
            guard let kind = subDict.expressionKind else { return nil }
            return violations(in: file, of: kind, dictionary: subDict)
        }
    }

    private func violations(in file: SwiftLintFile, of kind: SwiftExpressionKind,
                            dictionary: SourceKittenDictionary) -> [StyleViolation] {
        guard kind == .call else {
            return []
        }

        // Check if calling init of un-themed cell that has a themed variant.
        guard let typeName = dictionary.name, let themedTypeName = SuggestThemedCellForCell[typeName] else {
            return []
        }

        let violation = violationFor(
            dictionary: dictionary,
            ruleDescription: Self.ruleDescription(replace: typeName, with: themedTypeName),
            severity: configuration.severity,
            file: file
        )

        return [violation]
    }
}
