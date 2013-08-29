use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

my %BUILD_DEPS;
my %TEST_DEPS = (
  'Test::More' => 0.94,
  'Test::Fatal' => 0.003,
);
my %RUN_DEPS;

my $mymeta = do { no warnings; $ExtUtils::MakeMaker::VERSION >= 6.57_02 };
my $mymeta_works = do { no warnings; $ExtUtils::MakeMaker::VERSION >= 6.57_07 };
my $has_test_requires = do { no warnings; $ExtUtils::MakeMaker::VERSION >= 6.63_03 };
if (not $has_test_requires) {
  %BUILD_DEPS = (%BUILD_DEPS, %TEST_DEPS);
  %TEST_DEPS = ();
}
if (not $mymeta_works) {
  %RUN_DEPS = (%RUN_DEPS, %BUILD_DEPS);
  %BUILD_DEPS = ();
}

WriteMakefile(
  NAME => 'Class::Method::Modifiers',
  VERSION_FROM => 'lib/Class/Method/Modifiers.pm',
  LICENSE => 'perl',

  keys %RUN_DEPS   ? ( PREREQ_PM      => \%RUN_DEPS   ) : (),
  keys %BUILD_DEPS ? ( BUILD_REQUIRES => \%BUILD_DEPS ) : (),
  keys %TEST_DEPS  ? ( TEST_REQUIRES  => \%TEST_DEPS  ) : (),

  META_MERGE => {
    'meta-spec' => { version => 2 },
    dynamic_config => 0,
    repository => {
      url => 'git://github.com/karenetheridge/Class-Method-Modifiers.git',
      web => 'http://github.com/karenetheridge/Class-Method-Modifiers',
      type => 'git',
    },
    bugtracker => {
      web => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Class-Method-Modifiers',
      mailto => 'bug-Class-Method-Modifiers@rt.cpan.org',
    },
    prereqs => {
      runtime   => { requires => { perl => '5.006' } },
      develop   => { requires => {
        'Class::MOP' => 0,
      } },
    },
  },
  ($mymeta && !$mymeta_works ? (NO_MYMETA => 1) : ()),
);
