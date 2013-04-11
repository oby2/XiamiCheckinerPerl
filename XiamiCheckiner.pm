package XiamiCheckiner;

use strict;
use warnings;
use LWP ();
use HTTP::Cookies ();
use URI ();

my $xiami_home_url = 'http://www.xiami.com';
my $xiami_login_url = URI->new_abs('/web/login', $xiami_home_url);

sub new
{
    my $class = shift;

    my $self = {
        '_email' => shift,
        '_password' => shift,
        '_browser' => LWP::UserAgent->new()
    };

    $self->{'_browser'}->agent("Mozilla/5.0");
    $self->{'_browser'}->cookie_jar({});

    bless($self, $class);
    return $self;
}

sub checkin
{
    my $self = shift;

    $self->_login_to_xiami();

    if($self->_is_already_checked_in($self->_go_to_home_page()))
    {
        exit 0;
    }

    $self->_send_checkin_request();

    if($self->_is_already_checked_in($self->_go_to_home_page()))
    {
        $self->_log('Checkin successful!');
    }
}

sub _login_to_xiami
{
    my $self = shift;

    my $response_login = $self->{'_browser'}->request($self->_build_login_request());

    # Check the outcome of the response
    $self->_log_and_die('Login response indicates error! Status line:'.$response_login->status_line) if $response_login->is_error;
}

sub _build_login_request
{
    my $self = shift;

    my $request_login = HTTP::Request->new(POST => $xiami_login_url);
    $request_login->content_type('application/x-www-form-urlencoded');
    my $escaped_email = URI::Escape::uri_escape($self->{'_email'});
    my $escaped_password = URI::Escape::uri_escape($self->{'_password'});

    # '%E7%99%BB%E5%BD%95' eq URI::Escape::uri_escape('登录')
    my $login_request_post_content = sprintf("email=%s&password=%s", $escaped_email, $escaped_password).'&LoginButton=%E7%99%BB%E5%BD%95';
    $request_login->content($login_request_post_content);

    return $request_login;
}

sub _send_checkin_request
{
    my $self = shift;
    my $response = shift;

    my $request_checkin = HTTP::Request->new(GET => URI->new_abs($self->_extract_checkin_url($response), $xiami_home_url));
    $request_checkin->header(Referer => URI->new_abs('/web', $xiami_home_url));
    my $response_checkin = $self->{'_browser'}->request($request_checkin);

    $self->_log_and_die('Checkin response indicates error! Status line:'.$response_checkin->status_line) if $response_checkin->is_error;
}

sub _go_to_home_page
{
    my $self = shift;
    my $request_home = HTTP::Request->new(GET => URI->new_abs('/web', $xiami_home_url));
    my $response_home = $self->{'_browser'}->request($request_home);

    $self->_log_and_die('Error when navigating to home page ! Status line:'.$response_home->status_line) if $response_home->is_error;

    return $response_home;
}

sub _is_already_checked_in
{
    my $self = shift;
    my $response = shift;

    if($response->content =~ m/<div class="idh">已连续签到(\d+)天<\/div>/)
    {
        $self->_log(sprintf("Already checked in for %s days!", $1));
        return 1;
    }
    else
    {
        return '';
    }
}

sub _extract_checkin_url
{
    my $self = shift;
    my $response = shift;

    if(!$self->_is_already_checked_in($response))
    {
        if($response->content =~ m/<a class="check_in" href="([^"]+)">/)
        {
            return $1;
        }
        else
        {
            $self->_log_and_die("Fail to extract checkin url from response's content!");
        }
    }
}

sub _log
{
    my $self = shift;
    my $msg = shift;
    my $f = "log.txt";
    open(my $fh, ">", $f) || die "Couldn't open '".$f."' for writing because: ".$!;
    print($msg."\n");
    print $fh $msg."\n";
    close $fh;
}

sub _log_and_die
{
    my $self = shift;
    my $msg = shift;
    $self->_log($msg);
    die($msg);
}

return 1;