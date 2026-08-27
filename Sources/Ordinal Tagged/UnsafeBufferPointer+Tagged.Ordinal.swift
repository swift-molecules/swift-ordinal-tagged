public import Ordinal_Cardinal
public import struct Ordinal.Ordinal
public import struct Tagged.Tagged

extension UnsafeBufferPointer {

    @inlinable
    public subscript(
        _ index: Tagged<Element, Ordinal>
    ) -> Element {
        unsafe self[Int(bitPattern: index.underlying)]
    }
}
