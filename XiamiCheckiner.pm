package XiamiCheckiner;

use strict;
use warnings;
use LWP ();
use HTTP::Cookies ();
use URI ();
use Time::Piece (); 

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

    # creates 'yyyy-mm-dd hh:mm:ss' string
    $self->_log(sprintf("---------------------%s---------------------", Time::Piece::localtime->strftime('%Y-%m-%d %H:%M:%S')));
    $self->_log('XiamiCheckin process started...');
    my $login_response = $self->_login_to_xiami();

    if(!$self->_is_already_checked_in())
    {
        $self->_send_checkin_request($login_response);

        if($self->_is_already_checked_in())
        {
            $self->_log('Checkin successful!');
        }
    }

    $self->_log('XiamiCheckin process ended.');
    $self->_log('------------------------------------------');
    $self->_log("\n\n");
}

sub _login_to_xiami
{
    my $self = shift;

    $self->_log('Login to xiami...');
    my $response_login = $self->{'_browser'}->request($self->_build_login_request());

    $self->_log_and_die('Login response indicates error! Status line:'.$response_login->status_line) if $response_login->is_error;
    $self->_log($response_login->as_string(), ">", "login_page_response.html");
    $self->_log('Login successful.');

    return $response_login;
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
    
    $self->_log('Sending checkin request...');
    my $response_checkin = $self->{'_browser'}->request($request_checkin);

    $self->_log_and_die('Checkin response indicates error! Status line:'.$response_checkin->status_line) if $response_checkin->is_error;
    $self->_log($response_checkin->as_string(), ">", "checkin_response.html");
    $self->_log('Got checkin response.');
}

sub _go_to_home_page
{
    my $self = shift;
    my $request_home = HTTP::Request->new(GET => URI->new_abs('/web', $xiami_home_url));
    
    $self->_log('Requesting home page...');
    my $response_home = $self->{'_browser'}->request($request_home);

    $self->_log_and_die('Error when navigating to home page ! Status line:'.$response_home->status_line) if $response_home->is_error;
    $self->_log($response_home->as_string(), ">", "home_page_response.html");
    $self->_log('Got home page response.');
    return $response_home;
}

sub _is_already_checked_in
{
    my $self = shift;
    my $response = $self->_go_to_home_page();

    if($response->content() =~ m/<div class="idh">已连续签到(\d+)天<\/div>/)
    {
        $self->_log(sprintf("Already checked in today, %d days in total!", $1));
        return 1;
    }
    else
    {
        if($response->headers_as_string() =~ m/t_sign_auth=([^\;]+);/)
        {
            $self->_log(sprintf('Not checked in today yet, already checked in for %s days!'));
        }
        else
        {
            $self->_log("Not checked in today yet, don't know how many days already checked in!");
        }

        return '';
    }
}

sub _extract_checkin_url
{
    my $self = shift;
    my $response = shift;

    if(!$self->_is_already_checked_in())
    {
        $self->_log('Extracting checkin url...');

        if($response->content() =~ m/<a class="check_in" href="([^"]+)">/)
        {
            $self->_log('Checkin url obtained.');
            return $1;
        }
        else
        {
            $self->_log_and_die("Fail to extract checkin url!");
        }
    }
}

sub _log
{
    my $self = shift;
    my $msg = shift;
    my $mode = ">>";
    my $f = "log.txt";

    if(@_)
    {
        $mode = shift;
    }

    if(@_)
    {
        $f = shift;
    }
    
    open(my $fh, $mode, $f) || die "Couldn't open '".$f."' because: ".$!;
    #print($msg."\n");
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

__END__