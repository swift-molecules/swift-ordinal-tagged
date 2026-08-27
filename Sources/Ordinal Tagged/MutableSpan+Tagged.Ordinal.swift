public import Cardinal_Standard_Library_Integration
public import Tagged

extension Swift.MutableSpan where Element: ~Copyable {

    @_lifetime(immortal)
    @inlinable
    public init(
        _unsafeStart start: UnsafeMutablePointer<Element>,
        count: Tagged<Element, Ordinal>.Count
    ) {
        let span = unsafe Swift.MutableSpan(
            _unsafeStart: start,
            count: Int(bitPattern: count.underlying)
        )
        unsafe (self = _overrideLifetime(span, borrowing: ()))
    }
}
