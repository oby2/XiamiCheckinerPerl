package Sample::ObjectAndClass::Animal;

use strict;
use warnings;

sub new {
    my $class = shift @_;
    return bless { "legs" => 4, "colour" => "brown" }, $class;
}

sub eat {
    # First argument is always the object to act upon.
    my $self = shift @_;

    foreach my $food ( @_ ) {
        if($self->can_eat($food)) {
            print "Eating ", $food;
        } else {
            print "Can't eat ", $food;
        }
    }
}

# For the sake of argument, assume an Animal can eat anything.
sub can_eat {
    return 1;
}

return 1;