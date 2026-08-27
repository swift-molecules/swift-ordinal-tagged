public import Cardinal
public import Ordinal_Cardinal
public import Ordinal
public import Tagged

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public var position: Ordinal { underlying }

    @inlinable
    public static var zero: Self { .init(_unchecked: .zero) }
}

extension Tagged where Underlying == Cardinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public init(_ index: Tagged<Tag, Ordinal>) {
        self = index.map(Cardinal.init)
    }
}
