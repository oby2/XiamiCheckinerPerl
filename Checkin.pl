use strict;
use warnings;
use MobileCheckiner ();

my $email = shift(@ARGV);
my $password = shift(@ARGV);
my $checkiner = MobileCheckiner->new($email, $password);
$checkiner->checkin();