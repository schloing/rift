import std.stdio;
import std.file;

struct Instruction {
    ulong addr;
    const(ubyte[]) bytes;
}

interface Architecture {
    Instruction decode(ubyte b);
    void human(ref Instruction ins);
}

class Arch_x86(int bits) : Architecture {
    ulong pc, bp, sp;

    Instruction decode(ubyte b) {
        auto ins = Instruction(this.pc++, [b]);

        switch (b) {
        default:
            ins.addr = 0;
            writeln("???");
            break;
        }

        return ins;
    }

    void human(ref Instruction ins) {

    }
}

void disasm(ref File bin) {
    auto cpu = new Arch_x86!64;

    foreach (buffer; bin.byChunk(new ubyte[4096]))
    {
        foreach (ref ubyte b; buffer)
        {
            Instruction ins = cpu.decode(b);
            cpu.human(ins);
        }
    }
}

void main(string[] args) {
    if (args.length < 2) {
        writeln("usage: rift <opts> <binary>");
        return;
    }

    string binpath = args[1];
    auto bin = File(binpath, "rb");
    scope(exit) bin.close();

    disasm(bin);
}
