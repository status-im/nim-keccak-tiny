{.compile: "keccak-tiny/keccak-tiny.c".}
when not defined(cpp) or defined(objc) or defined(js):
    {.passC: "-std=c99".}

import
  strutils, parseutils, ranges/memranges

type
  Hash*[bits: static[int]] = object
    data*: array[bits div 8, uint8]

proc `$`*(h: Hash): string =
  result = newStringOfCap(high(h.data) * 2)
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

proc sha3_224(input: MemRange): Hash[224] =
  extSha224(addr(result.data), 224 div 8, input.baseAddr, input.len)

template sha3_224*(input: typed): Hash[224] =
  sha3_224(toMemRange(input))

proc sha3_256(input: MemRange): Hash[256] =
  extSha256(addr(result.data), 256 div 8, input.baseAddr, input.len)

template sha3_256*(input: typed): Hash[256] =
  sha3_256(toMemRange(input))

proc sha3_384(input: MemRange): Hash[384] =
  extSha384(addr(result.data), 384 div 8, input.baseAddr, input.len)

template sha3_384*(input: typed): Hash[384] =
  sha3_384(toMemRange(input))

proc sha3_512(input: MemRange): Hash[512] =
  extSha512(addr(result.data), 512 div 8, input.baseAddr, input.len)

template sha3_512*(input: typed): Hash[512] =
  sha3_512(toMemRange(input))

proc keccak_224(input: MemRange): Hash[224] =
  extKeccak224(addr(result.data), 224 div 8, input.baseAddr, input.len)

template keccak_224*(input: typed): Hash[224] =
  keccak_224(toMemRange(input))

proc keccak_256(input: MemRange): Hash[256] =
  extKeccak256(addr(result.data), 256 div 8, input.baseAddr, input.len)

template keccak_256*(input: typed): Hash[256] =
  keccak_256(toMemRange(input))

proc keccak_384(input: MemRange): Hash[384] =
  extKeccak384(addr(result.data), 384 div 8, input.baseAddr, input.len)

template keccak_384*(input: typed): Hash[384] =
  keccak_384(toMemRange(input))

proc keccak_512(input: MemRange): Hash[512] =
  extKeccak512(addr(result.data), 512 div 8, input.baseAddr, input.len)

template keccak_512*(input: typed): Hash[512] =
  keccak_512(toMemRange(input))

proc shake_128(input: MemRange): Hash[128] =
  extShake128(addr(result.data), 128 div 8, input.baseAddr, input.len)

template shake_128*(input: typed): Hash[128] =
  shake_128(toMemRange(input))

proc shake_256(input: MemRange): Hash[256] =
  extShake256(addr(result.data), 256 div 8, input.baseAddr, input.len)

template shake_256*(input: typed): Hash[256] =
  shake_256(toMemRange(input))
