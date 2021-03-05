/// A documentation callout, such as a note, remark, or warning.
public struct Callout: Hashable, Codable {
    public enum Delimiter: String, Hashable, CaseIterable, Codable {
        /**
         Highlighted information for the user of the symbol.

         An example of using the `Attention` callout:

           - Attention: What I if told you
         you read this line wrong?
         */
        case attention = "Attention"

        /**
         The author of the code for a symbol.

         An example of using the `Author` callout:

           - Author: William Shakespeare
         */
        case author = "Author"

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
        case authors = "Authors"

        /**
         A bug for a symbol.

         An example of using the `Bug` callout:

           - Bug:
           [*bugExample* contains a memory leak](BugDB://problem/1367823)

           - Bug:
           [Passing a `UIViewController` crashes *bugExample*](BugDB://problem/2274610)
         */
        case bug = "Bug"

        /**
         The algorithmic complexity of a method or function.

         An example of using the `Complexity` callout:

           - Complexity:
           The method demonstrates an inefficient way to sort
           using an O(N\*N\*N) (order N-cubed) algorithm
         */
        case complexity = "Complexity"

        /**
         Copyright information for a symbol.

         An example of using the `Copyright` callout:

           - Copyright: Copyright © 1215
           by The Group of Barrons
         */
        case copyright = "Copyright"

        /**
         A date associated with a symbol.

         An example of using the `Date` callout:

           Last date this example was changed
           - Date: August 19, 2015

           Days the method produces special results
           - Date: 12/31
           - Date: 03/17
         */
        case date = "Date"

        /**
         A suggestion to the user for usage of a method or function.

         An example of using the `Experiment` callout:

           - Experiment: Pass in a string in the present tense
           - Experiment: Pass in a string with no vowels
           - Experiment:
           Change the third case statement to work only with consonants
         */
        case experiment = "Experiment"

        /**
         Information that can have adverse effects on the tasks a user is trying to accomplish

         An example of using the `Important` callout:

         - Important:
           "The beginning is the most important part of the work."
           \
           –Plato
         */
        case important = "Important"

        /**
         A condition that is guaranteed to be true during the execution of the documented symbol.

         An example of using the `Invariant` callout:

           - Invariant:
           The person reference will not change during the execution of this method
         */
        case invariant = "Invariant"

        /**
         A note to the user of the symbol.

         An example of using the `Note` callout:

           - Note:
           This method returns an estimate.
           Use `reallyAccurateReading` to get the best results.
         */
        case note = "Note"

        /**
         A condition that must hold for the symbol to work.

         An example of using the `Precondition` callout:

           - Precondition: The `person` property must be non-nil.
           - Precondition: `updatedAddress` must be a valid address.
         */
        case precondition = "Precondition"

        /**
         A condition of guaranteed values upon completion of the execution of the symbol.

         An example of using the `Postcondition` callout:

           - Postcondition:
           After completing this method the billing address for
           the person will be set to `updatedAddress` if it is valid.
           Otherwise the billing address will not be changed.
         */
        case postcondition = "Postcondition"

        /**
         A remark to the user of the symbol.

         An example of using the `Remark` callout:

          - Remark:
          The performance could be reduced from N-squared to
          N-log-N by switching patterns.
         */
        case remark = "Remark"

        /**
         A requirement for the symbol to work.

         - SeeAlso: `precondition`

         An example of using the `Requires` callout:

           - Requires: `start <= end`.
           - Requires: `count > 0`.
         */
        case requires = "Requires"

        /**
         A references to other information.

         An example of using the `SeeAlso` callout:

           - SeeAlso:
           [My Library Reference](https://example.com)
         */
        case seealso = "See Also"

        /**
         Information about when the symbol became available, which may include dates, framework versions, and operating system versions.

         An example of using the `Since` callout:

           - Since: First available in Mac OS 7
         */
        case since = "Since"

        /**
         A task required to complete or update the functionality of the symbol.

         An example of using the `ToDo` callout:

           - ToDo: Run code coverage and add tests
         */
        case todo = "To Do"

        /**
         Version information for the symbol.

         An example of using the `Version` callout:

           - Version: 0.1 (61A329)
         */
        case version = "Version"

        /**
         A warning for the user of the symbol.

         An example of using the `Warning` callout:

           - Warning:
           Not all code paths for this method have been tested
         */
        case warning = "Warning"

        init?(_ description: String) {
            let description = description.normalized

            if let delimiter = Delimiter.allCases.first(where: { $0.rawValue.normalized == description }) {
                self = delimiter
            } else {
                return nil
            }
        }
    }

    public var delimiter: Delimiter
    public var content: String
}

// MARK: - CustomStringConvertible

extension Callout: CustomStringConvertible {
    public var description: String {
        return "- \(delimiter.rawValue.capitalized): \(content)"
    }
}

fileprivate extension String {
    var normalized: String {
        filter { !$0.isWhitespace }.lowercased()
    }
}
