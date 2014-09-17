if has( 'perl' ) == 0
    " echo "The load_perl_helpers.vim plugin needs vim internal perl support."
    finish
endif

" prevent multiple loadings
if exists("g:loaded_perl_helpers")
    finish
endif
let g:loaded_perl_helpers = 1

perl << EOP

    # To see what modules are loaded and what functions are created do:
    # export LOG_LEVEL=DEBUG in your shell.

    use strict;
    use warnings;
    no warnings 'uninitialized';
    use File::Basename;

    my($result_code, $runtime_dirs) = VIM::Eval("&runtimepath");
    die "Cannot get vim runtimepath option" if ! $runtime_dirs;

    my @plugin_dirs = map { $_ . "/plugin" } split(",", $runtime_dirs);

    foreach my $plugin_dir (@plugin_dirs) {

        foreach my $module_file (<$plugin_dir/*.pm>) {

            DEBUG("Loading module: $module_file");
            require $module_file;
            my $module = basename($module_file, ".pm");

            add_vim_functions_for_module_subs($module);
        }
    }

    sub add_vim_functions_for_module_subs {
        my ($module) = @_;

        DEBUG("Creating functions for module: $module");

        my $module_name_space = $module . "::";

        no strict 'refs';

        # loop through all symbol table entries for module
        foreach my $symbol (keys \%{*$module_name_space}) {

            # skip non sub symbol table entries
            next if ! *{ $module_name_space->{$symbol} }{CODE};

            # skip private subs
            next if $symbol =~ /^_/;

            my $vim_function_name = $module . "_" . $symbol;

            DEBUG("Installing perl sub ${module}::${symbol} " .
                "as vim function $vim_function_name");

            my $vim_function =
                ":function! ${vim_function_name}()\n"
                . ":  perl ${module}::${symbol}()\n"
                . ":endfunction\n"
            ;

            VIM::DoCommand($vim_function);
        }
    }

    sub DEBUG {
        return if ! $ENV{LOG_LEVEL};
        print STDERR shift . "\n";
    }

EOP
