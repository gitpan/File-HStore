use 5.008005;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'File::HStore',
    VERSION_FROM      => 'lib/File/HStore.pm', # finds $VERSION
    PREREQ_PM         => { Digest::SHA1, Digest::SHA2, File::Copy }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/File/HStore.pm', # retrieve abstract from module
       AUTHOR         => 'Alexandre Dulaunoy <adulau@foo.be>') : ()),
);
