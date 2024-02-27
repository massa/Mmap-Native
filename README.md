NAME
====

Mmap::Native - interface to posix mmap() and mmunmap() calls

SYNOPSIS
========

```raku
use Mmap::Native;

=begin comment
mmap my Str $foo, 0, PROT_READ, MAP_SHARED, FILEHANDLE;
my @tags = $foo =~ /<(.*?)>/g;
munmap $foo;
=end comment

my $f = $*CWD.add('META6.json'); $f = $f.open;
my $d = mmap Pointer, 50, PROT_READ, MAP_SHARED, $f.native-descriptor, 0;
my $e = blob-from-pointer $d, :50elems, :type(Buf[uint8]);

is $e.decode('utf8'), /'"auth": "zef:massa"'/;
```

DESCRIPTION
===========

Mmap::Native is ...

### sub mmap

```raku
sub mmap(
    NativeCall::Types::Pointer $addr is rw,
    uint64 $len,
    int64 $prot,
    int64 $flags,
    int64 $fd,
    int64 $offset
) returns NativeCall::Types::Pointer
```

page can be read page can be written page can be executed page may be used for atomic ops page can not be accessed mprotect flag: extend change to start of growsdown vma mprotect flag: extend change to end of growsup vma Share changes Changes are private share + validate extension flags Mask for type of mapping Interpret addr exactly don't use a file stack-like segment ETXTBSY mark it as an executable pages are locked don't check for reservations populate (prefault) pagetables do not block on IO give out an address that is best suited for process/thread stacks create a huge page mapping perform synchronous page faults for the mapping MAP_FIXED which doesn't unmap underlying mapping For anonymous mmap, memory could be * uninitialized Lock pages in range after they are faulted in, do not prefault sync memory asynchronously invalidate the caches synchronous memory sync no further special treatment expect random page references expect sequential page references will need these pages don't need these pages free pages only if memory pressure remove these pages & resources don't inherit across fork do inherit across fork poison a page for testing soft offline page for testing KSM may merge identical pages KSM may not merge identical pages Worth backing with hugepages Not worth backing with hugepages Explicity exclude from the core dump, overrides the coredump filter bits Clear the MADV_DONTDUMP flag Zero memory on fork, child only Undo MADV_WIPEONFORK deactivate these pages reclaim these pages populate (prefault) page tables readable populate (prefault) page tables writable like DONTNEED, but drop locked pages too Synchronous hugepage collapse mmap

### sub munmap

```raku
sub munmap(
    NativeCall::Types::Pointer $addr is rw,
    uint64 $len
) returns uint64
```

mmunmap

AUTHOR
======

Humberto Massa <humbertomassa@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2024 Humberto Massa

This library is free software; you can redistribute it and/or modify it under either the Artistic License 2.0 or the LGPL v3.0, at your convenience.

