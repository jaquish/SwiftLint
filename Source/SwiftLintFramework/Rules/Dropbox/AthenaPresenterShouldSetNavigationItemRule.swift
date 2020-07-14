import SourceKittenFramework


public struct AthenaPresenterShouldSetNavigationItemRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "athena_presenter_should_set_navigation_item",
        name: "AthenaPresenter Should Set Navigation Item",
        description: "The navigationItem should be set by the Presenter when possible.",
        kind: .idiomatic,
        nonTriggeringExamples: [

        ],
        triggeringExamples: [
            Example("class FooVC: AthenaViewController { \n  init() { self.title = \"Foo\" } \n }")
        ]
    )

    
    public func validate(file: SwiftLintFile, kind: SwiftDeclarationKind,
                         dictionary: SourceKittenDictionary) -> [StyleViolation] {
        guard isAthenaViewController(dictionary) else { return [] }
        return validate(file: file, classDeclaration: dictionary)
    }

    private func validate(file: SwiftLintFile, classDeclaration dictionary: SourceKittenDictionary) -> [StyleViolation] {
        var violations = dictionary.traverseBreadthFirst { validate(file: file, classDeclaration: $0) }

        if isInitializerOfType("UINavigationItem", dictionary: dictionary) {
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

