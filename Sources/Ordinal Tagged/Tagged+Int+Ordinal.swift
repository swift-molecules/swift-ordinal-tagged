public import Ordinal
public import Tagged

extension Int {

    @inlinable
    public init?<Tag: ~Copyable & ~Escapable>(exactly position: Tagged<Tag, Ordinal>) {
        self.init(exactly: position.underlying)
    }

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(_ position: Tagged<Tag, Ordinal>) throws(Ordinal.Error)
    {
        self = try Int(position.underlying)
    }

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(bitPattern position: Tagged<Tag, Ordinal>) {
        self = Int(bitPattern: position.underlying)
    }
}
