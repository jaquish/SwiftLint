import SourceKittenFramework

/*
public struct BlankRule: ASTRule, OptInRule,
    ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "rx_immutable_interface",
        name: "Rx Immutable Interface",
        description: "Nonprivate Observables should be immutable " +
            "to prevent unintended state changes from external components.",
        kind: .idiomatic,
        nonTriggeringExamples: [
            Example("class Foo {\n  private var foo: BehaviorSubject<Int>\n }\n")
        ],
        triggeringExamples: [
            Example("class Foo {\n  var foo: BehaviorSubject<Int>\n }\n")
        ]
    )

    public func validate(file: SwiftLintFile, kind: SwiftDeclarationKind,
                         dictionary: SourceKittenDictionary) -> [StyleViolation] {
        guard kind == .varInstance else {
            return []
        }

        let violation = violationFor(
            dictionary: dictionary,
            ruleDescription: type(of: self).description,
            severity: configuration.severity,
            file: file
        )

        return [violation]
    }
}
 */
