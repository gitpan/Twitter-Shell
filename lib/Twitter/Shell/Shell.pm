# $Id: /mirror/perl/Twitter-Shell/trunk/lib/Twitter/Shell/Shell.pm 6478 2007-04-12T06:47:23.347147Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

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
        print "$cmd ok\n\n";
    } else {
        print "Command $cmd failed :(\n\n";
    }
    return $ret;
}

sub run_update
{
    my $self = shift;
    my $text = "@_";
    $text =~ s/^\s+//;
    $text =~ s/\s+$//;
    if ($text) {
        if ($text =~ /\W/) {
            $text .= " ";
        }
        $text .= "[from twittershell]";
    }
    $self->_twitter_cmd('update', $text);
}
sub smry_update { "post a message" }
sub help_update {}

# help
*run_say = \&run_update;
sub smry_say { "alias to 'update'" }
sub help_say {}

sub run_friends
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('friends');

    if ($ret) {
        foreach my $friend (@$ret) {
            printf( "[%s] %s\n", $friend->{screen_name}, $friend->{status}{text});
        }
    }
}
sub smry_friends { "display friends' status" }
sub help_friends {}

sub run_friends_timeline
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('friends_timeline');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{user}{screen_name}, $rec->{text});
        }
    }
}
sub smry_friends_timeline { "display friends' status as a timeline" }
sub help_friends_timeline {}

*run_ft = \&run_friends_timeline;
sub smry_ft { "alias to friends_timeline" }
sub help_ft {}

sub run_public_timeline
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('public_timeline');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{user}{screen_name}, $rec->{text});
        }
    }
}

sub smry_public_timeline { "display public status as a timeline" }
sub help_public_timeline {}

*run_pt = \&run_public_timeline;
sub smry_pt { "alias to public_timeline" }
sub help_pt {}

sub run_followers
{
    my $self = shift;
    my $ret  = $self->_twitter_cmd('followers');

    if ($ret) {
        foreach my $rec (@$ret) {
            printf( "[%s] %s\n", $rec->{screen_name}, $rec->{status}{text});
        }
    }
}
sub smry_followers { "display followers' status" }
sub help_followers {}

1;
