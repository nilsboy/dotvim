package Jo;

# use Data::Dumper;

$fracking_var = 5;

sub grr {
    print STDERR "grrrrrrrrrrrrrrrrrr\n";
    # print STDERR Dumper VIM::Buffers();
    # print STDERR "num wins: " . VIM::Windows();
    # print STDERR "cur buf name: " . $curbuf->Name();
    # print STDERR "cur buf name: " . $curwin->Cursor();
    print STDERR VIM::Eval("&runtimepath");
}

sub xxx {
    print STDERR "zzzzzzzzzzzzzz";
}

sub _nix_da {
    # not installed
}

1;
