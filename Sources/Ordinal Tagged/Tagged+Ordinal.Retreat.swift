public import Cardinal
public import Ordinal
public import Property
public import Tagged

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public enum Retreat {}
}

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public var retreat: Property<Retreat, Self> {
        Property(self)
    }
}

extension Property {

    @inlinable
    public func clamped<T: ~Copyable & ~Escapable>(
        by count: Tagged<T, Cardinal>,
        to bound: Tagged<T, Ordinal>
    ) -> Base
    where
        Tag == Tagged<T, Ordinal>.Retreat,
        Base == Tagged<T, Ordinal>
    {
        base.map { ordinal in ordinal.retreat.clamped(by: count.underlying, to: bound.underlying) }
    }
}
