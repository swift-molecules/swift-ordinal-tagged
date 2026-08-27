public import Ordinal_Property
public import struct Ordinal.Ordinal
public import Property
public import struct Tagged.Tagged

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public enum Predecessor {}
}

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public var predecessor: Property<Predecessor, Self> {
        Property(self)
    }
}

extension Property {

    @inlinable
    public func exact<T: ~Copyable & ~Escapable>() throws(Ordinal.Error) -> Base
    where
        Tag == Tagged<T, Ordinal>.Predecessor,
        Base == Tagged<T, Ordinal>
    {
        try base.map { ordinal throws(Ordinal.Error) in try ordinal.predecessor.exact() }
    }
}
