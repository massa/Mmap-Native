unit class Mmap::Native;


=begin pod

=head1 NAME

Mmap::Native - interface to posix mmap() and mmunmap()  calls

=head1 SYNOPSIS

=begin code :lang<raku>

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

=end code

=head1 DESCRIPTION

Mmap::Native is ...

=head1 CONSTANTS

=end pod

#| page can be read
constant PROT_READ is export = 0x1;
#| page can be written
constant PROT_WRITE is export = 0x2;
#| page can be executed
constant PROT_EXEC is export = 0x4;
#| page may be used for atomic ops
constant PROT_SEM is export = 0x8;


#| page can not be accessed
constant PROT_NONE is export = 0x0;
#| mprotect flag: extend change to start of growsdown vma
constant PROT_GROWSDOWN is export = 0x01000000;
#| mprotect flag: extend change to end of growsup vma
constant PROT_GROWSUP is export = 0x02000000;

constant MREMAP_MAYMOVE is export = 1;
constant MREMAP_FIXED is export = 2;
constant MREMAP_DONTUNMAP is export = 4;

constant OVERCOMMIT_GUESS is export = 0;
constant OVERCOMMIT_ALWAYS is export = 1;
constant OVERCOMMIT_NEVER is export = 2;

#| Share changes
constant MAP_SHARED is export = 0x01;
#| Changes are private
constant MAP_PRIVATE is export = 0x02;
#| share + validate extension flags
constant MAP_SHARED_VALIDATE is export = 0x03;

#| Mask for type of mapping
constant MAP_TYPE is export = 0x0f;
#| Interpret addr exactly
constant MAP_FIXED is export = 0x10;
#| don't use a file
constant MAP_ANONYMOUS is export = 0x20;

#| stack-like segment
constant MAP_GROWSDOWN is export = 0x0100;
#| ETXTBSY
constant MAP_DENYWRITE is export = 0x0800;
#| mark it as an executable
constant MAP_EXECUTABLE is export = 0x1000;
#| pages are locked
constant MAP_LOCKED is export = 0x2000;
#| don't check for reservations
constant MAP_NORESERVE is export = 0x4000;

#| populate (prefault) pagetables
constant MAP_POPULATE is export = 0x008000;
#| do not block on IO
constant MAP_NONBLOCK is export = 0x010000;
#| give out an address that is best suited for process/thread stacks
constant MAP_STACK is export = 0x020000;
#| create a huge page mapping
constant MAP_HUGETLB is export = 0x040000;
#| perform synchronous page faults for the mapping
constant MAP_SYNC is export = 0x080000;
#| MAP_FIXED which doesn't unmap underlying mapping
constant MAP_FIXED_NOREPLACE is export = 0x100000;

#| For anonymous mmap, memory could be * uninitialized
constant MAP_UNINITIALIZED is export = 0x4000000;

#| Lock pages in range after they are faulted in, do not prefault
constant MLOCK_ONFAULT is export = 0x01;

#| sync memory asynchronously
constant MS_ASYNC is export = 1;
#| invalidate the caches
constant MS_INVALIDATE is export = 2;
#| synchronous memory sync
constant MS_SYNC is export = 4;

#| no further special treatment
constant MADV_NORMAL is export = 0;
#| expect random page references
constant MADV_RANDOM is export = 1;
#| expect sequential page references
constant MADV_SEQUENTIAL is export = 2;
#| will need these pages
constant MADV_WILLNEED is export = 3;
#| don't need these pages
constant MADV_DONTNEED is export = 4;

#| free pages only if memory pressure
constant MADV_FREE is export = 8;
#| remove these pages & resources
constant MADV_REMOVE is export = 9;
#| don't inherit across fork
constant MADV_DONTFORK is export = 10;
#| do inherit across fork
constant MADV_DOFORK is export = 11;
#| poison a page for testing
constant MADV_HWPOISON is export = 100;
#| soft offline page for testing
constant MADV_SOFT_OFFLINE is export = 101;

#| KSM may merge identical pages
constant MADV_MERGEABLE is export = 12;
#| KSM may not merge identical pages
constant MADV_UNMERGEABLE is export = 13;

#| Worth backing with hugepages
constant MADV_HUGEPAGE is export = 14;
#| Not worth backing with hugepages
constant MADV_NOHUGEPAGE is export = 15;

#| Explicity exclude from the core dump, overrides the coredump filter bits
constant MADV_DONTDUMP is export = 16;
#| Clear the MADV_DONTDUMP flag
constant MADV_DODUMP is export = 17;

#| Zero memory on fork, child only
constant MADV_WIPEONFORK is export = 18;
#| Undo MADV_WIPEONFORK
constant MADV_KEEPONFORK is export = 19;

#| deactivate these pages
constant MADV_COLD is export = 20;
#| reclaim these pages
constant MADV_PAGEOUT is export = 21;

#| populate (prefault) page tables readable
constant MADV_POPULATE_READ is export = 22;
#| populate (prefault) page tables writable
constant MADV_POPULATE_WRITE is export = 23;

#| like DONTNEED, but drop locked pages too
constant MADV_DONTNEED_LOCKED is export = 24;

#| Synchronous hugepage collapse
constant MADV_COLLAPSE is export = 25;

constant MAP_FILE is export = 0;

constant PKEY_DISABLE_ACCESS is export = 0x1;
constant PKEY_DISABLE_WRITE is export = 0x2;
constant PKEY_ACCESS_MASK is export = (PKEY_DISABLE_ACCESS |+ PKEY_DISABLE_WRITE);

=begin pod

=head1 FUNCTIONS

=end pod

use NativeCall;
use NativeCall::Types;

#| mmap
sub mmap(Pointer $addr is rw, uint64 $len, int64 $prot, int64 $flags, int64 $fd, int64 $offset --> Pointer) is native is export { * }

#| mmunmap
sub munmap(Pointer $addr is rw, uint64 $len --> uint64) is native is export { * }

=begin pod

=head1 AUTHOR

Humberto Massa <humbertomassa@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2024 Humberto Massa

This library is free software; you can redistribute it and/or modify it under either the Artistic License 2.0 or the LGPL v3.0, at yconvenience.

=end pod


