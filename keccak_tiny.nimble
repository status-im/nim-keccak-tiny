mode = ScriptMode.Verbose

packageName   = "keccak_tiny"
version       = "0.2.0"
author        = "Status Research & Development GmbH"
description   = "A wrapper for the keccak-tiny C library"
license       = "Apache License 2.0"
skipDirs      = @["tests"]

requires "nim >= 0.17.0",
         "nim-ranges"

proc configForTests() =
  --hints: off
  --debuginfo
  --path: "."
  --run

task test, "run CPU tests":
  configForTests()
  setCommand "c", "tests/all.nim"

