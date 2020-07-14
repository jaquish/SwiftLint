/// These are `String`-based heuristics so that rules can be implemented without using the full AST.
///
/// Map unthemed to themed suggestion.
let SuggestThemedCellForCell: [String: String] = [
    "ButtonImageCellModel": "ButtonImageThemedCellModel",
    "ButtonCellModel": "ButtonThemedCellModel",
    "IconTextCellModel": "IconTextThemedCellModel",
    "ImageTextCellModel": "ImageTextThemedCellModel",
    "ImageCellModel": "ImageThemedCellModel",
    "LabelCellModel": "LabelThemedCellModel",
    "SegmentedControlCellModel": "SegmentedControlThemedCellModel",
    "SeparatorCellModel": "SeparatorThemedCellModel",
    "SwitchTextCellModel": "SwitchTextThemedCellModel",
    "TextInputCellModel": "TextInputThemedCellModel",
    "TextViewCellModel": "TextViewThemedCellModel"
]

let SuggestRestrictiveTypeForObservable = [
    "BehaviorSubject": "BehaviorRelay or Driver",
    "PublishSubject": "PublishRelay or Signal",
    "ReplaySubject": "Signal"
]

func isAthenaCoordinator(_ dictionary: SourceKittenDictionary) -> Bool {
    // Consider all types ending in `Coordinator` to be Minerva Coordinators.
    let suffixes = ["Coordinator", "Coordinator?"]
    guard let typeName = dictionary.typeName else { return false }
    return suffixes.contains(where: typeName.hasSuffix)
}

func isAthenaPresenter(_ dictionary: SourceKittenDictionary) -> Bool {
    dictionary.inheritedTypes.contains("AthenaPresenter")
}

func isInitializerOfType(_ named: String, dictionary: SourceKittenDictionary) -> Bool {
    dictionary.expressionKind == .call && dictionary.name == named
}

func isAthenaViewController(_ dictionary: SourceKittenDictionary) -> Bool {
    let typeNames = ["StackViewController", "AthenaViewController", "BasicAthenaViewController"]
    return dictionary.inheritedTypes.contains(where: { typeNames.contains($0) })
}

func isObservableType(_ dictionary: SourceKittenDictionary) -> Bool {
    mapToSimpleObservableName(dictionary) != nil
}

func isSubjectType(_ dictionary: SourceKittenDictionary) -> Bool {
    guard let typeName = dictionary.typeName else { return false }

    let names = [
        "BehaviorSubject",
        "PublishSubject",
        "ReplaySubject",
        "BehaviorRelay",
        "PublishRelay",
        "ReplayRelay"
    ]

    // The full type name could be Observable<Foo> or Observable<Foo>?, so search with contains.
    return names.contains(where: { typeName.contains($0) })
}

func mapToSimpleObservableName(_ dictionary: SourceKittenDictionary) -> String? {
    let observableTypes = [
        "Observable" ,
        "Single",
        "Maybe",
        "BehaviorSubject",
        "PublishSubject",
        "ReplaySubject",
        "BehaviorRelay",
        "PublishRelay",
        "Signal",
        "Driver"
    ]

    guard let typeName = dictionary.typeName else { return nil }

    // The full type name could be Observable<Foo> or Observable<Foo>?, so search with contains.
    return observableTypes.first(where: { typeName.contains($0) })
}

func isMutable(_ dictionary: SourceKittenDictionary) -> Bool {
    dictionary.setterAccessibility != nil
}

func isPrivate(_ dictionary: SourceKittenDictionary) -> Bool {
    dictionary.accessibility?.isPrivate ?? false
}

func violationFor(
    dictionary: SourceKittenDictionary,
    ruleDescription: RuleDescription,
    severity: ViolationSeverity,
    file: SwiftLintFile
) -> StyleViolation {
    let location: Location
    if let offset = dictionary.offset {
        location = Location(file: file, byteOffset: offset)
    } else {
        location = Location(file: file.path)
    }

    return StyleViolation(ruleDescription: ruleDescription, severity: severity, location: location)
}
