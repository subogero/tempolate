# NAME

Tempolate - Pure Perl Template Engine based on String Interpolation

# SYNOPSIS

A tempolate is an executable Perl script defining generated filenames
and contents, e.g. foo.tempolate:

    #!/usr/bin/perl
    use Tempolate;

    %tempolates = (
        "foo_$d{var1}.conf" =>
    "$d{var1}: $d{var2}\n",
        "foo_$d{var1}.logs" => <<EOF,
    access: foo_$d{var1}.access
    error: foo_$d{var1}.error
    EOF
    );

Usage:

    ./foo.tempolate <verb> [<data.yaml>]

where data.yaml contains the variables, var1 and var2 in above case.
If the YAML argument is missing, it is read from STDIN.

Verbs:

    cp	Generate files with resolved variables, print filenames to STDOUT
    rm	Remove generated files and dirs
    cat	Print generated blobs to STDOUT
    ls	Print generated filenames to STDOUT

# DESCRIPTION

Tempolate is based on Perl's very powerful and fast string interpolation.
There is no special template variable syntax.

Further advantage: if your editor can highlight Perl syntax, it will
highlight all interpolated values in your template.

In the template you simply define a global (not my!) %tempolates hash,
with filenames as keys and contents as values.
You can interpolate variables into both.

## Variables

Tempolate reads the input YAML before you define %tempolates,
and imports its data into your tempolate's main:: package.

If your YAML contains key-value pairs, the keys will be accessible
in the %d hash.

If the YAML contains a list, you can access it in the @d array.
In this case fill up the %tempolates hash by iterating over @data.
Use for generating a variable number of similar files.

If the YAML contains a single string, it's in the $d scalar.

## Defining Filenames and Contents

Use double-quoted strings or here-documents. Both allow variable
interpolation. Use here-documents if your text contains newlines
or double-quotes.

The variables imported by Tempolate may be references to data structures,
which could be further nested:

    $d{hash1}->{foo}.conf
    <div>$d{arr2}->[2]</div>
    <li>$d{arr}->[1]{name}</li>

Variables can refer to each other as well, this is a valid input:

    ---
    question: Life Universe Everything?
    answer: 42
    qa: $d{question} $d{answer}

## Conditionals, Loops and Other Control Structures

Perl string interpolation only works for values, but you can embed any code
into values, by defining an anonymous arrayref and dereferencing it.

    @{[ map { "<li>$_</li>" } @{$d{arr}} ]}
    @{[ $d{bool} ? "true" : "false" ]}

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

However hard they try, templates in any template language are programs.
Trying to figure out which crippled subset of a programming languagee
is "safe" is probably not the best security.

Tempolate provides security by not pretending your template is data.
Your template is an executable Perl script.

On the other hand, tempolates are purely declarative by default,
and only run code if you use @{\[ \]} constructs.

# EXAMPLES

## DHCP Client Config - Key Value Pairs

The tempolate:

    #!/usr/bin/perl
    use Tempolate;
    $tempolates{"dhc_$d{link}.conf"} = <<EOF;
    interface "$d{link}" {
      send host-name "$d{host}";
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
    $tempolates{"$_.txt"} = "This text file contains $_\n" for @d;

The YAML input data:

    ---
    - foo
    - bar
    - baz

## Using a Single String

The tempolate:

    #!/usr/bin/perl
    use Tempolate;
    $tempolates{"$d.txt"} = "This text file contains $d\n";

The YAML input data:

    --- foo

# AUTHOR

SZABO Gergely, <szg@subogero.com>

# LICENSE

GPL v2
