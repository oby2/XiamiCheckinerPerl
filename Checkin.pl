use strict;
use warnings;
use XiamiCheckiner ();

my $email = shift(@ARGV);
my $password = shift(@ARGV);
my $checkiner = XiamiCheckiner->new($email, $password);
$checkiner->checkin();