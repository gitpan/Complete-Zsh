package Complete::Zsh;

our $DATE = '2014-11-29'; # DATE
our $VERSION = '0.01'; # VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       parse_cmdline
                       format_completion
               );

require Complete::Bash;

our %SPEC;

$SPEC{parse_cmdline} = {
    v => 1.1,
    summary => 'Parse shell command-line for processing by completion routines',
    description => <<'_',

This function converts COMP_LINE (str) (which can be supplied by zsh from `read
-l`) and COMP_POINT (int) (which can be supplied by zsh from `read -ln`) into
COMP_WORDS (array) and COMP_CWORD (int), like what bash supplies to shell
functions. Currently implemented using `Complete::Bash`'s `parse_cmdline`.

_
    args_as => 'array',
    args => {
        cmdline => {
            summary => 'Command-line, defaults to COMP_LINE environment',
            schema => 'str*',
            pos => 0,
        },
    },
    result => {
        schema => ['array*', len=>2],
        description => <<'_',

Return a 2-element array: `[$words, $cword]`. `$words` is array of str,
equivalent to `COMP_WORDS` provided by bash to shell functions. `$cword` is an
integer, equivalent to `COMP_CWORD` provided by bash to shell functions. The
word to be completed is at `$words->[$cword]`.

Note that COMP_LINE includes the command name. If you want the command-line
arguments only (like in `@ARGV`), you need to strip the first element from
`$words` and reduce `$cword` by 1.

_
    },
    result_naked => 1,
};
sub parse_cmdline {
    my ($line) = @_;

    $line //= $ENV{COMP_LINE};
    Complete::Bash::parse_cmdline($line, length($line));
}

$SPEC{format_completion} = {
    v => 1.1,
    summary => 'Format completion for output (for shell)',
    description => <<'_',

zsh accepts completion reply in the form of one entry per line to STDOUT.
Currently the formatting is done using `Complete::Bash`'s `format_completion`.

_
    args_as => 'array',
    args => {
        completion => {
            summary => 'Completion answer structure',
            description => <<'_',

Either an array or hash, as described in `Complete`.

_
            schema=>['any*' => of => ['hash*', 'array*']],
            req=>1,
            pos=>0,
        },
    },
    result => {
        summary => 'Formatted string (or array, if `as` key is set to `array`)',
        schema => ['any*' => of => ['str*', 'array*']],
    },
    result_naked => 1,
};
sub format_completion {
    Complete::Bash::format_completion(@_);
}

1;
#ABSTRACT: Completion module for zsh shell

__END__

=pod

=encoding UTF-8

=head1 NAME

Complete::Zsh - Completion module for zsh shell

=head1 VERSION

This document describes version 0.01 of Complete::Zsh (from Perl distribution Complete-Zsh), released on 2014-11-29.

=head1 DESCRIPTION

This module provides routines related to doing completion in zsh.

=head1 FUNCTIONS


=head2 format_completion($completion) -> array|str

Format completion for output (for shell).

zsh accepts completion reply in the form of one entry per line to STDOUT.
Currently the formatting is done using C<Complete::Bash>'s C<format_completion>.

Arguments ('*' denotes required arguments):

=over 4

=item * B<completion>* => I<array|hash>

Completion answer structure.

Either an array or hash, as described in C<Complete>.

=back

Return value:

Formatted string (or array, if `as` key is set to `array`) (any)


=head2 parse_cmdline($cmdline) -> array

Parse shell command-line for processing by completion routines.

This function converts COMP_LINE (str) (which can be supplied by zsh from C<read
-l>) and COMP_POINT (int) (which can be supplied by zsh from C<read -ln>) into
COMP_WORDS (array) and COMP_CWORD (int), like what bash supplies to shell
functions. Currently implemented using C<Complete::Bash>'s C<parse_cmdline>.

Arguments ('*' denotes required arguments):

=over 4

=item * B<cmdline> => I<str>

Command-line, defaults to COMP_LINE environment.

=back

Return value:

 (array)

Return a 2-element array: C<[$words, $cword]>. C<$words> is array of str,
equivalent to C<COMP_WORDS> provided by bash to shell functions. C<$cword> is an
integer, equivalent to C<COMP_CWORD> provided by bash to shell functions. The
word to be completed is at C<< $words-E<gt>[$cword] >>.

Note that COMP_LINE includes the command name. If you want the command-line
arguments only (like in C<@ARGV>), you need to strip the first element from
C<$words> and reduce C<$cword> by 1.

=head1 TODOS

=head1 SEE ALSO

L<Complete>

L<Complete::Bash>, L<Complete::Fish>, L<Complete::Tcsh>.

zshcompctl manual page.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Complete-Zsh>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Complete-Zsh>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Complete-Zsh>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
