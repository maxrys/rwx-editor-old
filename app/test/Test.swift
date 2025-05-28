
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Testing

struct Test {

    let prettyResult: (UInt) -> String = { value in
        String("0b") + String(value, radix: 2).paddingLeft(toLength: 9, withPad: "0")
    }

    @Test func all() throws {
        try? self.bitGet()
        try? self.bitSet()
        try? self.bitToggle()
    }

    func bitGet() throws {
        print("bitGet:")
        for i in 0 ... 0b111111111 {
            let received = "0b" +
                String(UInt(i).bitGet(position: 8)) +
                String(UInt(i).bitGet(position: 7)) +
                String(UInt(i).bitGet(position: 6)) +
                String(UInt(i).bitGet(position: 5)) +
                String(UInt(i).bitGet(position: 4)) +
                String(UInt(i).bitGet(position: 3)) +
                String(UInt(i).bitGet(position: 2)) +
                String(UInt(i).bitGet(position: 1)) +
                String(UInt(i).bitGet(position: 0))
            let expected = self.prettyResult(UInt(i))
            print("\(String(i).padding(toLength: 3, withPad: " ", startingAt: 0)): ", terminator: "")
            print("\(received) = \(expected)", terminator: "")
                #expect(expected == received)
            print("")
        }
    }

    func bitSet() throws {
        var value: UInt
        var received: String
        var expected: String
        var isOn: Bool

        isOn = false
        print("bitSet (value: 0b000000000, isOn: \(isOn)):")
        value = 0b000000000;  value.bitSet(position: 0, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 1, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 2, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 3, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 4, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 5, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 6, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 7, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 8, isOn: isOn);  expected = "0b000000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)

        isOn = true
        print("bitSet (value: 0b000000000, isOn: \(isOn)):")
        value = 0b000000000;  value.bitSet(position: 0, isOn: isOn);  expected = "0b000000001";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 1, isOn: isOn);  expected = "0b000000010";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 2, isOn: isOn);  expected = "0b000000100";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 3, isOn: isOn);  expected = "0b000001000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 4, isOn: isOn);  expected = "0b000010000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 5, isOn: isOn);  expected = "0b000100000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 6, isOn: isOn);  expected = "0b001000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 7, isOn: isOn);  expected = "0b010000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitSet(position: 8, isOn: isOn);  expected = "0b100000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)

        isOn = false
        print("bitSet (value: 0b111111111, isOn: \(isOn)):")
        value = 0b111111111;  value.bitSet(position: 0, isOn: isOn);  expected = "0b111111110";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 1, isOn: isOn);  expected = "0b111111101";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 2, isOn: isOn);  expected = "0b111111011";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 3, isOn: isOn);  expected = "0b111110111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 4, isOn: isOn);  expected = "0b111101111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 5, isOn: isOn);  expected = "0b111011111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 6, isOn: isOn);  expected = "0b110111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 7, isOn: isOn);  expected = "0b101111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 8, isOn: isOn);  expected = "0b011111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)

        isOn = true
        print("bitSet (value: 0b111111111, isOn: \(isOn)):")
        value = 0b111111111;  value.bitSet(position: 0, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 1, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 2, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 3, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 4, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 5, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 6, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 7, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitSet(position: 8, isOn: isOn);  expected = "0b111111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
    }

    func bitToggle() throws {
        var value: UInt
        var received: String
        var expected: String

        print("bitToggle (value: 0b000000000):")
        value = 0b000000000;  value.bitToggle(position: 0);  expected = "0b000000001";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 1);  expected = "0b000000010";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 2);  expected = "0b000000100";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 3);  expected = "0b000001000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 4);  expected = "0b000010000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 5);  expected = "0b000100000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 6);  expected = "0b001000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 7);  expected = "0b010000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b000000000;  value.bitToggle(position: 8);  expected = "0b100000000";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)

        print("bitToggle (value: 0b111111111):")
        value = 0b111111111;  value.bitToggle(position: 0);  expected = "0b111111110";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 1);  expected = "0b111111101";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 2);  expected = "0b111111011";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 3);  expected = "0b111110111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 4);  expected = "0b111101111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 5);  expected = "0b111011111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 6);  expected = "0b110111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 7);  expected = "0b101111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
        value = 0b111111111;  value.bitToggle(position: 8);  expected = "0b011111111";  received = self.prettyResult(value);  print("\(expected) = \(received)");  #expect(expected == received)
    }

}
