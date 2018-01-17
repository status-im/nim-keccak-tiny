{.compile: "keccak-tiny/keccak-tiny.c".}

import
  strutils, parseutils

type
  Hash*[bits: static[int]] = object
    data*: array[bits div 8, uint8]

  InputRange* = (pointer, csize)

proc `$`*(h: Hash): string =
  result = ""
  for byte in h.data:
    result.add(toHex(int(byte), 2))

proc hashFromHex*(bits: static[int], input: string): Hash[bits] =
  if input.len != bits div 4:
    raise newException(ValueError,
                       "The input string has incorrect size")

  for i in 0 ..< bits div 8:
    var nextByte: int
    if parseHex(input, nextByte, i*2, 2) == 2:
      result.data[i] = uint8(nextByte)
    else:
      raise newException(ValueError,
                         "The input string contains invalid characters")

template hashFromHex*(s: static[string]): untyped = hashFromHex(s.len * 4, s)

proc toInputRange(x: string): InputRange = (x.cstring.pointer, x.len)
proc toInputRange[T](x: openarray[T]): InputRange = (cast[pointer](x), x.len * T.sizeof)

proc extSha224(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_224".}
proc extSha256(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_256".}
proc extSha384(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_384".}
proc extSha512(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_512".}
proc extKeccak224(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "keccak_224".}
proc extKeccak256(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "keccak_256".}
proc extKeccak384(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "keccak_384".}
proc extKeccak512(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "keccak_512".}
proc extShake128(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "shake128".}
proc extShake256(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "shake256".}

proc sha3_224(input: InputRange): Hash[224] =
  extSha224(addr(result.data), 224 div 8, input[0], input[1])

template sha3_224*(input: typed): Hash[224] =
  sha3_224(toInputRange(input))

proc sha3_256(input: InputRange): Hash[256] =
  extSha256(addr(result.data), 256 div 8, input[0], input[1])

template sha3_256*(input: typed): Hash[256] =
  sha3_256(toInputRange(input))

proc sha3_384(input: InputRange): Hash[384] =
  extSha384(addr(result.data), 384 div 8, input[0], input[1])

template sha3_384*(input: typed): Hash[384] =
  sha3_384(toInputRange(input))

proc sha3_512(input: InputRange): Hash[512] =
  extSha512(addr(result.data), 512 div 8, input[0], input[1])

template sha3_512*(input: typed): Hash[512] =
  sha3_512(toInputRange(input))

proc keccak_224(input: InputRange): Hash[224] =
  extKeccak224(addr(result.data), 224 div 8, input[0], input[1])

template keccak_224*(input: typed): Hash[224] =
  keccak_224(toInputRange(input))

proc keccak_256(input: InputRange): Hash[256] =
  extKeccak256(addr(result.data), 256 div 8, input[0], input[1])

template keccak_256*(input: typed): Hash[256] =
  keccak_256(toInputRange(input))

proc keccak_384(input: InputRange): Hash[384] =
  extKeccak384(addr(result.data), 384 div 8, input[0], input[1])

template keccak_384*(input: typed): Hash[384] =
  keccak_384(toInputRange(input))

proc keccak_512(input: InputRange): Hash[512] =
  extKeccak512(addr(result.data), 512 div 8, input[0], input[1])

template keccak_512*(input: typed): Hash[512] =
  keccak_512(toInputRange(input))

proc shake_128(input: InputRange): Hash[128] =
  extShake128(addr(result.data), 128 div 8, input[0], input[1])

template shake_128*(input: typed): Hash[128] =
  shake_128(toInputRange(input))

proc shake_256(input: InputRange): Hash[256] =
  extShake256(addr(result.data), 256 div 8, input[0], input[1])

template shake_256*(input: typed): Hash[256] =
  shake_256(toInputRange(input))

