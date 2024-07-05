[![Actions Status](https://github.com/massa/Mmap-Native/actions/workflows/linux.yml/badge.svg)](https://github.com/massa/Mmap-Native/actions) [![Actions Status](https://github.com/massa/Mmap-Native/actions/workflows/macos.yml/badge.svg)](https://github.com/massa/Mmap-Native/actions)

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

Remember to always use `+|` to combine flag values!

### The `$prot` argument flags

Describes the desired memory protection of the mapping (and must not conflict with the open mode of the file). It is either PROT_NONE or the bitwise OR of one or more of the following flags:

<table class="pod-table">
<thead><tr>
<th>Flag</th> <th>Description</th>
</tr></thead>
<tbody>
<tr> <td>PROT_READ</td> <td>page can be read</td> </tr> <tr> <td>PROT_WRITE</td> <td>page can be written</td> </tr> <tr> <td>PROT_EXEC</td> <td>page can be executed</td> </tr> <tr> <td>PROT_SEM</td> <td>page may be used for atomic ops</td> </tr> <tr> <td>PROT_NONE</td> <td>page can not be accessed</td> </tr> <tr> <td>PROT_GROWSDOWN</td> <td>mprotect flag: extend change to start of growsdown vma</td> </tr> <tr> <td>PROT_GROWSUP</td> <td>mprotect flag: extend change to end of growsup vma</td> </tr>
</tbody>
</table>

### The `$flags` argument

Determines whether updates to the mapping are visible to other processes mapping the same region, and whether updates are carried through to the underlying file. This behavior is determined by including exactly one of the following values:

<table class="pod-table">
<thead><tr>
<th>Flag</th> <th>Description</th>
</tr></thead>
<tbody>
<tr> <td>MAP_SHARED</td> <td>Share changes</td> </tr> <tr> <td>MAP_PRIVATE</td> <td>Changes are private</td> </tr> <tr> <td>MAP_SHARED_VALIDATE</td> <td>share and validate extension flags</td> </tr> <tr> <td>MAP_TYPE</td> <td>Mask for type of mapping</td> </tr> <tr> <td>MAP_FIXED</td> <td>Interpret addr exactly</td> </tr> <tr> <td>MAP_ANONYMOUS</td> <td>don&#39;t use a file</td> </tr> <tr> <td>MAP_GROWSDOWN</td> <td>stack-like segment</td> </tr> <tr> <td>MAP_DENYWRITE</td> <td>ETXTBSY</td> </tr> <tr> <td>MAP_EXECUTABLE</td> <td>mark it as an executable</td> </tr> <tr> <td>MAP_LOCKED</td> <td>pages are locked</td> </tr> <tr> <td>MAP_NORESERVE</td> <td>don&#39;t check for reservations</td> </tr> <tr> <td>MAP_POPULATE</td> <td>populate (prefault) pagetables</td> </tr> <tr> <td>MAP_NONBLOCK</td> <td>do not block on IO</td> </tr> <tr> <td>MAP_STACK</td> <td>give out an address that is best suited for process/thread stacks</td> </tr> <tr> <td>MAP_HUGETLB</td> <td>create a huge page mapping</td> </tr> <tr> <td>MAP_SYNC</td> <td>perform synchronous page faults for the mapping</td> </tr> <tr> <td>MAP_FIXED_NOREPLACE</td> <td>MAP_FIXED which doesn&#39;t unmap underlying mapping</td> </tr> <tr> <td>MAP_UNINITIALIZED</td> <td>For anonymous mmap, memory could be * uninitialized</td> </tr> <tr> <td>MLOCK_ONFAULT</td> <td>Lock pages in range after they are faulted in, do not prefault</td> </tr> <tr> <td>MS_ASYNC</td> <td>sync memory asynchronously</td> </tr> <tr> <td>MS_INVALIDATE</td> <td>invalidate the caches</td> </tr> <tr> <td>MS_SYNC</td> <td>synchronous memory sync</td> </tr> <tr> <td>MADV_NORMAL</td> <td>no further special treatment</td> </tr> <tr> <td>MADV_RANDOM</td> <td>expect random page references</td> </tr> <tr> <td>MADV_SEQUENTIAL</td> <td>expect sequential page references</td> </tr> <tr> <td>MADV_WILLNEED</td> <td>will need these pages</td> </tr> <tr> <td>MADV_DONTNEED</td> <td>don&#39;t need these pages</td> </tr> <tr> <td>MADV_FREE</td> <td>free pages only if memory pressure</td> </tr> <tr> <td>MADV_REMOVE</td> <td>remove these pages &amp; resources</td> </tr> <tr> <td>MADV_DONTFORK</td> <td>don&#39;t inherit across fork</td> </tr> <tr> <td>MADV_DOFORK</td> <td>do inherit across fork</td> </tr> <tr> <td>MADV_HWPOISON</td> <td>poison a page for testing</td> </tr> <tr> <td>MADV_SOFT_OFFLINE</td> <td>soft offline page for testing</td> </tr> <tr> <td>MADV_MERGEABLE</td> <td>KSM may merge identical pages</td> </tr> <tr> <td>MADV_UNMERGEABLE</td> <td>KSM may not merge identical pages</td> </tr> <tr> <td>MADV_HUGEPAGE</td> <td>Worth backing with hugepages</td> </tr> <tr> <td>MADV_NOHUGEPAGE</td> <td>Not worth backing with hugepages</td> </tr> <tr> <td>MADV_DONTDUMP</td> <td>Explicity exclude from the core dump, overrides the coredump filter bits</td> </tr> <tr> <td>MADV_DODUMP</td> <td>Clear the MADV_DONTDUMP flag</td> </tr> <tr> <td>MADV_WIPEONFORK</td> <td>Zero memory on fork, child only</td> </tr> <tr> <td>MADV_KEEPONFORK</td> <td>Undo MADV_WIPEONFORK</td> </tr> <tr> <td>MADV_COLD</td> <td>deactivate these pages</td> </tr> <tr> <td>MADV_PAGEOUT</td> <td>reclaim these pages</td> </tr> <tr> <td>MADV_POPULATE_READ</td> <td>populate (prefault) page tables readable</td> </tr> <tr> <td>MADV_POPULATE_WRITE</td> <td>populate (prefault) page tables writable</td> </tr> <tr> <td>MADV_DONTNEED_LOCKED</td> <td>like DONTNEED, but drop locked pages too</td> </tr> <tr> <td>MADV_COLLAPSE</td> <td>Synchronous hugepage collapse</td> </tr>
</tbody>
</table>

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

Copyright © 2024 Humberto Massa

This library is free software; you can redistribute it and/or modify it under either the Artistic License 2.0 or the LGPL v3.0, at your convenience.

