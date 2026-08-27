public import Ordinal_Cardinal
public import struct Ordinal.Ordinal
public import struct Tagged.Tagged

extension UnsafeMutableBufferPointer {

    @inlinable
    public subscript(
        _ index: Tagged<Element, Ordinal>
    ) -> Element {
        get {
            unsafe self[Int(bitPattern: index.underlying)]
        }
        nonmutating set {
            unsafe self[Int(bitPattern: index.underlying)] = newValue
        }
    }
}
