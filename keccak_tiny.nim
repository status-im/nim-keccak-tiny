{.compile: "keccak-tiny/keccak-tiny.c".}

import
  strutils

type
  Hash*[bits: static[int]] = object
    data: array[bits div 8, uint8]
  
  InputRange* = (pointer, csize)
  
proc `$`*(h: Hash): string =
  result = ""
  for byte in h.data:
    result.add(toHex(int(byte), 2))

proc toInputRange(x: string): InputRange = (x.cstring.pointer, x.len)
proc toInputRange[T](x: openarray[T]): InputRange = (cast[pointer](x), x.len * T.sizeof)

proc extSha224(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_224".}
proc extSha256(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_256".}
proc extSha384(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_384".}
proc extSha512(output: pointer, outSize: csize, input: pointer, inputSize: csize) {.importc: "sha3_512".}
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

proc shake_128(input: InputRange): Hash[128] =
  extShake128(addr(result.data), 128 div 8, input[0], input[1])

template shake_128*(input: typed): Hash[128] =
  shake_128(toInputRange(input))

proc shake_256(input: InputRange): Hash[256] =
  extShake256(addr(result.data), 256 div 8, input[0], input[1])

template shake_256*(input: typed): Hash[256] =
  shake_256(toInputRange(input))

