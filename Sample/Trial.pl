use strict;
use warnings;

my $data = "orange";
my @data = ("purple");
my %data = ( "0" => "blue");

print $data."\n";      # "orange"
print $data[0]."\n";   # "purple"
print $data["0"]."\n"; # "purple"
print $data{0}."\n";   # "blue"
print $data{"0"}."\n"; # "blue"

print $data,"\n";      # "orange"
print $data[0],"\n";   # "purple"
print $data["0"],"\n"; # "purple"
print $data{0},"\n";   # "blue"
print $data{"0"},"\n"; # "blue"