use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Assistant;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Assistant $a;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $a .= new;
  isa-ok $a, Gnome::Gtk3::Assistant, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $a.get-n-pages, 0, '.get-n-pages()';

  my Gnome::Gtk3::Frame $f1 .= new(:label<ass-page-1>);
  $f1.widget-set-name('f1');
  $a.append-page($f1);
  is $a.get-n-pages, 1, '.append-page()';

  my Gnome::Gtk3::Frame $f2 .= new(:label<ass-page-1>);
  $f2.widget-set-name('f2');
  is $a.prepend-page($f2), 0, '.prepend-page()';
  my Gnome::Gtk3::Widget $w .= new(:native-object($a.get-nth-page(0)));
  is $w.widget-get-name, 'f2', '.get-nth-pages()';

  $a.set-page-type( $f1, GTK_ASSISTANT_PAGE_CONTENT);
  is GtkAssistantPageType($a.get-page-type($f1)), GTK_ASSISTANT_PAGE_CONTENT,
      '.set-page-type() / .get-page-type()';
}

#`{{
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
