use strict;
use warnings;
use Data::Dumper;
use LWP ();
use HTTP::Cookies ();

# Create a user agent object
my $browser = LWP::UserAgent->new;
$browser->agent("Mozilla/5.0");
$browser->cookie_jar({});

# Create a request
my $req_login_page = HTTP::Request->new(POST => 'http://www.xiami.com/web/login');
$req_login_page->content_type('application/x-www-form-urlencoded');
$req_login_page->content('email=1141120074%40qq.com&password=s1987s05w19&LoginButton=%E7%99%BB%E5%BD%95');

# Pass request to the user agent and get a response back
my $res_login_page = $browser->request($req_login_page);

# Check the outcome of the response
if ($res_login_page->is_success)
{
    print $res_login_page->content;
}
else
{
    print $res_login_page->status_line, "\n";
}

my $member_auth_key = undef;
# Sample member auth key: 6RjemAzHVmHHcfG9w66fqR%2BRIQ50DnFO3xKwg0JcHQ10FrkNm09E7m%2BQpezbzYmtLRm5o9k07dLi5g

if($res_login_page->headers_as_string =~ m/member_auth=([^\;]+);/)
{
    $member_auth_key = $1;
    print($member_auth_key, "\n");
}

print(Dumper($res_login_page->headers));
print("\n");
print($res_login_page->headers->{'location'});
print("\n");
print(Dumper($browser->cookie_jar));

__END__
my $req_home_page = HTTP::Request->new(GET => 'http://www.xiami.com/web');

# my $cookies = HTTP::Cookies->new();
# $cookies->set_cookie(0, 'member_auth', $member_auth_key, '/', '.xiami.com');
# $browser->cookie_jar($cookies);
my $res_home_page = $browser->request($req_home_page);

# my $f = "home_page_response.html";
# open(my $fh, ">", $f) || die "Couldn't open '".$f."' for writing because: ".$!;
# print $fh $res_home_page->as_string;
# close $fh;

my $checkin_url = undef;

if($res_home_page->content =~ m/<a class="check_in" href="([^"]+)">/)
{
    $checkin_url = $1;
    print($checkin_url, "\n");
}

my $req_checkin = HTTP::Request->new(GET => 'http://www.xiami.com/'.$checkin_url);
$req_checkin->header(Referer => "http://www.xiami.com/web");
my $res_checkin = $browser->request($req_checkin);

$req_home_page = HTTP::Request->new(GET => 'http://www.xiami.com/'.$res_checkin->headers->{'location'});
$req_home_page->header(Referer => "http://www.xiami.com/web");
$res_home_page = $browser->request($req_home_page);

my $checkin_days = undef;

if($res_home_page->content =~ m/<div class="idh">已连续签到(\d+)天</div>/)
{
    $checkin_days = $1;
    print($checkin_days, "\n");
}