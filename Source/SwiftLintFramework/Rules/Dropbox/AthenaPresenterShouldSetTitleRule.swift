import SourceKittenFramework


public struct AthenaPresenterShouldSetTitleRule: AnalyzerRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "athena_presenter_should_set_title",
        name: "AthenaPresenter Should Set Title",
        description: "The title should be set by the Presenter when possible.",
        kind: .idiomatic,
        nonTriggeringExamples: [

        ],
        triggeringExamples: [
            Example("class FooVC: AthenaViewController { \n  init() { \n self.title = \"Foo\" \n } \n }")
        ]
    )

    public func validate(file: SwiftLintFile, compilerArguments: [String]) -> [StyleViolation] {
        <#code#>
    }

    // Use file validator since we need `expressionKind == .call`
    public func validate(file: SwiftLintFile) -> [StyleViolation] {
        return file.structureDictionary.traverseDepthFirst { subDict in
            print(subDict.expressionKind ?? "Not expression kind")
            print(subDict.statementKind ?? "Not expression kind")
            guard let kind = subDict.expressionKind else { return nil }
            return violations(in: file, of: kind, dictionary: subDict)
        }
    }

    private func violations(in file: SwiftLintFile, of kind: SwiftExpressionKind,
                            dictionary: SourceKittenDictionary) -> [StyleViolation] {
        guard kind == .call else {
            return []
        }

        if dictionary.name?.contains("title") == true {
            print(dictionary)
        }

        // Check if calling init of un-themed cell that has a themed variant.
        guard let typeName = dictionary.name, let themedTypeName = SuggestThemedCellForCell[typeName] else {
            return []
        }

        let violation = violationFor(
            dictionary: dictionary,
            ruleDescription: Self.description,
            severity: configuration.severity,
            file: file
        )

        return [violation]
    }
}

