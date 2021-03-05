import Foundation

/// A documentation callout, such as a note, remark, or warning.
public struct Callout: Hashable, Codable {
    /// A label that marks the beginning of a callout.
    public enum Delimiter: Hashable {
        /**
         Highlighted information for the user of the symbol.

         An example of using the `Attention` callout:

         - Attention: What I if told you
         you read this line wrong?
         */
        case attention

        /**
         The author of the code for a symbol.

         An example of using the `Author` callout:

         - Author: William Shakespeare
         */
        case author

        /**
         The authors of the code for a symbol.

         - Important: There is an empty line between each author name.

         An example of using the `Authors` callout:

         - Authors:
         Plato

         Aristotle

         Other amazing
         classical folk
         */
        case authors

        /**
         A bug for a symbol.

         An example of using the `Bug` callout:

         - Bug:
         [*bugExample* contains a memory leak](BugDB://problem/1367823)

         - Bug:
         [Passing a `UIViewController` crashes *bugExample*](BugDB://problem/2274610)
         */
        case bug

        /**
         The algorithmic complexity of a method or function.

         An example of using the `Complexity` callout:

         - Complexity:
         The method demonstrates an inefficient way to sort
         using an O(N\*N\*N) (order N-cubed) algorithm
         */
        case complexity

        /**
         Copyright information for a symbol.

         An example of using the `Copyright` callout:

         - Copyright: Copyright © 1215
         by The Group of Barrons
         */
        case copyright

        /**
         A date associated with a symbol.

         An example of using the `Date` callout:

         Last date this example was changed
         - Date: August 19, 2015

         Days the method produces special results
         - Date: 12/31
         - Date: 03/17
         */
        case date

        /**
         A suggestion to the user for usage of a method or function.

         An example of using the `Experiment` callout:

         - Experiment: Pass in a string in the present tense
         - Experiment: Pass in a string with no vowels
         - Experiment:
         Change the third case statement to work only with consonants
         */
        case experiment

        /**
         Information that can have adverse effects on the tasks a user is trying to accomplish

         An example of using the `Important` callout:

         - Important:
         "The beginning is the most important part of the work."
         \
         –Plato
         */
        case important

        /**
         A condition that is guaranteed to be true during the execution of the documented symbol.

         An example of using the `Invariant` callout:

         - Invariant:
         The person reference will not change during the execution of this method
         */
        case invariant

        /**
         A note to the user of the symbol.

         An example of using the `Note` callout:

         - Note:
         This method returns an estimate.
         Use `reallyAccurateReading` to get the best results.
         */
        case note

        /**
         A condition that must hold for the symbol to work.

         An example of using the `Precondition` callout:

         - Precondition: The `person` property must be non-nil.
         - Precondition: `updatedAddress` must be a valid address.
         */
        case precondition

        /**
         A condition of guaranteed values upon completion of the execution of the symbol.

         An example of using the `Postcondition` callout:

         - Postcondition:
         After completing this method the billing address for
         the person will be set to `updatedAddress` if it is valid.
         Otherwise the billing address will not be changed.
         */
        case postcondition

        /**
         A remark to the user of the symbol.

         An example of using the `Remark` callout:

         - Remark:
         The performance could be reduced from N-squared to
         N-log-N by switching patterns.
         */
        case remark

        /**
         A requirement for the symbol to work.

         - SeeAlso: `precondition`

         An example of using the `Requires` callout:

         - Requires: `start <= end`.
         - Requires: `count > 0`.
         */
        case requires

        /**
         A references to other information.

         An example of using the `SeeAlso` callout:

         - SeeAlso:
         [My Library Reference](https://example.com)
         */
        case seealso

        /**
         Information about when the symbol became available, which may include dates, framework versions, and operating system versions.

         An example of using the `Since` callout:

         - Since: First available in Mac OS 7
         */
        case since

        /**
         A task required to complete or update the functionality of the symbol.

         An example of using the `ToDo` callout:

         - ToDo: Run code coverage and add tests
         */
        case todo

        /**
         Version information for the symbol.

         An example of using the `Version` callout:

         - Version: 0.1 (61A329)
         */
        case version

        /**
         A warning for the user of the symbol.

         An example of using the `Warning` callout:

         - Warning:
         Not all code paths for this method have been tested
         */
        case warning


        /**
         A callout with a custom title.

         An example of using a custom callout:

         * Callout(Llama Spotting Tips):
           Pack warm clothes with your binoculars.
         */
        case custom(String)
    }

    /// The callout delimiter.
    public var delimiter: Delimiter

    /// The content of the callout.
    public var content: String
}

// MARK: - CustomStringConvertible

extension Callout: CustomStringConvertible {
    public var description: String {
        return "- \(delimiter.rawValue.capitalized): \(content)"
    }
}

// MARK: - RawRepresentable

extension Callout.Delimiter: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue.filter({ !$0.isWhitespace }).lowercased() {
        case "attention":
            self = .attention
        case "author":
            self = .author
        case "authors":
            self = .authors
        case "bug":
            self = .bug
        case "complexity":
            self = .complexity
        case "copyright":
            self = .copyright
        case "date":
            self = .date
        case "experiment":
            self = .experiment
        case "important":
            self = .important
        case "invariant":
            self = .invariant
        case "note":
            self = .note
        case "precondition":
            self = .precondition
        case "postcondition":
            self = .postcondition
        case "remark":
            self = .remark
        case "requires":
            self = .requires
        case "seealso":
            self = .seealso
        case "since":
            self = .since
        case "todo":
            self = .todo
        case "version":
            self = .version
        case "warning":
            self = .warning
        default:
            if rawValue.hasSuffix(")"),
               let openParenthisIndex = rawValue.firstIndex(of: "("),
               rawValue.prefix(upTo: openParenthisIndex).lowercased() == "custom",
               let startIndex = rawValue.index(openParenthisIndex, offsetBy: 1, limitedBy: rawValue.endIndex),
               let endIndex = rawValue.lastIndex(of: ")")
            {
                self = .custom(String(rawValue[startIndex..<endIndex]))
            } else {
                return nil
            }
        }
    }

    public var rawValue: String {
        switch self {
        case .attention:
            return "Attention"
        case .author:
            return "Author"
        case .authors:
            return "Authors"
        case .bug:
            return "Bug"
        case .complexity:
            return "Complexity"
        case .copyright:
            return "Copyright"
        case .custom(let callout):
            return "Custom(\(callout))"
        case .date:
            return "Date"
        case .experiment:
            return "Experiment"
        case .important:
            return "Important"
        case .invariant:
            return "Invariant"
        case .note:
            return "Note"
        case .precondition:
            return "Precondition"
        case .postcondition:
            return "Postcondition"
        case .remark:
            return "Remark"
        case .requires:
            return "Requires"
        case .seealso:
            return "See Also"
        case .since:
            return "Since"
        case .todo:
            return "To Do"
        case .version:
            return "Version"
        case .warning:
            return "Warning"
        }
    }
}

// MARK: - Codable

extension Callout.Delimiter: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let delimiter = Self(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "invalid callout delimiter: \(rawValue)")
        }

        self = delimiter
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
