public import Ordinal
public import Property
public import Tagged

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public enum Successor {}
}

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public var successor: Property<Successor, Self> {
        Property(self)
    }
}

extension Property {

    @inlinable
    public func saturating<T: ~Copyable & ~Escapable>() -> Base
    where
        Tag == Tagged<T, Ordinal>.Successor,
        Base == Tagged<T, Ordinal>
    {
        base.map { ordinal in ordinal.successor.saturating() }
    }

    @inlinable
    public func exact<T: ~Copyable & ~Escapable>() throws(Ordinal.Error) -> Base
    where
        Tag == Tagged<T, Ordinal>.Successor,
        Base == Tagged<T, Ordinal>
    {
        try base.map { ordinal throws(Ordinal.Error) in try ordinal.successor.exact() }
    }
}
