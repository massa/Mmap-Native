unit class Mmap::Native;

=begin pod

=head1 NAME

Mmap::Native - interface to posix mmap() and mmunmap()  calls

=head1 SYNOPSIS

=begin code :lang<raku>

use Mmap::Native;

my $f = $*CWD.add('META6.json'); $f = $f.open;
my $d = mmap Pointer, 50, PROT_READ, MAP_SHARED, $f.native-descriptor, 0;
my $e = blob-from-pointer $d, :50elems, :type(Buf[uint8]);

is $e.decode('utf8'), /'"auth": "zef:massa"'/;

=end code

=begin comment
mmap my Str $foo, 0, PROT_READ, MAP_SHARED, FILEHANDLE;
my @tags = $foo =~ /<(.*?)>/g;
munmap $foo;
=end comment

=head1 DESCRIPTION

Mmap::Native is a raw interface to the C library C<mmap> and C<munmap> calls.

It's mostly used for mmaping C<Blob> objects and other raw C pointers. It's recommended that the
library using it present a most Raku-esque interface and hide the C<mmap>ping altogether. This
is just a low level library.

=head1 CONSTANTS

Remember to always use C<+|> to combine flag values!

### The `$prot` argument flags

Describes the desired memory protection of the mapping (and must not conflict with the open mode of the file). It is either PROT_NONE or the bitwise OR of one or more of the following flags:

=begin table
Flag | Description
==================
PROT_READ |  page can be read
PROT_WRITE |  page can be written
PROT_EXEC |  page can be executed
PROT_SEM |  page may be used for atomic ops
PROT_NONE |  page can not be accessed
PROT_GROWSDOWN |  mprotect flag: extend change to start of growsdown vma
PROT_GROWSUP |  mprotect flag: extend change to end of growsup vma
=end table

### The `$flags` argument

Determines whether updates to the mapping are visible to other processes mapping the same region, and whether updates are carried through to the underlying file.  This behavior is determined by including exactly one of the following values:

=begin table
Flag | Description
==================
MAP_SHARED |  Share changes
MAP_PRIVATE |  Changes are private
MAP_SHARED_VALIDATE |  share and validate extension flags
MAP_TYPE |  Mask for type of mapping
MAP_FIXED |  Interpret addr exactly
MAP_ANONYMOUS |  don't use a file
MAP_GROWSDOWN |  stack-like segment
MAP_DENYWRITE |  ETXTBSY
MAP_EXECUTABLE |  mark it as an executable
MAP_LOCKED |  pages are locked
MAP_NORESERVE |  don't check for reservations
MAP_POPULATE |  populate (prefault) pagetables
MAP_NONBLOCK |  do not block on IO
MAP_STACK |  give out an address that is best suited for process/thread stacks
MAP_HUGETLB |  create a huge page mapping
MAP_SYNC |  perform synchronous page faults for the mapping
MAP_FIXED_NOREPLACE |  MAP_FIXED which doesn't unmap underlying mapping
MAP_UNINITIALIZED |  For anonymous mmap, memory could be * uninitialized
MLOCK_ONFAULT |  Lock pages in range after they are faulted in, do not prefault
MS_ASYNC |  sync memory asynchronously
MS_INVALIDATE |  invalidate the caches
MS_SYNC |  synchronous memory sync
MADV_NORMAL |  no further special treatment
MADV_RANDOM |  expect random page references
MADV_SEQUENTIAL |  expect sequential page references
MADV_WILLNEED |  will need these pages
MADV_DONTNEED |  don't need these pages
MADV_FREE |  free pages only if memory pressure
MADV_REMOVE |  remove these pages & resources
MADV_DONTFORK |  don't inherit across fork
MADV_DOFORK |  do inherit across fork
MADV_HWPOISON |  poison a page for testing
MADV_SOFT_OFFLINE |  soft offline page for testing
MADV_MERGEABLE |  KSM may merge identical pages
MADV_UNMERGEABLE |  KSM may not merge identical pages
MADV_HUGEPAGE |  Worth backing with hugepages
MADV_NOHUGEPAGE |  Not worth backing with hugepages
MADV_DONTDUMP |  Explicity exclude from the core dump, overrides the coredump filter bits
MADV_DODUMP |  Clear the MADV_DONTDUMP flag
MADV_WIPEONFORK |  Zero memory on fork, child only
MADV_KEEPONFORK |  Undo MADV_WIPEONFORK
MADV_COLD |  deactivate these pages
MADV_PAGEOUT |  reclaim these pages
MADV_POPULATE_READ |  populate (prefault) page tables readable
MADV_POPULATE_WRITE |  populate (prefault) page tables writable
MADV_DONTNEED_LOCKED |  like DONTNEED, but drop locked pages too
MADV_COLLAPSE |  Synchronous hugepage collapse
=end table

