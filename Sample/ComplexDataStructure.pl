use strict;
use warnings;

# Form1
my %owner1 = (
    "name" => "Santa Claus",
    "DOB"  => "1882-12-25",
);

my $owner1Ref = \%owner1;

my %owner2 = (
    "name" => "Mickey Mouse",
    "DOB"  => "1928-11-18",
);

my $owner2Ref = \%owner2;

my @owners = ( $owner1Ref, $owner2Ref );

my $ownersRef = \@owners;

my %account = (
    "number" => "12345678",
    "opened" => "2000-01-01",
    "owners" => $ownersRef,
);

# Form2
my %owner1 = (
    "name" => "Santa Claus",
    "DOB"  => "1882-12-25",
);

my %owner2 = (
    "name" => "Mickey Mouse",
    "DOB"  => "1928-11-18",
);

my @owners = ( \%owner1, \%owner2 );

my %account = (
    "number" => "12345678",
    "opened" => "2000-01-01",
    "owners" => \@owners,
);

# Form3
# Braces denote an anonymous hash
my $owner1Ref = {
    "name" => "Santa Claus",
    "DOB"  => "1882-12-25",
};

my $owner2Ref = {
    "name" => "Mickey Mouse",
    "DOB"  => "1928-11-18",
};

# Square brackets denote an anonymous array
my $ownersRef = [ $owner1Ref, $owner2Ref ];

my %account = (
    "number" => "12345678",
    "opened" => "2000-01-01",
    "owners" => $ownersRef,
);

# Form4
# This is the form we should actually use when declaring complex data structures in-line
my %account = (
    "number" => "31415926",
    "opened" => "3000-01-01",
    "owners" => [
        {
            "name" => "Philip Fry",
            "DOB"  => "1974-08-06",
        },
        {
            "name" => "Hubert Farnsworth",
            "DOB"  => "2841-04-09",
        },
    ],
);

# Getting information out of a data structure
# Form1
my $ownersRef = $account{"owners"};
my @owners    = @{ $ownersRef };
my $owner1Ref = $owners[0];
my %owner1    = %{ $owner1Ref };
my $owner2Ref = $owners[1];
my %owner2    = %{ $owner2Ref };
print "Account #", $account{"number"}, "\n";
print "Opened on ", $account{"opened"}, "\n";
print "Joint owners:\n";
print "\t", $owner1{"name"}, " (born ", $owner1{"DOB"}, ")\n";
print "\t", $owner2{"name"}, " (born ", $owner2{"DOB"}, ")\n";

# Form2
my @owners = @{ $account{"owners"} };
my %owner1 = %{ $owners[0] };
my %owner2 = %{ $owners[1] };
print "Account #", $account{"number"}, "\n";
print "Opened on ", $account{"opened"}, "\n";
print "Joint owners:\n";
print "\t", $owner1{"name"}, " (born ", $owner1{"DOB"}, ")\n";
print "\t", $owner2{"name"}, " (born ", $owner2{"DOB"}, ")\n";

# Form3
my $ownersRef = $account{"owners"};
my $owner1Ref = $ownersRef->[0];
my $owner2Ref = $ownersRef->[1];
print "Account #", $account{"number"}, "\n";
print "Opened on ", $account{"opened"}, "\n";
print "Joint owners:\n";
print "\t", $owner1Ref->{"name"}, " (born ", $owner1Ref->{"DOB"}, ")\n";
print "\t", $owner2Ref->{"name"}, " (born ", $owner2Ref->{"DOB"}, ")\n";

# Form4
print "Account #", $account{"number"}, "\n";
print "Opened on ", $account{"opened"}, "\n";
print "Joint owners:\n";
print "\t", $account{"owners"}->[0]->{"name"}, " (born ", $account{"owners"}->[0]->{"DOB"}, ")\n";
print "\t", $account{"owners"}->[1]->{"name"}, " (born ", $account{"owners"}->[1]->{"DOB"}, ")\n";

# How to shoot yourself in the foot with array references
my @array1 = (1, 2, 3, 4, 5);
print @array1, "\n"; # "12345"

my @array2 = [1, 2, 3, 4, 5];
print @array2, "\n"; # e.g. "ARRAY(0x182c180)"

my $array3Ref = [1, 2, 3, 4, 5];
print $array3Ref, "\n";      # e.g. "ARRAY(0x22710c0)"
print @{ $array3Ref }, "\n"; # "12345"
print @$array3Ref, "\n";     # "12345"