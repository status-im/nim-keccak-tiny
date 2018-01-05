mode = ScriptMode.Verbose

packageName   = "keccak_tiny"
version       = "0.1.0"
author        = "Zahary Karadjov"
description   = "A wrapper for the keccak-tiny C library"
license       = "Apache2"
skipDirs      = @["tests"]

requires "nim >= 0.17.0"

proc configForTests() =
  --hints: off
  --debuginfo
  --path: "."
  --run

task test, "run CPU tests":
  configForTests()
  setCommand "c", "tests/all.nim"

