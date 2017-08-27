#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Tempolate 'debug';

%tempolates = (
    foo => <<EOF,
$d
EOF
);
