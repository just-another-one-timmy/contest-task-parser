#!/usr/bin/perl
use strict;
use warnings;

# Greetings
if ($#ARGV != 1) {
    print "usage: contest_id task_id\n";
    print "e.g. : 143 A (this will open codeforces.com/contests/143/problem/A task)\n";
    exit;
}

# Setting url
use WWW::Mechanize;
my $contest_id = $ARGV[0];
my $task_id    = $ARGV[1];
my $url = "http://codeforces.com/contest/$contest_id/problem/$task_id";
print "Visiting $url\n";

# Getting page source
my $response = (WWW::Mechanize->new())->get($url);
if (!$response->is_success) {
    die "Fail: " . $response->status_line;
}

# Getting all samples from the page
my @samples = $response->decoded_content =~ /<div class="input">.*?<pre>(.*?)<\/pre>.*?<div class="output">.*?<pre>(.*?)<\/pre>/g;
my @inputs  = ();
my @outputs = ();

for (my $i = 0; $i < @samples/2; $i++) {
    my $input  = $samples[2*$i];
    my $output = $samples[2*$i+1];

    # I hope there will be no samples with "<br />" as an actual data inside!
    $input  =~ s/<br \/>/\n/g;
    $output =~ s/<br \/>/\n/g;

    push(@inputs, $input);
    push(@outputs, $output);

    print "input #$i:\n$input";
    print "output #$i:\n$output\n";
}

# At this point we have sample inputs in @inputs and sample outputs in @outputs
# And we are going to produce file with name like task143A.java
my $task_file_name = "task$contest_id$task_id.java";
print "Creating file $task_file_name\n";

open(TEMPLATE, "<template.java");
open(CONCRETE, ">$task_file_name");

# We will 
my $tests_section = 0;
while (<TEMPLATE>) {
  my $line = $_;
  print CONCRETE $line; 
}
