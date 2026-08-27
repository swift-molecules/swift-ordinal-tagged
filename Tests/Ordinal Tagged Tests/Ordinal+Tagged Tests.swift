import Cardinal
import Ordinal
import Ordinal_Cardinal
import Ordinal_Property
import Ordinal_Tagged
import struct Tagged.Tagged
import Testing

private enum SlotPosition {}
private enum LanePosition {}

private typealias Slot = Tagged<SlotPosition, Ordinal>
private typealias SlotCount = Tagged<SlotPosition, Cardinal>

private func slot(_ value: UInt) -> Slot {
    Slot(Ordinal(value))
}

private func count(_ value: UInt) -> SlotCount {
    SlotCount(_unchecked: Cardinal(value))
}

private func elementPosition(_ value: UInt) -> Tagged<Int, Ordinal> {
    Tagged<Int, Ordinal>(Ordinal(value))
}

extension Ordinal {
    @Suite
    struct TaggedTests {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension Ordinal.TaggedTests.Unit {

    @Test
    func `construction exposes ordinal position`() {
        #expect(slot(3).position == Ordinal(3 as UInt))
    }

    @Test
    func `zero preserves the tag`() {
        #expect(Slot.zero.position == .zero)
    }

    @Test
    func `different tags retain the same underlying position`() {
        let lane = Tagged<LanePosition, Ordinal>(Ordinal(7 as UInt))
        #expect(slot(7).position == lane.position)
    }

    @Test
    func `successor policies preserve the tag`() throws(Ordinal.Error) {
        #expect(slot(5).successor.saturating().position == Ordinal(6 as UInt))
        #expect(try slot(5).successor.exact().position == Ordinal(6 as UInt))
    }

    @Test
    func `predecessor preserves the tag`() throws(Ordinal.Error) {
        #expect(try slot(5).predecessor.exact().position == Ordinal(4 as UInt))
    }

    @Test
    func `retreat clamps to a tagged bound`() {
        let result = slot(5).retreat.clamped(by: count(3), to: slot(1))
        #expect(result.position == Ordinal(2 as UInt))
    }

    @Test
    func `cardinal conversion preserves the tag`() {
        let result = SlotCount(slot(5))
        #expect(result.underlying == Cardinal(5 as UInt))
    }
}

extension Ordinal.TaggedTests.`Edge Case` {

    @Test
    func `successor exact throws at max`() {
        #expect(throws: Ordinal.Error.overflow) {
            try slot(.max).successor.exact()
        }
    }

    @Test
    func `predecessor exact throws at zero`() {
        #expect(throws: Ordinal.Error.underflow) {
            try Slot.zero.predecessor.exact()
        }
    }

    @Test
    func `advance exact propagates overflow`() {
        #expect(throws: Ordinal.Error.overflow) {
            try slot(.max - 5).advance.exact(by: count(10))
        }
    }

    @Test
    func `distance forward rejects a backward position`() {
        #expect(throws: Ordinal.Error.notForward) {
            try slot(8).distance.forward(to: slot(3))
        }
    }
}

extension Ordinal.TaggedTests.Integration {

    @Test
    func `generic ordinal policies compose through the seam`() throws(Ordinal.Error) {
        let advanced = try slot(5).advance.exact(by: count(3))
        let distance = try slot(5).distance.forward(to: advanced)
        #expect(advanced.position == Ordinal(8 as UInt))
        #expect(distance.underlying == Cardinal(3 as UInt))
    }

    @Test
    func `plus composes with tagged cardinal counts`() {
        #expect((slot(5) + count(3)).position == Ordinal(8 as UInt))
    }

    @Test
    func `array construction supplies tagged positions`() {
        let values = Array(count: count(3)) { index in
            index.position.rawValue
        }
        #expect(values == [0, 1, 2])
    }

    @Test
    func `buffer access accepts a tagged position`() {
        let values = [10, 20, 30]
        values.withUnsafeBufferPointer { buffer in
            #expect(unsafe buffer[elementPosition(1)] == 20)
        }
    }

    @Test
    func `mutable buffer access accepts a tagged position`() {
        var values = [10, 20, 30]
        values.withUnsafeMutableBufferPointer { buffer in
            unsafe buffer[elementPosition(1)] = 42
        }
        #expect(values == [10, 42, 30])
    }

    @Test
    func `int conversions preserve a tagged ordinal`() throws(Ordinal.Error) {
        let position = slot(42)
        #expect(Int(exactly: position) == 42)
        #expect(try Int(position) == 42)
        #expect(Int(bitPattern: slot(.max)) == -1)
    }
}
