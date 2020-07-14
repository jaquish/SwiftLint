import SourceKittenFramework

public struct RxPrivateSubjectRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "rx_private_subject",
        name: "Rx Private Subjects",
        description: "Subjects/Relays should be private to prevent unintended state changes from external components.",
        kind: .idiomatic,
        nonTriggeringExamples: [
            Example("class Foo {\n  private var foo: BehaviorSubject<Int>\n private let foo2: BehaviorSubject<Int>\n }\n"),
            Example("class Foo {\n  fileprivate bar: PublishRelay<Int>\n }\n"),
            Example("class Foo {\n  private var baz: ReplayRelay<Int>\n }\n")
        ],
        triggeringExamples: [
            Example("class Foo {\n  var foo: BehaviorSubject<Int>\n }\n"),
            Example("class Foo {\n  let bar: PublishRelay<Int>\n }\n"),
            Example("class Foo {\n  var baz: ReplayRelay<Int>\n }\n")
        ]
    )

    public func validate(file: SwiftLintFile, kind: SwiftDeclarationKind,
                         dictionary: SourceKittenDictionary) -> [StyleViolation] {
        guard
            kind == .varInstance,
            isSubjectType(dictionary),
            !isPrivate(dictionary)
        else {
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
