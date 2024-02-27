[![Actions Status](https://github.com/massa/Mmap-Native/actions/workflows/test.yml/badge.svg)](https://github.com/massa/Mmap-Native/actions)

NAME
====

Mmap::Native - interface to posix mmap() and mmunmap() calls

SYNOPSIS
========

```raku
use Mmap::Native;

my $f = $*CWD.add('META6.json'); $f = $f.open;
my $d = mmap Pointer, 50, PROT_READ, MAP_SHARED, $f.native-descriptor, 0;
my $e = blob-from-pointer $d, :50elems, :type(Buf[uint8]);

is $e.decode('utf8'), /'"auth": "zef:massa"'/;
```

DESCRIPTION
===========

Mmap::Native is a raw interface to the C library `mmap` and `munmap` calls.

It's mostly used for mmaping `Blob` objects and other raw C pointers. It's recommended that the library using it present a most Raku-esque interface and hide the `mmap`ping altogether. This is just a low level library.

CONSTANTS
=========

FUNCTIONS
=========

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

Creates a new mapping in the virtual address space of the calling process. The starting address for the new mapping is specified in `$addr`. The `$length` argument specifies the length of the mapping (which must be greater than 0). If `$addr` is undefined, then the kernel chooses the (page-aligned) address at which to create the mapping; this is the most portable method of creating a new mapping. If `$addr` is defined, then the kernel takes it as a hint about where to place the mapping; on Linux, the kernel will pick a nearby page boundary and attempt to create the mapping there. If another mapping already exists there, the kernel picks a new address that may or may not depend on the hint. The address of the new mapping is returned as the result of the call. The contents of a file mapping are initialized using length bytes starting at offset `$offset` in the file (or other object) referred to by the file descriptor `$fd`. `$offset` must be a multiple of the page size. After the `mmap()` call has returned, the file descriptor, `$fd`, can be closed immediately without invalidating the mapping. The `$prot` argument describes the desired memory protection of the mapping (and must not conflict with the open mode of the file).

### sub munmap

```raku
sub munmap(
    NativeCall::Types::Pointer $addr is rw,
    uint64 $len
) returns uint64
```

Deletes the mappings for the specified address range, and causes further references to addresses within the range to generate invalid memory references. The region is also automatically unmapped when the process is terminated. On the other hand, closing the file descriptor does not unmap the region. The address `$addr` must be a multiple of the page size (but `$length` need not be). All pages containing a part of the indicated range are unmapped, and subsequent references to these pages will generate `SIGSEGV`. It is not an error if the indicated range does not contain any mapped pages.

AUTHOR
======

Humberto Massa `humbertomassa@gmail.com`

COPYRIGHT AND LICENSE
=====================

Copyright 2024 Humberto Massa

This library is free software; you can redistribute it and/or modify it under either the Artistic License 2.0 or the LGPL v3.0, at your convenience.

