#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Tempolate {
    question => 'Life Universe Everything?',
    answer => 42,
    qa => '$d{question} $d{answer}',
    question_and_answer => { is => '$d{qa}' },
};

%tempolates = (
    foo => <<EOF,
$d{question_and_answer}->{is}
EOF
);
