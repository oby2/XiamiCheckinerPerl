use strict;
use warnings;

my $scalar = "Mendeleev";

my @array = ("Alpha", "Beta", "Gamma", "Pie");
my %hash = ("Alpha" => "Beta", "Gamma" => "Pie");
print(@array);
print("\n");

my @array = "Mendeleev"; # same as 'my @array = ("Mendeleev");'
print(@array);
print("\n");

my $scalar = ("Alpha", "Beta", "Gamma", "Pie"); # Value of $scalar is now "Pie"

my @array = ("Alpha", "Beta", "Gamma", "Pie");
my $scalar = @array; # Value of $scalar is now 4
print($scalar."\n");
$scalar = scalar(@array);
print($scalar."\n");

my @array = ("Alpha", "Beta", "Goo");
my $scalar = "-X-";
print(@array);              # "AlphaBetaGoo";
print("\n");
print($scalar, @array, 98); # "-X-AlphaBetaGoo98";