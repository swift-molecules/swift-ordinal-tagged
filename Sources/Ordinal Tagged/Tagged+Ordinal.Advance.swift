public import Cardinal
public import Ordinal
public import Ordinal_Cardinal
public import Property
public import Tagged

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public enum Advance {}
}

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public var advance: Property<Advance, Self> {
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
        Tag == Tagged<T, Ordinal>.Advance,
        Base == Tagged<T, Ordinal>
    {
        base.map { ordinal in ordinal.advance.clamped(by: count.underlying, to: bound.underlying) }
    }
}
