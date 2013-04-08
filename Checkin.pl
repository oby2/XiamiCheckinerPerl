use strict;
use warnings;
use LWP ();
use HTTP::Cookies ();

# Create a user agent object
my $browser = LWP::UserAgent->new;
$browser->agent("Mozilla/5.0");

# Create a request
my $post_req_to_login_page = HTTP::Request->new(POST => 'http://www.xiami.com/web/login');
$post_req_to_login_page->content_type('application/x-www-form-urlencoded');
$post_req_to_login_page->content('email=1141120074%40qq.com&password=s1987s05w19&LoginButton=%E7%99%BB%E5%BD%95');

# Pass request to the user agent and get a response back
my $response = $browser->request($post_req_to_login_page);

# Check the outcome of the response
if ($response->is_success)
{
    print $response->content;
}
else
{
    print $response->status_line, "\n";
}

my $member_auth_key;
# Sample member auth key: 6RjemAzHVmHHcfG9w66fqR%2BRIQ50DnFO3xKwg0JcHQ10FrkNm09E7m%2BQpezbzYmtLRm5o9k07dLi5g

if($response->headers_as_string =~ m/member_auth=([^\;]+);/)
{
    $member_auth_key = $1;
    print($member_auth_key);
}

my $get_req_to_home_page = HTTP::Request->new(GET => 'http://www.xiami.com/web');

my $cookies = HTTP::Cookies->new();
$cookies->set_cookie(0, 'member_auth', $member_auth_key, '/', 'www.xiami.com');
$browser->cookie_jar($cookies);
my $res = $browser->request($get_req_to_home_page);

my $f = "home_page_response.html";
open(my $fh, ">", $f) || die "Couldn't open '".$f."' for writing because: ".$!;
print $fh $res->as_string;
close $fh;