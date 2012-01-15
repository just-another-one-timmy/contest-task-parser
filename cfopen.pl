#!/usr/bin/perl
use strict;
use warnings;
use Switch;
use WWW::Mechanize;

sub makeUrl {
    return ("http://codeforces.com/contest/$_[0]/problem/$_[1]");
}

sub getSamplesFromUrl {
    my $url = $_[0];
    print "Visiting $url\n";

    # Getting page source
    my $response = (WWW::Mechanize->new())->get($url);
    if (!$response->is_success) {
        die "Fail: " . $response->status_line;
    }

    # Getting all samples from the page
    my @samples = $response->decoded_content =~ /<div class="input">.*?<pre>(.*?)<\/pre>.*?<div class="output">.*?<pre>(.*?)<\/pre>/g;
    return (@samples);
}

sub makeInputsAndOutputs {
    my @samples = @_;
    my @inputs  = ();
    my @outputs = ();

    for (my $i = 0; $i < @samples/2; $i++) {
        my $input  = $samples[2*$i];
        my $output = $samples[2*$i+1];

        # I hope there will be no samples with "<br />" as an actual data inside!
        $input  =~ s/<br \/>/\\n/g;
        $output =~ s/<br \/>/\\n/g;

        push(@inputs, $input);
        push(@outputs, $output);

        print "input #$i:\n$input\n";
        print "output #$i:\n$output\n";
    }

    return (\@inputs, \@outputs);
}

sub createTaskFromTemplate {
    my ($contest_id, $task_id, $inputs, $outputs) = @_;

    my $task_class_name = "task$contest_id$task_id";
    my $task_file_name = "$task_class_name.java";
    print "Creating file $task_file_name\n";

    open(TEMPLATE, "<template.java");
    open(CONCRETE, ">$task_file_name");

    my $tests_section = 0;
    while (<TEMPLATE>) {
        my $line = $_;
        if ($line =~ /\*{3} START TESTS/) {
            $tests_section = 1;
            for (my $i = 0; $i < @{$inputs}; $i++) {
                print CONCRETE "{\"${$inputs}[$i]\",\"${$outputs}[$i]\"},\n";
            }
            next;
        }
        if ($line =~ /\*{3} END TESTS/) {
            $tests_section = 0;
            next;
        }
        if ($tests_section) {
            next;
        }

        $line =~ s/%task_class_name%/$task_class_name/;
        print CONCRETE $line; 
    }

    print "Ok. Created file $task_file_name\n"
}

sub openTask {
    my $contest_id = $_[0];
    my $task_id    = $_[1];

    my @samples = getSamplesFromUrl(makeUrl($contest_id, $task_id));
    my ($inputs, $outputs) = makeInputsAndOutputs(@samples);

    createTaskFromTemplate($contest_id, $task_id, $inputs, $outputs);
}

# Greetings
if ($#ARGV != 2) {
    print "usage: action contest_id task_id\n";
    print "e.g. : open 143 A (this will open codeforces.com/contests/143/problem/A task)\n";
}

switch ($ARGV[0]) {
    case "open" {
        print "Opening task\n";
        openTask($ARGV[1], $ARGV[2]);
    }
    else {
        print "Unknown action: $ARGV[0]\n";
    }
}
