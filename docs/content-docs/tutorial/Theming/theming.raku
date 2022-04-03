#!/usr/bin/env raku

#-------------------------------------------------------------------------------
=begin comment

The purpose of this program is to demonstrate theming of widgets and change them after pressing some buttons. To do this, a window is presented with a column of different widgets and a column of buttons below them. These buttons, when clicked, change the foreground and background color of the widgets above.

=end comment
#-------------------------------------------------------------------------------

use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::StyleContext;
use Gnome::Gtk3::StyleProvider;
use Gnome::Gtk3::CssProvider;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Entry;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::CheckButton;

use Gnome::Gdk3::Screen;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Main $main .= new;

#-------------------------------------------------------------------------------
class Handlers {
  has Str $!css-template;

  submethod BUILD ( ) {
    $!css-template = Q:q:to/EOCSST/;
    window {
      background-color: #001f2f;
    }

    grid {
      background-color: darker(BGCLR2);
      border-color:     lighter(BGCLR2);
      border-style:     solid;
      border-width:     5px;
      color:            lighter(CLR1);
    }

    entry {
      background-color: darker(BGCLR3);
      border-color:     lighter(BGCLR3);
      color:            lighter(CLR1);
    }

    label {
      color:            lighter(CLR1);
    }

    checkbutton label {
      color:            lighter(CLR1);
    }

    button.red-button {
      background-color: #ef4f4f;
    }

    button.red-button > label {
      color:            #801f2f;
    }

    button.green-button {
      background-color: #4fef4f;
    }

    button.green-button > label {
      color:            #1f802f;
    }

    button.blue-button {
      background-color: #4f4fef;
    }

    button.blue-button > label {
      color:            #1f2f80;
    }

    EOCSST


    my Str $css = $!css-template;
    $css ~~ s:g/ BGCLR2 /#801f2f/;
    $css ~~ s:g/ BGCLR3 /#af3f5f/;
    $css ~~ s:g/ CLR1   /#ffd0d0/;

    self!set-colors($css);
  }

  method exit ( ) {
    $main.quit;
  }

  method switch-color ( :$color ) {
    given $color {
      when 'red' {
        my Str $css = $!css-template;
        $css ~~ s:g/ BGCLR2 /#801f2f/;
        $css ~~ s:g/ BGCLR3 /#af3f5f/;
        $css ~~ s:g/ CLR1   /#ffd0d0/;

        self!set-colors($css);
      }

      when 'green' {
        my Str $css = $!css-template;
        $css ~~ s:g/ BGCLR2 /#188f2f/;
        $css ~~ s:g/ BGCLR3 /#3f8f5f/;
        $css ~~ s:g/ CLR1   /#d0ffd0/;

        self!set-colors($css);
      }

      when 'blue' {
        my Str $css = $!css-template;
        $css ~~ s:g/ BGCLR2 /#1f2f80/;
        $css ~~ s:g/ BGCLR3 /#3f5faf/;
        $css ~~ s:g/ CLR1   /#d0d0ff/;

        self!set-colors($css);
      }
    }
  }

  method !set-colors ( Str $css ) {
    my Gnome::Gtk3::CssProvider $css-provider .= new;
    $css-provider.load-from-data($css);

    my Gnome::Gtk3::StyleContext $context .= new;
    $context.add-provider-for-screen(
      Gnome::Gdk3::Screen.new, $css-provider, GTK_STYLE_PROVIDER_PRIORITY_USER
    );

    #TODO find out if there is a memory leak after repeatedly create/replace
    $context.clear-object;
    $css-provider.clear-object;
    $context = Nil;
    $css-provider = Nil;
  }
}

my Handlers $handlers .= new;

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CheckButton $check .= new(:label<check>);
my Gnome::Gtk3::Label $label .= new(:text('Some Text'));
my Gnome::Gtk3::Entry $entry .= new;

my Gnome::Gtk3::StyleContext() $context;
with my Gnome::Gtk3::Button $red-button .= new(:label<red>) {
  .register-signal( $handlers, 'switch-color', 'clicked', :color<red>);
  $context = .get-style-context;
  $context.add-class('red-button');
  $context.clear-object;
}

with my Gnome::Gtk3::Button $green-button .= new(:label<green>) {
  .register-signal( $handlers, 'switch-color', 'clicked', :color<green>);
  $context = .get-style-context;
  $context.add-class('green-button');
  $context.clear-object;
}

with my Gnome::Gtk3::Button $blue-button .= new(:label<blue>) {
  .register-signal( $handlers, 'switch-color', 'clicked', :color<blue>);
  $context = .get-style-context;
  $context.add-class('blue-button');
  $context.clear-object;
}

with my Gnome::Gtk3::Grid $grid .= new {
  .set-column-spacing(5);
  .set-row-spacing(5);

  .attach( $check, 0, 0, 1, 1);
  .attach( $label, 0, 1, 1, 1);
  .attach( $entry, 0, 2, 1, 1);
  .attach( $red-button,   1, 0, 1, 1);
  .attach( $green-button, 1, 1, 1, 1);
  .attach( $blue-button,  1, 2, 1, 1);
}

with my Gnome::Gtk3::Window $window .= new {
  .set-title('Changing Theme');
  .set-border-width(20);
  .add($grid);
  .register-signal( $handlers, 'exit', 'destroy');
  .show-all;
}

$main.main;
