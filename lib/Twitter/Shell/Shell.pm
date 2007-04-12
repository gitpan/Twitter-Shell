# 

package Twitter::Shell::Shell;
use strict;
use warnings;
use base qw(Term::Shell);

sub context { shift->_elem('context', @_) }
sub prompt_str { shift->_elem('prompt_str', @_) }
sub _elem
{
    my $self = shift;
    my $name = shift;
    my $value = $self->{$name};
    if (@_) {
        $self->{$name} = shift;
    }
    return $value;
}

sub _twitter_cmd
{
    my $self = shift;
    my $cmd  = shift;
    my $c    = $self->context;
    my $method = "api_$cmd";
    my $ret    = $c->$method(@_);

    if ($ret) {
        print "$cmd ok\n";
    } else {
        print "Command $cmd failed :(\n";
    }
    return $ret;
}

sub run_update
{
    my $self = shift;
    my $text = "@_";
    if ($text =~ /\W/) {
        $text .= " ";
    }
    $text .= "[from twittershell]";
    $self->_twitter_cmd('update', $text);
}
*run_say = \&run_update;

sub run_friends
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('friends');

    if ($ret) {
        foreach my $friend (@$ret) {
            printf( "[%s] %s\n", $friend->{name}, $friend->{status}{text});
        }
    }
}

sub run_friends_timeline
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('friends_timeline');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{user}{name}, $rec->{text});
        }
    }
}

sub run_public_timeline
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('public_timeline');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{user}{name}, $rec->{text});
        }
    }
}

sub run_followers
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('followers');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{name}, $rec->{status}{text});
        }
    }
}

1;
