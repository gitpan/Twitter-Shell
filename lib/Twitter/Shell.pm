# $Id: /mirror/perl/Twitter-Shell/trunk/lib/Twitter/Shell.pm 6478 2007-04-12T06:47:23.347147Z daisuke  $
#
# Copyright (c) 2007 Daisuke Maki <daiuske@endeworks.jp>
# All rights reserved.

package Twitter::Shell;
use strict;
use warnings;
use base qw(Twitter::Shell::Base);
use Carp qw(croak);
use Config::Any;
use Net::Twitter;
use Twitter::Shell::Shell;

our $VERSION = '0.02';

__PACKAGE__->mk_accessors($_) for qw(shell config twitter);

sub new
{
    my $class = shift;
    my $config = $class->load_config(shift);
    my $self  = $class->SUPER::new();
    $self->config($config);
    $self->setup();
    $self;
}

sub load_config
{
    my $self = shift;
    my $config = shift;

    if ($config && ! ref $config) {
        my $filename = $config;
        # In the future, we may support multiple configs, but for now
        # just load a single file via Config::Any
        my $list = Config::Any->load_files( { files => [ $filename ] } );
        ($config) = $list->[0]->{$filename};
    }

    if (! $config) {
        croak("Could not load config");
    }

    if (ref $config ne 'HASH') {
        croak("Twitter::Shell expectes config that can be decoded to a HASH");
    }

    return $config;
}

sub setup
{
    my $self = shift;
    $self->shell(Twitter::Shell::Shell->new);
    $self->twitter(Net::Twitter->new(
        username => $self->config->{username},
        password => $self->config->{password},
    ));
}

sub run
{
    my $self = shift;

    my $shell = $self->shell;
    $shell->context($self);
    $shell->prompt_str('twitter> ');
    $shell->cmdloop();
}

sub api_update
{
    my $self = shift;
    $self->twitter->update(@_);
}

sub api_friends
{
    my $self = shift;
    $self->twitter->friends();
}

sub api_friends_timeline
{
    my $self = shift;
    $self->twitter->friends_timeline();
}

sub api_public_timeline
{
    my $self = shift;
    $self->twitter->public_timeline();
}

sub api_followers
{
    my $self = shift;
    $self->twitter->followers();
}

1;

__END__

=head1 NAME

Twitter::Shell - Twitter From Your Shell!

=head1 SYNOPSIS

   twittershell
   twitter> say Just type a message
   update ok

   twitter> friends
   [friend] A message, another message

   twitter> friends_timeline
   [friend] A message, another message

   twitter> ft
   [friend] A message, another message

   twitter> public_timeline
   [friend] A message, another message

   twitter> pt
   [friend] A message, another message

   twitter> followers
   [friend] A message, another message

=head1 DESCRIPTION

Twitter::Shell gives you access to Twitter from your shell!

Documentation coming soon...

=cut