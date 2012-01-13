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
my $url = "http://codeforces.com/contest/".$ARGV[0]."/problem/".$ARGV[1];
print "Visiting " . $url . " to get initial tests\n";

# Getting page source
my $response = (WWW::Mechanize->new())->get($url);
if (!$response->is_success) {
    die "Fail: " . $response->status_line;
}

# Getting all samples from the page
my @samples = $response->decoded_content =~ /<div class="input">.*?<pre>(.*?)<\/pre>.*?<div class="output">.*?<pre>(.*?)<\/pre>/g;
for (my $i = 0; $i < @samples/2; $i++) {
    my $input  = $samples[2*$i];
    my $output = $samples[2*$i+1];

    # I hope there will be no samples with "<br />" as an actual data inside!
    $input  =~ s/<br \/>/\n/g;
    $output =~ s/<br \/>/\n/g;

    print "input #$i:\n$input";
    print "output #$i:\n$output\n";
}
