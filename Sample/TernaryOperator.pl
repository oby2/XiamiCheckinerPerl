use strict;
use warnings;

# The canonical use for this is singular/plural forms
my $gain = 48;
print "You gained ", $gain, " ", ($gain == 1 ? "experience point" : "experience points"), "!", "\n";

# Don't do something clever like the following, 
# because anybody searching the codebase to replace the words "tooth" or "teeth" will never find this line
my $lost = 1;
print "You lost ", $lost, " t", ($lost == 1 ? "oo" : "ee"), "th!", "\n";

# Nested form
my $eggs = 5;
print "You have ", $eggs == 0 ? "no eggs" :
                   $eggs == 1 ? "an egg"  :
                   "some eggs", "\n";