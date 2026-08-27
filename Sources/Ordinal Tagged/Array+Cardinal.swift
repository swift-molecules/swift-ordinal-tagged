public import Cardinal
public import Cardinal_Standard_Library_Integration
public import Ordinal
public import Tagged

extension Array {

    @inlinable
    public init<Tag: ~Copyable & ~Escapable, E: Swift.Error>(
        count: Tagged<Tag, Cardinal>,
        _ element: (Tagged<Tag, Ordinal>) throws(E) -> Element
    ) throws(E) {
        let n = Int(bitPattern: count.underlying)
        self = try (0..<n).map { (index: Int) throws(E) -> Element in
            try element(Tagged<Tag, Ordinal>(Ordinal(UInt(index))))
        }
    }
}
