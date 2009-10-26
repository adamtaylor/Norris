#!/usr/bin/perl -w
use strict;
use lib '../lib';

use Norris::TheSchwartzWrapper;
use Norris::Scanner::Crawler;

my $client = Norris::TheSchwartzWrapper->new();
$client->can_do('Norris::Scanner::Crawler');
$client->work();