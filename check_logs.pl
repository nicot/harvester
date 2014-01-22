#!/usr/bin/env perl

# stick to solaris 8's default perl version for development
use v5.6.1;
# help keep our code clean and portable
use strict;
use warnings;
use Getopt::Long::Descriptive;

######################
## Argument parsing
# Read in options
my ($opt, $usage) = describe_options(
  'check_logs.pl %o',
  [ 'output_format=s', "valid options are 'nagios', 'email', and 'details'", { required => 1 }],
  [ 'help|h', "prints usage message" ]
);
print($usage->text), exit if $opt->help;

my $output_format = $opt->output_format;
# Looks like Perl switch statements are currently an "experimental feature", so I'll go with an if/else
if ($output_format eq 'nagios') {
  use constant {
    OK        => 0,
    WARNING   => 1,
    CRITICAL  => 2,
    UNKNOWN   => 3,
  };
} elsif ($output_format eq 'email') {

} elsif ($output_format eq 'details') {

} else { 
  print $usage->text;
  exit;
}
# end argument parsing
######################

# for reflecting function names from references
use B qw(svref_2object);

# our config
use logcheck_config qw(load_config);

# main
package main;


# returns a hash reference of matcher => matcher result
sub match_file {
  # a string filename
  my $file     = shift;
  # an array reference to an array of matchers
  my $matchers = shift;
  
  # load the file
  open(my $filehandle, '<', $file) or die "error opening $file: $!";
  my $contents = do { local $/; <$filehandle> };

  my $results = {};

  # loop through and apply matchers
  foreach (@$matchers) {
    my $matcher = $_;
    # calculate function name from reference
    my $cv = svref_2object($matcher);
    my $gv = $cv->GV;
    my $name = $gv->NAME;
    # run matcher
    $results->{$name} = $matcher->($contents);
  }

  return $results;
}

# returns a hash reference of filename => matcher results
sub process_files {
  # an array reference to a list of filenames
  my $files = shift;
  # an array reference of matchers to run
  my $matchers = shift;
  
  my $results = {};

  # process the files one at a time in case they're really big
  foreach (@$files) {
    my $file = $_;
    $results->{$file} = match_file($file, $matchers);
  }

  return $results
}

# pretty prints a %results hash
sub format_pretty {
  my $results = shift;
  my $output = '';
  while (my ($key, $value) = each(%$results)) {                                   
    $output .= "$key:\n";
    while (my ($k, $v) = each (%$value)) {                                        
      $output .= "  $k found:\n";
      foreach (@{$v}) {
        my $line = $_;
        # indent multiline lines in the matched input
        $line =~ s/\n/\n  /gm;
        $output .= "    $line\n";
      }
    }
    $output .= "\n";
  }
  return $output;
}

# merges results from multiple logwatchers
sub merge_results {
}

my $configs = load_config;

foreach (@{$configs}) {
  my $config = $_;
  my $results = process_files($config->files, $config->matchers);
  my ($status, $output) = $config->responder->($results);

  while (my ($key, $value) = each(%$results)) {
    print "$key:\n";
    while (my ($k, $v) = each (%$value)) {
      my $vs = join('|', @{$v});
      print "  $k\t=>\t$vs\n";
    }
  }

  print "\n\nexit $status\n";
  print "$output\n";
}

1;

# TODO: add the log chunking stuff
# TODO: add the nagios exit status stuff
# TODO: handle multiple loadchecks in a config (match any)
# TODO: add multiline output
# TODO: sort and standardify output
