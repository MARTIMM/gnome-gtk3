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
  $a.set-page-type( $f1, GTK_ASSISTANT_PAGE_CUSTOM);
  is GtkAssistantPageType($a.get-page-type($f1)), GTK_ASSISTANT_PAGE_CUSTOM,
    '.set-page-type() / .get-page-type()';

  $a.set-page-title( $f1, 'f1');
  is $a.get-page-title($f1), 'f1', '.set-page-title() / .get-page-title()';

  my Gnome::Gtk3::Frame $f2 .= new(:label<ass-page-1>);
  $f2.widget-set-name('f2');
  is $a.prepend-page($f2), 0, '.prepend-page()';
  $a.set-page-type( $f2, GTK_ASSISTANT_PAGE_CUSTOM);
  my Gnome::Gtk3::Widget $w .= new(:native-object($a.get-nth-page(0)));
  is $w.widget-get-name, 'f2', '.get-nth-pages()';

  is $a.get-current-page, -1, '.get-current-page()';
  $a.set-current-page(1);
  is $a.get-current-page, 1, '.set-current-page()';

  my Gnome::Gtk3::Frame $f3 .= new(:label<ass-page-3>);
  $f3.widget-set-name('f3');
  $a.insert-page( $f3, -1);
  $a.set-page-type( $f3, GTK_ASSISTANT_PAGE_CONFIRM);
  $w .= new(:native-object($a.get-nth-page(2)));
  is $w.widget-get-name, 'f3', '.insert-page()';

  $a.set_page_complete( $f1, True);
  ok $a.get-page-complete($f1), '.set_page_complete() / .get-page-complete()';

#  $a.set_page_complete( $f2, True);
#  $a.set_page_complete( $f3, True);
#  $a.previous-page();
#  is $a.get-current-page, 0, '.previous-page()';
#  $a.next-page();
#  is $a.get-current-page, 1, '.next-page()';


  $a.remove-page(0);
  is $a.get-n-pages, 2, '.remove-page()';
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
