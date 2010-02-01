#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 11;

BEGIN { use_ok 'Catalyst::Test', 'Norris::Web' }
use HTTP::Headers;
use HTTP::Request::Common;

## GET request

my $request = GET('http://localhost');
my $response = request($request);
ok( $response = request($request), 'Basic request to start page');
ok( $response->is_success, 'Start page request successful 2xx');
is( $response->content_type, 'text/html', 'HTML Content-Type');
like( $response->content, qr/Project Norris/, 'Contains the words Project Norris');
$response = undef;

## test request to websites/add
$request = POST( 
    'http://localhost/websites/add/',
    [
        url => 'http://www.adamjctaylor.com',
        name => 'testadamjctaylor.com'
    ]);
$response = request($request);
ok( $response = request($request), 'Request to add site');
ok( $response->is_success, 'Add site request successful 2xx');
is( $response->content_type, 'text/html', 'HTML Content-Type');
$response = undef;

$request = GET('http://localhost/websites/index');
$response = request($request);
ok( $response = request($request), 'Request to websites/index');
ok( $response->is_success, 'websites/index request successful 2xx');
like( $response->content, qr/testadamjctaylor.com/, 'Contains the words testadamjctaylor.com');
$response = undef;
