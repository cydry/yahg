#!/usr/bin/perl -w
use strict;

sub build_definition_filepath {
  my ($word) = @_;
  if (! (defined($ENV{YAHG}))) {
    die "Failed to fetch an environment variable: 'YAHG'";
  }
  "$ENV{YAHG}/" . $word;
}

sub find_definition_line_number {
  my ($filepath) = @_;
  open FH, '<', $filepath
    or die "Failed to open $filepath: $!";

  my $defline = 0;
  while (<FH>) {
    if (/^Definition.*'\b(\w+)'/) {
      $defline = $.;
    }
  }
  close FH;
  return $defline;
}

sub print_range_lines {
  my ($filepath, $begin, $end) = @_;
  open FH, '<', $filepath
    or die "Failed to open $filepath: $!";

  my @lines = <FH>;
  foreach ($begin..$end) {
    print $lines[$_];
  }
  close FH;
}

sub print_definition {
  my $word = $_;
  my $filepath = build_definition_filepath($word);
  return unless -e $filepath;

  my $def_lnum = find_definition_line_number($filepath);

  print_range_lines($filepath, $def_lnum + 1, $def_lnum + 5);
}

if (@ARGV > 0) {
  map { print_definition; } @ARGV;
} else {
  while (<STDIN>) {
    chomp;
    last if /\A\s*\z/;
    print_definition;
  }
}
