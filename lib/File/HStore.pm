package File::HStore;

use strict;
use warnings;
use Digest::SHA1;
use File::Copy;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);


our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


sub new {

    my ( $this, $path ) = @_;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;

    if (defined($path)) {
	$self->{path} = $path;
    } else {
	$self->{path} = "~/.hstore";
    }

    if (!(-e $self->{path})) {
	mkdir ($self->{path}) or die "Unable to create directory : $self->{path}";
    }

    return $self;
}

sub add {

    my ( $self, $filename ) = @_;

    my $localDigest = DigestAFile("$filename") or die "Unable to digest the file $filename";
    my $localSubDir = substr ($localDigest,0,2);
    my $SSubDir = $self->{path}."/".$localSubDir;

    if (!(-e $SSubDir)){
        mkdir $SSubDir or die "Unable to create subdir $SSubDir in the hstore";
    }

    my $destStoredFile = $SSubDir."/".$localDigest;

    copy($filename,$destStoredFile) or die "Unable to copy file into hstore as $destStoredFile";

    return $localDigest;
}

sub remove {

    my ( $self, $id ) = @_;

    if (!(defined($id))) {die "hash to be removed not defined";}

    my $localSubDir = substr ($id,0,2);
    my $SSubDir = $self->{path}."/".$localSubDir;
    my $destStoredFile = $SSubDir."/".$id;

    if (-e $destStoredFile ) {
	unlink ($destStoredFile) or die "Unable to delete file from hstore named $destStoredFile";
	return -1;
    } else {
	return;
    }

}

sub printPath {
    my ( $self ) = @_;

    return $self->{path};

}

sub DigestAFile {

    my $file = shift;
    my $sha;
    open (FILED,"$file") or die "Unable to open file $file";
    $sha = Digest::SHA1->new;
    $sha->addfile(*FILED);
    close (FILED);
    return  my $digest = $sha->hexdigest;

}


1;
__END__


=head1 NAME

File::HStore - Perl extension to store files  on a filesystem using a
    very simple hash-based storage.

=head1 SYNOPSIS

  use File::HStore;
  my $store = File::HStore ("/tmp/.mystore");
  
  my $id = $store->add("/foo/bar.txt");

  $store->remove("ff3b73dd85beeaf6e7b34d678ab2615c71eee9d5")

=head1 DESCRIPTION

File-HStore  is a very  minimalist perl  library to  store files  on a
filesystem using a very simple hash-based storage.

File-HStore  is nothing  more than  a  simple wrapper  interface to  a
storage containing a specific directory structure where files are hold
based on  their hashes. The  name of the  directories is based  on the
first two  bytes of the  hexadecimal form of  the digest. The  file is
stored and named  with its full hexadecimal form  in the corresponding
prefixed directory.

The current version is supporting the SHA-1 algorithm.

=head1 METHODS

The object oriented interface to C<File::HFile> is described in this
section.  

The following methods are provided:

=item $store = File::HStore->new($path)

This constructor returns a new C<File::HFile> object encapsulating a
specific store. The path specifies where the HStore is located on the
filesystem. If the path is not specified, the path ~/.hstore is used.

=item $store->add($filename)

The $filename is the file to be added in the store. The return value
is the hash value of the $filename stored. Return -1 on error.


=item $store->remove($hashvalue)

The $hashvalue is the file to be removed from the store. Return value
0 on success and -1 on error.

=head1 SEE ALSO

There is a web page for the File::HStore module at the following
location : http://www.foo.be/hstore/

If you plan to use a hash-based storage (like File::HStore), don't
    forget to read the following paper and check the impact for your
    application :

An Analysis of Compare-by-hash -
http://www.usenix.org/events/hotos03/tech/full_papers/henson/henson.pdf

=head1 AUTHOR

Alexandre "adulau" Dulaunoy, E<lt>adulau@foo.beE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004,2005 by Alexandre Dulaunoy <adulau@uucp.foo.be>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.


=cut
