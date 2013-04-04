use strict;
use warnings;

require Sample::ObjectAndClass::Animal;
require Sample::Context;

my $animal = {
    "legs"   => 4,
    "colour" => "brown",
};                       # $animal is an ordinary hash reference
print ref $animal;       # "HASH"
print("\n");
bless $animal, "Sample::ObjectAndClass::Animal"; # now it is an object of class "Animal"
print ref $animal;       # "Animal"
print("\n");
$animal = Sample::ObjectAndClass::Animal->new();
print ref $animal;

require Sample::ObjectAndClass::Koala;

my $koala = Sample::ObjectAndClass::Koala->new();

$koala->eat("insects", "curry", "eucalyptus"); # eat only the eucalyptus