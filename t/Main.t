use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Main;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Main $m;
#-------------------------------------------------------------------------------
#%*ENV<GDK_DEBUG> = 'interactive';

@*ARGS.push: '--gtk-debug=actions', '--gdk-debug=dnd', '--raku-option';

subtest 'ISA test', {
  $m .= new(:check);
  isa-ok $m, Gnome::Gtk3::Main, ".new(:check)";
  is-deeply @*ARGS, ['--raku-option',], 'all but the last option removed';
}

#subtest 'Manipulations', {
#depending on version, which might differ, skip tests
#  ok !$m.gtk-check-version( 3, 24, 0), 'version ok';
#  is $m.gtk-check-version( 2, 0, 0), 'GTK+ version too new (major mismatch)',
#     'GTK+ version too new';

#  diag GtkTextDirection($m.get-locale-direction);
#}

#-------------------------------------------------------------------------------

#`{{
#-------------------------------------------------------------------------------
# depending on version, which might differ, skip tests
subtest 'Manipulations', {
  ok !$m.gtk-check-version( 3, 24, 0), 'version ok';
  is $m.gtk-check-version( 2, 0, 0), 'GTK+ version too new (major mismatch)',
     'GTK+ version too new';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;

# test to show that only the $raku-option is needed to specify. There should
# not be any usage message.
sub MAIN ( Bool :$raku-option ) { }
