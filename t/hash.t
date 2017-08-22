#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Tempolate {
    question => 'Life Universe Everything?',
    answer => 42,
};

%tempolates = (
    foo => <<EOF,
$d{question} $d{answer}
EOF
);
