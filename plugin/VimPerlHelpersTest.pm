package Jo;

# use Data::Dumper;

$test_var = 5;

sub test_sub1 {
    print STDERR "test_sub1\n";

    # print STDERR Dumper VIM::Buffers();
    # print STDERR "num wins: " . VIM::Windows();
    # print STDERR "cur buf name: " . $curbuf->Name();
    # print STDERR "cur buf name: " . $curwin->Cursor();
    print STDERR VIM::Eval("&runtimepath");
}

sub test_sub2 {
    print STDERR "test_sub2";
}

sub _private_sub {

    # not installed
}

1;
