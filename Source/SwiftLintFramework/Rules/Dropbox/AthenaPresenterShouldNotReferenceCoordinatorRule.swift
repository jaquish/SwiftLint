import SourceKittenFramework

public struct AthenaPresenterShouldNotReferenceCoordinatorRule: ASTRule, OptInRule, ConfigurationProviderRule, AutomaticTestableRule {
    public var configuration = SeverityConfiguration(.warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "presenter_should_not_reference_coordinator",
        name: "Presenter Should Not Reference Coordinator",
        description: "Presenters should not reference Coordinators. Instead, vend `actions: PublishRelay<Action>`.",
        kind: .idiomatic,
        nonTriggeringExamples: [
            Example("""
            class FooPresenter: AthenaPresenter {
                var foo: Int?
            }
            """)
        ],
        triggeringExamples: [
            Example("""
                class FooPresenter: AthenaPresenter {
                    var foo: Int?
                    var coordinator: FooCoordinator?

                    func sections() -> [Any] {
                        let cell0 = ButtonImageCellModel()
                        let cell1 = ButtonCellModel()

                        return [cell0, cell1]
                    }
                }
                """)
        ]
    )

    public func validate(file: SwiftLintFile, kind: SwiftDeclarationKind,
                         dictionary: SourceKittenDictionary) -> [StyleViolation] {
        guard isAthenaPresenter(dictionary) else { return [] }
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
