use strict;
use warnings;

use URI::Escape ();

my($c, $d) = (5, 'abcd');
print($c, $d, "\n");

my $escaped_email = URI::Escape::uri_escape('1141120074@qq.com');
my $escaped_password = URI::Escape::uri_escape('s1987s05w19');
print(sprintf("email=%s&password=%s", $escaped_email, $escaped_password).'&LoginButton=%E7%99%BB%E5%BD%95');

__END__
use Sample::ObjectAndClass::Animal ();

#my $data = "orange";
my @data = ("purple");
my %data = ( "0" => "blue");
my $data = Sample::ObjectAndClass::Animal->new();

print $data."\n";      # "orange"
print $data[0]."\n";   # "purple"
print $data["0"]."\n"; # "purple"
print $data{0}."\n";   # "blue"
print $data{"0"}."\n"; # "blue"
print($data->eat('Apple', 'Orange'), "\n");