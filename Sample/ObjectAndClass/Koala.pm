package Sample::ObjectAndClass::Koala;

use strict;
use warnings;

# Inherit from Animal
use parent ("Sample::ObjectAndClass::Animal");

# Override one method
sub can_eat {
    my $self = shift @_; # Not used. You could just put "shift @_;" here
    my $food = shift @_;
    return $food eq "eucalyptus";
}

return 1;