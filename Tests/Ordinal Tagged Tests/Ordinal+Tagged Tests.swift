import Ordinal_Tagged
import Testing

@testable import Ordinal

private enum SlotPosition {}
private enum LanePosition {}

extension Ordinal {
    @Suite
    struct Tagged {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Ordinal.Tagged.Unit {

    @Test
    func `construction from ordinal`() {
        let slot = Tagged.Tagged<SlotPosition, Ordinal>(Ordinal(3))
        #expect(slot.position == Ordinal(3))
    }

    @Test
    func `construction from integer literal`() {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        #expect(slot.position == 5)
    }

    @Test
    func `zero constant`() {
        #expect(Tagged.Tagged<SlotPosition, Ordinal>.zero == 0)
        #expect(Tagged.Tagged<SlotPosition, Ordinal>.zero.position == .zero)
    }

    @Test
    func `cross tag comparison forbidden`() {

        let slotA: Tagged.Tagged<SlotPosition, Ordinal> = 7
        let slotB: Tagged.Tagged<SlotPosition, Ordinal> = 7
        #expect(slotA == slotB)
    }

    @Test
    func `successor saturating`() {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let next = slot.successor.saturating()
        #expect(next == 6)
    }

    @Test
    func `successor exact`() throws(Ordinal.Error) {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let next = try slot.successor.exact()
        #expect(next == 6)
    }

    @Test
    func `predecessor exact`() throws(Ordinal.Error) {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let prev = try slot.predecessor.exact()
        #expect(prev == 4)
    }

    @Test
    func `advance saturating tagged count`() {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let count: Tagged.Tagged<SlotPosition, Cardinal> = 3
        let result = slot.advance.saturating(by: count)
        #expect(result == 8)
    }

    @Test
    func `advance exact tagged count`() throws(Ordinal.Error) {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let count: Tagged.Tagged<SlotPosition, Cardinal> = 3
        let result = try slot.advance.exact(by: count)
        #expect(result == 8)
    }

    @Test
    func `advance via plus operator`() {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let count: Tagged.Tagged<SlotPosition, Cardinal> = 3
        let result = slot + count
        #expect(result == 8)
    }

    @Test
    func `distance forward tagged`() throws(Ordinal.Error) {
        let a: Tagged.Tagged<SlotPosition, Ordinal> = 3
        let b: Tagged.Tagged<SlotPosition, Ordinal> = 8
        let distance = try a.distance.forward(to: b)
        #expect(distance == Tagged.Tagged<SlotPosition, Cardinal>(5))
    }

    @Test
    func `distance unchecked forward monotonic`() {

        let a: Ordinal = 3
        let b: Ordinal = 8
        let distance = a.distance.unchecked(to: b)
        #expect(distance == Cardinal(5))
    }

    @Test
    func `range count tagged`() {
        let lower: Tagged.Tagged<SlotPosition, Ordinal> = 3
        let upper: Tagged.Tagged<SlotPosition, Ordinal> = 8
        let range = lower..<upper
        #expect(range.count == Tagged.Tagged<SlotPosition, Cardinal>(5))
    }

    @Test
    func `range is empty when equal`() {
        let position: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let range = position..<position
        #expect(range.isEmpty)
    }

    @Test
    func `range init from start and count`() {
        let start: Tagged.Tagged<SlotPosition, Ordinal> = 3
        let count: Tagged.Tagged<SlotPosition, Cardinal> = 5
        let range = Swift.Range(start: start, count: count)
        #expect(range.lowerBound == start)
        #expect(range.upperBound == 8)
    }

    @Test
    func `cardinal from ordinal`() {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 5
        let count = Tagged.Tagged<SlotPosition, Cardinal>(slot)
        #expect(count == 5)
    }
}

extension Ordinal.Tagged.`Edge Case` {

    @Test
    func `successor exact throws at max`() {
        let max = Tagged.Tagged<SlotPosition, Ordinal>(Ordinal(UInt.max))
        #expect(throws: Ordinal.Error.overflow) {
            try max.successor.exact()
        }
    }

    @Test
    func `predecessor exact throws at zero`() {
        #expect(throws: Ordinal.Error.underflow) {
            try Tagged.Tagged<SlotPosition, Ordinal>.zero.predecessor.exact()
        }
    }

    @Test
    func `advance exact tagged count throws on overflow`() {
        let slot = Tagged.Tagged<SlotPosition, Ordinal>(Ordinal(UInt.max - 5))
        let count: Tagged.Tagged<SlotPosition, Cardinal> = 10
        #expect(throws: Ordinal.Error.overflow) {
            try slot.advance.exact(by: count)
        }
    }

    @Test
    func `distance forward throws when backward`() {
        let a: Tagged.Tagged<SlotPosition, Ordinal> = 8
        let b: Tagged.Tagged<SlotPosition, Ordinal> = 3
        #expect(throws: Ordinal.Error.notForward) {
            try a.distance.forward(to: b)
        }
    }
}

extension Ordinal.Tagged.Integration {

    @Test
    func `int exactly from tagged ordinal`() {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 42
        #expect(Int(exactly: slot) == 42)
    }

    @Test
    func `int from tagged ordinal`() throws(Ordinal.Error) {
        let slot: Tagged.Tagged<SlotPosition, Ordinal> = 42
        let value = try Int(slot)
        #expect(value == 42)
    }

    @Test
    func `int bit pattern from tagged ordinal`() {
        let slot = Tagged.Tagged<SlotPosition, Ordinal>(Ordinal(UInt.max))
        let bits = Int(bitPattern: slot)
        #expect(bits == -1)
    }
}
