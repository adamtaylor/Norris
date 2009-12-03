#!/usr/bin/perl -w
use strict;
use lib '../lib';

use Norris::TheSchwartzWrapper;
use Norris::Scanner::Attacker;

my $client = Norris::TheSchwartzWrapper->new();
$client->can_do('Norris::Scanner::Attacker');
$client->work();