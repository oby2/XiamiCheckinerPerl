# use strict;
# use warnings;
# use LWP 5.64;
# my $browser = LWP::UserAgent->new;

# my $word = 'tarragon';

# my $url = 'http://www.altavista.com/sites/search/web';
# my $response = $browser->post( $url,
# [ 'q' => $word,  # the Altavista query string
#   'pg' => 'q', 'avkw' => 'tgz', 'kl' => 'XX',
# ]
# );
# die "$url error: ", $response->status_line
# unless $response->is_success;
# die "Weird content type at $url -- ", $response->content_type
# unless $response->content_type eq 'text/html';

# if( $response->content =~ m{AltaVista found ([0-9,]+) results} ) {
# # The substring will be like "AltaVista found 2,345 results"
# print "$word: $1\n";
# } else {
# print "Couldn't find the match-string in the response\n";
# }

# __END__

use strict;
use warnings;
use LWP ();

my $url = 'http://www.xiami.com/web/login';
my $browser = LWP::UserAgent->new;

my $response = $browser->post($url,
    [
        'email' => '1141120074%40qq.com',
        'password' => 's1987s05w19',
        'LoginButton' => '%E7%99%BB+%E5%BD%95'
    ],
);

print($response->code);
print($response->message);


my $f = "login_response.html";
print("\n");
print($response->headers_as_string);
open(my $fh, ">", $f) || die "Couldn't open '".$f."' for writing because: ".$!;
print $fh $response->as_string;
close $fh;