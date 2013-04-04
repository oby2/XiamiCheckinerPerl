use strict;
use warnings;

my $colour    = "Indigo";
my $scalarRef = \$colour;

print $colour;         # "Indigo"
print("\n");
print $scalarRef;      # e.g. "SCALAR(0x182c180)"
print("\n");
print ${$scalarRef}; # "Indigo"
print("\n");
print $$scalarRef; # "Indigo"
print("\n");

my @colours = ("Red", "Orange", "Yellow", "Green", "Blue");
my $arrayRef = \@colours;

print $colours[0];       # direct array access
print("\n");
print ${ $arrayRef }[0]; # use the reference to get to the array
print("\n");
print $arrayRef->[0];    # exactly the same thing
print("\n");

my %atomicWeights = ("Hydrogen" => 1.008, "Helium" => 4.003, "Manganese" => 54.94);
my $hashRef = \%atomicWeights;

print $atomicWeights{"Helium"}; # direct hash access
print("\n");
print ${ $hashRef }{"Helium"};  # use a reference to get to the hash
print("\n");
print $hashRef->{"Helium"};     # exactly the same thing - this is very common
print("\n");