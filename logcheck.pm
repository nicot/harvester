# create a class to hold log checking info
package logcheck;
# help keep our code clean and portable
use strict;
use warnings;

# define what's okay to export
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(new matchers responder allmatch newline2comma);

# constructor
sub new {
  # validate args
  if (scalar(@_) != 4) {
    die
      "error: not enough arguments provided to logcheck->new.\n" .
      "the following are required:\n" .

      "_files_ref:     array reference to a list of files to search\n" .
      "_matchers_ref:  array reference to a list of function references that define checks\n" .
      "_responder_ref: function reference that defines exit status based on matcher results\n";
  }

  # build the class
  my $class = shift;
  my $self = {
    # array reference to a list of files to search
    _files_ref     => shift,
    # array reference to a list of function references that define checks
    # to match against each file in _files_ref
    _matchers_ref  => shift,
    # function reference that defines exit status based on matcher results
    _responder_ref => shift,
  };
  # turn our anonymous hash, $self, into a class
  bless $self, $class;
  # return the class
  return $self;
}

sub files {
  my ($self) = @_;
  return $self->{_files_ref};
}

sub matchers {
  my ($self) = @_;
  return $self->{_matchers_ref};
}

sub responder {
  my ($self) = @_;
  return $self->{_responder_ref};
}

# convenient default responders

# all matchers must match
sub allmatch {
  return default_responder(1, $_[0]);
}

# any matcher must match
sub anymatch {
  return default_responder(0, $_[0]);
}

# private utility functions

# mode 1 = all must match
# mode 0 = any must match
sub default_responder {
  my $mode = shift;
  # a hash reference of the form {filename => {matcher => value}}
  my $results = shift;
  my $matching_results = {};
  my $status = $mode;
  while (my ($key, $value) = each(%$results)) {                                   
    while (my ($k, $v) = each (%$value)) {                                        
      # if there's at least one match
      if (scalar @{$v} > 0) {
        $status = 1 if ($mode == 0);
        if (not exists $matching_results->{$k}) {
          $matching_results->{$key} = {};
        }
        $matching_results->{$key}->{$k} = $v;
      } elsif ($mode > 0) {
        $status = 0;
      }
    }                                                                             
  }          
  return ($status, $matching_results);
}

1;
