import SourceKittenFramework

public struct RxPreferRestrictiveTypeRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static var description: RuleDescription { ruleDescription() }

    private static func ruleDescription(
        replace typeName: String? = nil,
        with suggestionList: String? = nil
    ) -> RuleDescription {
        let baseDescription = "Observables should be as restrictive as possible."
        let descriptionText: String
        if let typeName = typeName, let suggestionList = suggestionList {
            descriptionText = "Can you use \(suggestionList) instead of \(typeName)? " + baseDescription
        } else {
            descriptionText = baseDescription
        }

        return RuleDescription(
            identifier: "rx_prefer_restrictive_type",
            name: "Rx Prefer Restrictive Type",
            description: descriptionText,
            kind: .idiomatic,
            nonTriggeringExamples: [
                Example("class Foo {\n  private let foo: BehaviorSubject<Int>\n }\n")
            ],
            triggeringExamples: [
                Example("class Foo {\n  private let foo: BehaviorRelay<Int>\n }\n")
            ]
        )
    }

    public func validate(file: SwiftLintFile, kind: SwiftDeclarationKind,
                         dictionary: SourceKittenDictionary) -> [StyleViolation] {
        guard
            kind == .varInstance,
            let simpleName = mapToSimpleObservableName(dictionary),
            let suggestionList = SuggestRestrictiveTypeForObservable[simpleName]
        else {
            return []
        }

        let violation = violationFor(
            dictionary: dictionary,
            ruleDescription: type(of: self).ruleDescription(replace: simpleName, with: suggestionList),
            severity: configuration.severity,
            file: file
        )

        return [violation]
    }
}
