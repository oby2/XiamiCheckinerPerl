use strict;
use warnings;
use Data::Dumper;
use LWP ();
use HTTP::Cookies ();

my $xiami_home_url = 'http://www.xiami.com';
my $xiami_login_url = $xiami_home_url.'/web/login';

# Create a user agent object
my $browser = LWP::UserAgent->new;
$browser->agent("Mozilla/5.0");
$browser->cookie_jar({});

# Request #1, POST, login to xiami
my $request_login = HTTP::Request->new(POST => $xiami_login_url);
$request_login->content_type('application/x-www-form-urlencoded');
$request_login->content('email=1141120074%40qq.com&password=s1987s05w19&LoginButton=%E7%99%BB%E5%BD%95');

my $response_login = $browser->request($request_login);

# Check the outcome of the response
die('Login response is not a redirect! Actual status line:'.$response_login->status_line.'.') if !$response_login->is_redirect;

# Request #2, GET, get to where the former response told us to go (something like manual follow-redirect)
my $request_home_1 = HTTP::Request->new(GET => $xiami_home_url.$response_login->headers->{'location'});
$response_home_1 = $browser->request($request_home_1);

die('Error when manual follow-redirect to home page after login! Actual status line:'.$response_login->status_line.'.') if !$response_home_1->is_success;

my $checkin_url = undef;

if($response_home_1->content =~ m/<a class="check_in" href="([^"]+)">/)
{
    $checkin_url = $1;
}
else
{
    die("Fail to extract checkin url from home page 1st time response's content!");
}

my $request_checkin = HTTP::Request->new(GET => $xiami_home_url.$checkin_url);
$request_checkin->header(Referer => $xiami_home_url.'/web');
my $response_checkin = $browser->request($request_checkin);

die('Checkin response is not a redirect! Actual status line:'.$response_login->status_line.'.') if !$response_login->is_redirect;

$request_home_2 = HTTP::Request->new(GET => 'http://www.xiami.com/'.$response_checkin->headers->{'location'});
$request_home_2->header(Referer => $xiami_home_url.'/web');
$response_home_2 = $browser->request($request_home_2);

die('Error when manual follow-redirect to home page after checkin! Actual status line:'.$response_home_2->status_line.'.') if !$response_home_2->is_success;

if($response_home_2->content =~ m/<div class="idh">已连续签到(\d+)天<\/div>/)
{
    $checkin_days = $1;
}
else
{
}

__END__