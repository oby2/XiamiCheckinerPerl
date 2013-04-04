use strict;
use warnings;

my @array = (
    "a",
    "b",
    "c",
    "d"
);

foreach my $string (@array)
{
    print $string."\n";
}

foreach my $i ( 0 .. $#array )
{
    print $i, ": ", $array[$i];
}

print("\n");

my %scientists = (
    "man1" => "Einstein",
    "man2" => "Newton",
    "man3" => "Edison"
);

foreach my $key (keys(%scientists)) {
    print $key, ": ", $scientists{$key}, "; ";
}

print("\n");

foreach my $key (sort(keys(%scientists))) {
    print $key, ": ", $scientists{$key}, "; ";
}

print("\n");

foreach ( @array ) {
    print $_, "; ";
}

print("\n");

print ($_, "; ") foreach @array;

print("\n");

CANDIDATE: for my $candidate ( 2 .. 100 ) {
    for my $divisor ( 2 .. sqrt $candidate ) {
        next CANDIDATE if $candidate % $divisor == 0;
    }
    print $candidate." is prime\n";
}