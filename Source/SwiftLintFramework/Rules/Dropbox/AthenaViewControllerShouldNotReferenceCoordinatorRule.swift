import SourceKittenFramework

public struct AthenaViewControllerShouldNotReferenceCoordinatorRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "view_controller_should_not_reference_coordinator",
        name: "ViewController Should Not Reference Coordinator",
        description: "ViewController should not reference Coordinators. Instead, vend `actions: PublishRelay<Action>`.",
        kind: .idiomatic,
        nonTriggeringExamples: [
            Example("class Foo {\n  private var baz: ReplayRelay<Int>\n }\n")
        ],
        triggeringExamples: [
            Example("class Foo {\n  var baz: ReplayRelay<Int>\n }\n")
        ]
    )

    public func validate(file: SwiftLintFile, kind: SwiftDeclarationKind,
                         dictionary: SourceKittenDictionary) -> [StyleViolation] {

        guard isAthenaViewController(dictionary) else { return [] }
        return validate(file: file, classDeclaration: dictionary)
    }

    private func validate(file: SwiftLintFile, classDeclaration dictionary: SourceKittenDictionary) -> [StyleViolation] {
        var violations = dictionary.traverseBreadthFirst { validate(file: file, classDeclaration: $0) }

        if isAthenaCoordinator(dictionary) {
            let violation = violationFor(
                dictionary: dictionary,
                ruleDescription: type(of: self).description,
                severity: configuration.severity,
                file: file
            )
            violations.append(violation)
        }

        return violations
    }
    
}
