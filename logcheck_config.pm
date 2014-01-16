package logcheck_config;
use strict;
use warnings;

# get the logcheck class
use logcheck;

use constant {
  FOO_LOG => 'foo.log',
  BAR_LOG => 'bar.log',
};

# define what's okay to export                                                  
require Exporter;                                                               
our @ISA       = qw(Exporter);                                                   
our @EXPORT_OK = qw(load_config);      

sub doggy_problems {
  my @matches = ($_[0] =~ /^.*doggy.*$/igm);
  return \@matches;
}

sub disaster {
  my @matches = ($_[0] =~ /^.*disaster.*$/igm);
  return \@matches;
}

# multi-line example
sub illegal_java_state {
  my @matches = ($_[0] =~ /^java.lang.IllegalStateException.*\n(?:\s+.*\n)*/igm);
  return \@matches;
}

# non-regex multiline example
sub awkward_multiline {
  my $input = $_[0];
  my @matches = ();
  my @match = ();
  my $matching = 0;
  foreach (split(/\n/, $input)) {
    my $line = $_;
    if ($line =~ m/awkward/i) {
      $matching = 1;
    }
    push @match, $line if $matching;
    if ($line =~ m/^0$/) {
      $matching = 0;
      push @matches, \@match;
      @match = ();
    }
  }
  return \@matches;
}

sub load_config {
  my @log_checkers = (); 

  my @files     = (FOO_LOG, BAR_LOG);
  my @matchers  = (\&doggy_problems, \&disaster, \&awkward_multiline);
  push(@log_checkers, (new logcheck(\@files, \@matchers, \&logcheck::anymatch)));

  push(@log_checkers, (new logcheck([BAR_LOG], [\&illegal_java_state], \&logcheck::anymatch)));
                    
  return \@log_checkers; #(new logcheck(\@files, \@matchers, \&logcheck::anymatch));
}

1;

# TODO
#deal with multiple logcheck definitions
#move files to proper paths and ensure use works
# TODO
# define all checks in the disted perl module
# if no local config, define default checks to run and files
# local config can add or remove but not override global defaults
# warn about added/disabled checks that don't exist
# no local check definitions!
# how do you handle issues where the file names are different but the checks are the same?
