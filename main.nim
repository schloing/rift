type
    Rift = object
        shorthand: int
        index:     int

when isMainModule:
    import std/os
    import std/memfiles
   
    if paramCount() < 0: quit -1

    let binPath = paramStr(1)

    let binary = memfiles.open(binPath)

    echo binary[0..4] == [0x7f, 'E'.byte, 'L'.byte, 'F'.byte]
