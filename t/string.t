#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Tempolate 'debug', 'Life Universe Everything? 42';

%tempolates = (
    foo => <<EOF,
$d
EOF
);
