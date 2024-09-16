import std.stdio;
import std.file;

struct Instruction {
    ulong addr;
    ref const(ubyte[]) bytes;
}

interface Architecture {
    Instruction decode(ubyte b);
}

class x86(int bits) : Architecture {
    ulong pc, bp, sp;

    Instruction decode(ubyte b) {
        return;
    }
}

void disasm(ref File bin) {
    auto cpu = new x86(64);

    foreach (buffer; bin.byChunk(new ubyte[4096]))
    {
        foreach (ref ubyte b; buffer)
        {
            cpu.decode(b);
        }
    }
}

void main(string[] args) {
    if (args.length < 2)
        return;

    string binpath = args[1];
    auto bin = File(binpath, "rb");
    scope(exit) bin.close();

    disasm(bin);
}
