# NAME

Tempolate - Pure Perl Template Engine based on String Interpolation

# SYNOPSIS

A tempolate is an executable Perl script defining generated filenames
and contents, e.g. foo.tempolate:

    #!/usr/bin/perl
    use Tempolate;

    %tempolates = (
        "foo_$var1.conf" => "$var1: $var2\n",
        "foo_$var1.logs" => <<EOF,
    access: foo_$var1.access
    error: foo_$var1.error
    EOF
    );

Usage:

    ./foo.tempolate <verb> [<data.yaml>]

where data.yaml contains the variables, var1 and var2 in above case.
If the YAML argument is missing, it is read from STDIN.

Verbs:

    cp    Generate files with resolved variables
    rm    Remove generated files and dirs

# DESCRIPTION

Tempolate is based on Perl's very powerful and fast string interpolation.
There is no special template variable syntax.

Further advantage: if your editor can highlight Perl syntax, it will
highlight all interpolated values in your template.

In the template you simply define a global (not my!) %tempolates hash,
with filenames as keys and contents as values.
You can interpolate variables into both.

## Variable Import

Tempolate reads the input YAML before you define %tempolates,
and imports its data into your tempolate's main:: package.

If your YAML contains key-value pairs, the keys will be directly accessible
as global variables.

If the YAML contains a list, you can access it in the @data array.
In this case fill up the %tempolates hash by iterating over @data.
Use for generating a variable number of similar files.

If the YAML contains a single string, it's in the $data scalar.

## Defining Filenames and Contents

Use double-quoted strings or here-documents. Both allow variable
interpolation. Use here-documents if your text contains newlines
or double-quotes.

If your variable is followed by word-characters, delimit it by curly braces.

    foo_${var1}bar.conf

The variables imported by Tempolate may be references to data structures,
which could be further nested:

    $hash1->{foo}.conf
    <div>$arr2->[2]</div>
    <li>$arr->[1]{name}</li>

## Conditionals, Loops and Other Control Structures

Perl string interpolation only works for values, but you can embed any code
into values, by defining an anonymous arrayref and dereferencing it.

    @{[ map { "<li>$_</li>" } @$arr ]}
    @{[ $bool ? "true" : "false" ]}

Use the functional ?:, grep, map contructs liberally.
You can even call your own functions within the square brackets.

The list elements will be rendered space-delimited by default,
you can set the delimiter in the $" variable.

You can also embed the STDOUT of externals programs into the output:

    <pre>`env | sort`</pre>

## Error Messages

You can control the error messages you get using the "use strict;"
and "use warnings;" pragmas at the beginning of your template.

## Security

Tempolate provides security by not pretending your template is data.
Your template is an executable Perl script.
Trying to figure out which crippled subset of a programming languagee
is "safe" is probably not the best security.

On the other hand, tempolates are purely declarative by default,
and only run code if you use @{\[ \]} constructs.

# EXAMPLES

## DHCP Client Config - Key Value Pairs

The tempolate:

    #!/usr/bin/perl
    use Tempolate;
    $tempolates{"dhc_$link.conf"} = <<EOF;
    interface "$link" {
      send host-name "host";
    }
    EOF

The YAML input data:

    ---
    link: macvlan_0
    host: mediacentre

## Generating a List of Files - List

The tempolate:

    #!/usr/bin/perl
    use Tempolate;
    $tempolates{"$_.txt"} = "This text file contains $_\n" for @data;

The YAML input data:

    ---
    - foo
    - bar
    - baz

## Using a Single String

The tempolate:

    #!/usr/bin/perl
    use Tempolate;
    $tempolates{"$data.txt"} = "This text file contains $data\n";

The YAML input data:

    --- foo

# AUTHOR

SZABO Gergely, <szg@subogero.com>

# LICENSE

GPL2
