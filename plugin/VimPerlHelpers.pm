package VimHelpers;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(current_sub);

use strict;

sub current_sub {
    VIM::Msg("haha");
}

1;
