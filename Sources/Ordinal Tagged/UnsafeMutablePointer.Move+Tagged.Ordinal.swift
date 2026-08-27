public import Cardinal_Standard_Library_Integration
public import Ordinal_Cardinal
public import struct Ordinal.Ordinal
public import struct Property.Property
public import struct Tagged.Tagged

extension UnsafeMutablePointer where Pointee: ~Copyable {

    public enum Move {}
}

extension UnsafeMutablePointer where Pointee: ~Copyable {

    @inlinable
    public var move: Property<Move, Self> {
        unsafe Property(self)
    }
}

extension Property {

    @inlinable
    public func initialize<Pointee: ~Copyable>(
        from source: UnsafeMutablePointer<Pointee>,
        count: Tagged<Pointee, Ordinal>.Count
    ) where Tag == UnsafeMutablePointer<Pointee>.Move, Base == UnsafeMutablePointer<Pointee> {
        unsafe base.moveInitialize(
            from: source,
            count: Int(bitPattern: count.underlying)
        )
    }

    @inlinable
    public func update<Pointee>(
        from source: UnsafeMutablePointer<Pointee>,
        count: Tagged<Pointee, Ordinal>.Count
    ) where Tag == UnsafeMutablePointer<Pointee>.Move, Base == UnsafeMutablePointer<Pointee> {
        unsafe base.moveUpdate(from: source, count: Int(bitPattern: count.underlying))
    }
}