=end pod

use NativeCall;
use NativeCall::Types;

constant PROT_READ is export = 0x1; #= page can be read
constant PROT_WRITE is export = 0x2; #= page can be written
constant PROT_EXEC is export = 0x4; #= page can be executed
constant PROT_SEM is export = 0x8; #= page may be used for atomic ops

constant PROT_NONE is export = 0x0; #= page can not be accessed
constant PROT_GROWSDOWN is export = 0x01000000; #= mprotect flag: extend change to start of growsdown vma
constant PROT_GROWSUP is export = 0x02000000; #= mprotect flag: extend change to end of growsup vma

constant MREMAP_MAYMOVE is export = 1;
constant MREMAP_FIXED is export = 2;
constant MREMAP_DONTUNMAP is export = 4;

constant OVERCOMMIT_GUESS is export = 0;
constant OVERCOMMIT_ALWAYS is export = 1;
constant OVERCOMMIT_NEVER is export = 2;

constant MAP_SHARED is export = 0x01; #= Share changes
constant MAP_PRIVATE is export = 0x02; #= Changes are private
constant MAP_SHARED_VALIDATE is export = 0x03; #= share + validate extension flags

constant MAP_TYPE is export = 0x0f; #= Mask for type of mapping
constant MAP_FIXED is export = 0x10; #= Interpret addr exactly
constant MAP_ANONYMOUS is export = 0x20; #= don't use a file

constant MAP_GROWSDOWN is export = 0x0100; #= stack-like segment
constant MAP_DENYWRITE is export = 0x0800; #= ETXTBSY
constant MAP_EXECUTABLE is export = 0x1000; #= mark it as an executable
constant MAP_LOCKED is export = 0x2000; #= pages are locked
constant MAP_NORESERVE is export = 0x4000; #= don't check for reservations

constant MAP_POPULATE is export = 0x008000; #= populate (prefault) pagetables
constant MAP_NONBLOCK is export = 0x010000; #= do not block on IO
constant MAP_STACK is export = 0x020000; #= give out an address that is best suited for process/thread stacks
constant MAP_HUGETLB is export = 0x040000; #= create a huge page mapping
constant MAP_SYNC is export = 0x080000; #= perform synchronous page faults for the mapping
constant MAP_FIXED_NOREPLACE is export = 0x100000; #= MAP_FIXED which doesn't unmap underlying mapping

constant MAP_UNINITIALIZED is export = 0x4000000; #= For anonymous mmap, memory could be * uninitialized

constant MLOCK_ONFAULT is export = 0x01; #= Lock pages in range after they are faulted in, do not prefault

constant MS_ASYNC is export = 1; #= sync memory asynchronously
constant MS_INVALIDATE is export = 2; #= invalidate the caches
constant MS_SYNC is export = 4; #= synchronous memory sync

constant MADV_NORMAL is export = 0; #= no further special treatment
constant MADV_RANDOM is export = 1; #= expect random page references
constant MADV_SEQUENTIAL is export = 2; #= expect sequential page references
constant MADV_WILLNEED is export = 3; #= will need these pages
constant MADV_DONTNEED is export = 4; #= don't need these pages

constant MADV_FREE is export = 8; #= free pages only if memory pressure
constant MADV_REMOVE is export = 9; #= remove these pages & resources
constant MADV_DONTFORK is export = 10; #= don't inherit across fork
constant MADV_DOFORK is export = 11; #= do inherit across fork
constant MADV_HWPOISON is export = 100; #= poison a page for testing
constant MADV_SOFT_OFFLINE is export = 101; #= soft offline page for testing

