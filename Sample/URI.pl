use strict;
use warnings;

use URI ();
use URI::Split qw(uri_join);

my $uri = uri_join('http', '/site.com/', '/index.html');
print($uri."\n");
$uri = URI->new_abs("/index.html", "http://site.com/");
print($uri."\n");

my $xiami_home_url = 'http://www.xiami.com';
my $xiami_login_url = URI->new_abs('/web/login', $xiami_home_url);
print($xiami_login_url."\n");