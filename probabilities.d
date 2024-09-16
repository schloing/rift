import std.stdio;
import std.algorithm;
import std.file : dirEntries, DirEntry, SpanMode;

enum ubyte[ubyte] opcodeArgs = [
    0x90 : 0,  // NOP (No arguments)

    // Data movement
    0x88 : 2,  // MOV r/m8, r8 (2 arguments: register/memory, register)
    0x89 : 2,  // MOV r/m32, r32 (2 arguments: register/memory, register)
    0x8A : 2,  // MOV r8, r/m8 (2 arguments: register, register/memory)
    0x8B : 2,  // MOV r32, r/m32 (2 arguments: register, register/memory)
    0xB0 : 1,  // MOV AL, imm8 (1 argument: immediate value)
    0xB8 : 1,  // MOV r32, imm32 (1 argument: immediate value)

    // Stack operations
    0x50 : 0,  // PUSH rax (No arguments, implicit register)
    0x51 : 0,  // PUSH rcx (No arguments, implicit register)
    0x52 : 0,  // PUSH rdx (No arguments, implicit register)
    0x58 : 0,  // POP rax (No arguments, implicit register)
    0x59 : 0,  // POP rcx (No arguments, implicit register)
    0x5A : 0,  // POP rdx (No arguments, implicit register)

    // Arithmetic
    0x01 : 2,  // ADD r/m32, r32 (2 arguments: register/memory, register)
    0x29 : 2,  // SUB r/m32, r32 (2 arguments: register/memory, register)
    0x83 : 2,  // ADD/SUB/etc r/m32, imm8 (2 arguments: register/memory, immediate)
    0xF7 : 2,  // MUL/DIV/etc r/m32 (can be more specific by decoding ModR/M byte)

    // Logical
    0x21 : 2,  // AND r/m32, r32 (2 arguments: register/memory, register)
    0x31 : 2,  // XOR r/m32, r32 (2 arguments: register/memory, register)
    0x85 : 2,  // TEST r/m32, r32 (2 arguments: register/memory, register)

    // Control flow
    0xC3 : 0,  // RET (No arguments)
    0xE8 : 1,  // CALL rel32 (1 argument: relative address)
    0xE9 : 1,  // JMP rel32 (1 argument: relative address)
    0xEB : 1,  // JMP rel8 (1 argument: relative address)

    // Conditional jumps
    0x74 : 1,  // JE rel8 (1 argument: relative address)
    0x75 : 1,  // JNE rel8 (1 argument: relative address)
    0x7C : 1,  // JL rel8 (1 argument: relative address)
    0x7D : 1,  // JGE rel8 (1 argument: relative address)
    0x7F : 1,  // JG rel8 (1 argument: relative address)

    // Miscellaneous
    0xCD : 1,  // INT imm8 (1 argument: immediate interrupt number)
    0xF4 : 0,  // HLT (No arguments)
    0xF5 : 0,  // CMC (No arguments)
    0xFA : 0,  // CLI (No arguments)
    0xFB : 0,  // STI (No arguments)
];

int[ubyte] aa;

void processBinary(string path)
{
    auto bin = File(path, "rb");
    scope(exit) bin.close();

    foreach (ubyte[] buffer; bin.byChunk(new ubyte[4096]))
    {
        foreach (int i; 0..cast(int)buffer.length - 1)
        {
            ubyte op = buffer[i];

            aa[op]++;

            i += opcodeArgs.get(op, 0);
        }
    }
}

void main()
{
    processBinary("/usr/bin/touch");

    /*
    foreach (DirEntry e; dirEntries("/usr/bin", SpanMode.shallow))
    {
        if (e.isDir) continue;
        processBinary(e.name);
    }
    */

    writeln(aa);
}
