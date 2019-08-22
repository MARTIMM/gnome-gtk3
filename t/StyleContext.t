use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::Screen;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::StyleContext;
use Gnome::Gtk3::StyleProvider;
use Gnome::Gtk3::CssProvider;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::StyleContext $sc;
  throws-like(
    { $sc .= new; },
    X::Gnome, 'must have named arguments',
    :message(/:s No options used to create/)
  );

  throws-like(
    { $sc .= new(:odd-arg<xyz>); },
    X::Gnome, 'wrong options used',
    :message(/:s Unsupported options for/)
  );

  $sc .= new(:empty);
  isa-ok $sc, Gnome::Gtk3::StyleContext;
}

#-------------------------------------------------------------------------------
subtest 'Style context manipulations', {
  my Gnome::Gdk3::Screen $screen .= new(:default);
  my Gnome::Gtk3::StyleContext $sc .= new(:empty);
  my Gnome::Gtk3::CssProvider $cp1 .= new(:empty);
  my Gnome::Gtk3::CssProvider $cp2 .= new(:empty);

  $sc.add-provider-for-screen(
    $screen, $cp1, GTK_STYLE_PROVIDER_PRIORITY_FALLBACK
  );

  $sc.remove-provider-for-screen( $screen, $cp1);

  $sc.add-provider( $cp2, 234);
  $sc.remove-provider($cp2);

  is $sc.get-state, GTK_STATE_FLAG_DIR_LTR.value, 'style context state is LTR';
}

#-------------------------------------------------------------------------------
done-testing;