constant MADV_MERGEABLE is export = 12; #= KSM may merge identical pages
constant MADV_UNMERGEABLE is export = 13; #= KSM may not merge identical pages

constant MADV_HUGEPAGE is export = 14; #= Worth backing with hugepages
constant MADV_NOHUGEPAGE is export = 15; #= Not worth backing with hugepages

constant MADV_DONTDUMP is export = 16; #= Explicity exclude from the core dump, overrides the coredump filter bits
constant MADV_DODUMP is export = 17; #= Clear the MADV_DONTDUMP flag

constant MADV_WIPEONFORK is export = 18; #= Zero memory on fork, child only
constant MADV_KEEPONFORK is export = 19; #= Undo MADV_WIPEONFORK

constant MADV_COLD is export = 20; #= deactivate these pages
constant MADV_PAGEOUT is export = 21; #= reclaim these pages

constant MADV_POPULATE_READ is export = 22; #= populate (prefault) page tables readable
constant MADV_POPULATE_WRITE is export = 23; #= populate (prefault) page tables writable

constant MADV_DONTNEED_LOCKED is export = 24; #= like DONTNEED, but drop locked pages too

constant MADV_COLLAPSE is export = 25; #= Synchronous hugepage collapse

constant MAP_FILE is export = 0;
constant MAP_FAILED is export = Pointer[void].new: -1;

constant PKEY_DISABLE_ACCESS is export = 0x1;
constant PKEY_DISABLE_WRITE is export = 0x2;
constant PKEY_ACCESS_MASK is export = (PKEY_DISABLE_ACCESS |+ PKEY_DISABLE_WRITE);

=begin pod

=head1 FUNCTIONS

=end pod

#|{
       Creates a new mapping in the virtual address space of the
       calling process.  The starting address for the new mapping is
       specified in `$addr`.  The `$length` argument specifies the length of
       the mapping (which must be greater than 0).

       If `$addr` is undefined, then the kernel chooses the (page-aligned)
       address at which to create the mapping; this is the most portable
       method of creating a new mapping.  If `$addr` is defined, then the
       kernel takes it as a hint about where to place the mapping; on
       Linux, the kernel will pick a nearby page boundary and attempt to create the mapping
       there.  If another mapping already exists there, the kernel picks
       a new address that may or may not depend on the hint.  The
       address of the new mapping is returned as the result of the call.

       The contents of a file mapping are initialized using length
       bytes starting at offset `$offset` in the file (or other object)
       referred to by the file descriptor `$fd`.  `$offset` must be a multiple
       of the page size.

       After the `mmap()` call has returned, the file descriptor, `$fd`, can
       be closed immediately without invalidating the mapping.

       The `$prot` argument describes the desired memory protection of the
       mapping (and must not conflict with the open mode of the file).
}
sub mmap(Pointer $addr is rw, uint64 $len, int64 $prot, int64 $flags, int64 $fd, int64 $offset --> Pointer) is native is export { * }

#|{
       Deletes the mappings for the specified
       address range, and causes further references to addresses within
       the range to generate invalid memory references.  The region is
       also automatically unmapped when the process is terminated.  On
       the other hand, closing the file descriptor does not unmap the
       region.

       The address `$addr` must be a multiple of the page size (but `$length`
       need not be).  All pages containing a part of the indicated range
       are unmapped, and subsequent references to these pages will
       generate `SIGSEGV`.  It is not an error if the indicated range does
       not contain any mapped pages.
}
sub munmap(Pointer $addr is rw, uint64 $len --> uint64) is native is export { * }

=begin pod

=head1 AUTHOR

Humberto Massa `humbertomassa@gmail.com`

=head1 COPYRIGHT AND LICENSE

Copyright © 2024 Humberto Massa

This library is free software; you can redistribute it and/or modify it under either the Artistic License 2.0 or the LGPL v3.0, at your convenience.

=end pod

