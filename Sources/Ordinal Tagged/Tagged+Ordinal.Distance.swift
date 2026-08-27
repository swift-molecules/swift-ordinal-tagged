public import Cardinal
public import Ordinal
public import Ordinal_Cardinal
public import Property
public import Tagged

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public enum Distance {}
}

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public var distance: Property<Distance, Self> {
        Property(self)
    }
}

extension Property {

    @inlinable
    public func forward<T: ~Copyable & ~Escapable>(
        to other: Tagged<T, Ordinal>
    ) throws(Ordinal.Error) -> Tagged<T, Ordinal>.Count
    where
        Tag == Tagged<T, Ordinal>.Distance,
        Base == Tagged<T, Ordinal>
    {
        if other.ordinal < base.ordinal {
            throw .notForward
        }
        return Tagged<T, Ordinal>.Count(Cardinal(other.ordinal.rawValue - base.ordinal.rawValue))
    }
}
