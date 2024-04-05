#TL:1:Gnome::Gtk3::Tooltip:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Tooltip

Add tips to your widgets

=comment ![](images/X.png)


=head1 Description

Basic tooltips can be realized simply by using C<gtk_widget_set_tooltip_text()> or C<gtk_widget_set_tooltip_markup()> without any explicit tooltip object.

When you need a tooltip with a little more fancy contents, like adding an image, or you want the tooltip to have different contents per B<Gnome::Gtk3::TreeView> row or cell, you will have to do a little more work:

=item Set the  I<has-tooltip> property to C<1>, this will make GTK+ monitor the widget for motion and related events which are needed to determine when and where to show a tooltip.

=item Connect to the  I<query-tooltip> signal. This signal will be emitted when a tooltip is supposed to be shown. One of the arguments passed to the signal handler is a B<Gnome::Gtk3::Tooltip> object. This is the object that we are about to display as a tooltip, and can be manipulated in your callback using functions like C<gtk_tooltip_set_icon()>. There are functions for setting the tooltip’s markup, setting an image from a named icon, or even putting in a custom widget. Return C<1> from your query-tooltip handler. This causes the tooltip to be show. If you return C<0>, it will not be shown.

In the probably rare case where you want to have even more control over the tooltip that is about to be shown, you can set your own B<Gnome::Gtk3::Window> which will be used as tooltip window.  This works as follows:

=item Set  I<has-tooltip> and connect to  I<query-tooltip> as before.  Use C<gtk_widget_set_tooltip_window()> to set a B<Gnome::Gtk3::Window> created by you as tooltip window.

=item In the  I<query-tooltip> callback you can access your window using C<gtk_widget_get_tooltip_window()> and manipulate as you wish. The semantics of  the return value are exactly as before, return C<1> to show the window, C<0> to not show it.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Tooltip;
  also is Gnome::GObject::Object;


=head2 Uml Diagram

![](plantuml/Tooltip.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Tooltip:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Tooltip;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Tooltip class process the options
    self.bless( :GtkTooltip, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;

use Gnome::GObject::Object:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Tooltip:auth<github:MARTIMM>:api<1>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods

=begin comment
Create a Tooltip object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a Tooltip object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

#TM:0:new():inheriting
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Tooltip' #`{{ or %options<GtkTooltip> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<___x___> {
      #  $no = %options<___x___>;
      #  $no .= _get-native-object-no-reffing
      #    if $no.^can('_get-native-object-no-reffing');
      #  #$no = _gtk_tooltip_new___x___($no);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_tooltip_new();
      }
      }}

      #self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkTooltip');

  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tooltip_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkTooltip');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#`{{
# TM:0:gtk_tooltip_get_type:
=begin pod
=head2 [[gtk_] tooltip_] get_type

  method gtk_tooltip_get_type ( --> UInt )

=end pod

sub gtk_tooltip_get_type (  --> uint64 )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tooltip_set_markup:
=begin pod
=head2 [[gtk_] tooltip_] set_markup

Sets the text of the tooltip to be I<$markup>, which is marked up with the Pango text markup language. If I<$markup> is undefined, the label will be hidden.

  method gtk_tooltip_set_markup ( Str $markup )

=item Str $markup; (allow-none): a markup string (see [Pango markup format][PangoMarkupFormat]) or C<Any>

=end pod

sub gtk_tooltip_set_markup ( N-GObject $tooltip, Str $markup  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_tooltip_set_text:xt/ex-liststore-3.raku
=begin pod
=head2 [[gtk_] tooltip_] set_text

Sets the text of the tooltip to be I<$text>. If I<$text> is undefined, the label will be hidden. See also C<gtk_tooltip_set_markup()>.

  method gtk_tooltip_set_text ( Str $text )

=item Str $text; a text string or C<Any>

=end pod

sub gtk_tooltip_set_text ( N-GObject $tooltip, Str $text  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tooltip_set_icon:
=begin pod
=head2 [[gtk_] tooltip_] set_icon

Sets the icon of the tooltip (which is in front of the text) to be I<pixbuf>.  If I<pixbuf> is C<Any>, the image will be hidden.

  method gtk_tooltip_set_icon ( N-GObject $pixbuf )

=item N-GObject $pixbuf; (allow-none): a B<Gnome::Gdk3::Pixbuf>, or C<Any>

=end pod

sub gtk_tooltip_set_icon ( N-GObject $tooltip, N-GObject $pixbuf  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tooltip_set_icon_from_icon_name:
=begin pod
=head2 [[gtk_] tooltip_] set_icon_from_icon_name

Sets the icon of the tooltip (which is in front of the text) to be the icon indicated by I<icon_name> with the size indicated by I<size>.  If I<icon_name> is C<Any>, the image will be hidden.

  method gtk_tooltip_set_icon_from_icon_name ( Str $icon_name, GtkIconSize $size )

=item Str $icon_name; (allow-none): an icon name, or C<Any>
=item GtkIconSize $size; (type int): a stock icon size (B<Gnome::Gtk3::IconSize>)

=end pod

sub gtk_tooltip_set_icon_from_icon_name ( N-GObject $tooltip, Str $icon_name, int32 $size  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_tooltip_set_icon_from_gicon:
=begin pod
=head2 [[gtk_] tooltip_] set_icon_from_gicon

Sets the icon of the tooltip (which is in front of the text) to be the icon indicated by I<gicon> with the size indicated by I<size>. If I<gicon> is C<Any>, the image will be hidden.

  method gtk_tooltip_set_icon_from_gicon ( GIcon $gicon, GtkIconSize $size )

=item GIcon $gicon; (allow-none): a B<GIcon> representing the icon, or C<Any>
=item GtkIconSize $size; (type int): a stock icon size (B<Gnome::Gtk3::IconSize>)

=end pod

sub gtk_tooltip_set_icon_from_gicon ( N-GObject $tooltip, GIcon $gicon, int32 $size  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_tooltip_set_custom:
=begin pod
=head2 [[gtk_] tooltip_] set_custom

Replaces the widget packed into the tooltip with I<custom_widget>. I<custom_widget> does not get destroyed when the tooltip goes away. By default a box with a B<Gnome::Gtk3::Image> and B<Gnome::Gtk3::Label> is embedded in  the tooltip, which can be configured using C<gtk_tooltip_set_markup()>  and C<gtk_tooltip_set_icon()>.

  method gtk_tooltip_set_custom ( N-GObject $custom_widget )

=item N-GObject $custom_widget; (allow-none): a B<Gnome::Gtk3::Widget>, or C<Any> to unset the old custom widget.

=end pod

sub gtk_tooltip_set_custom ( N-GObject $tooltip, N-GObject $custom_widget  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tooltip_set_tip_area:
=begin pod
=head2 [[gtk_] tooltip_] set_tip_area

Sets the area of the widget, where the contents of this tooltip apply, to be I<rect> (in widget coordinates).  This is especially useful for properly setting tooltips on B<Gnome::Gtk3::TreeView> rows and cells, B<Gnome::Gtk3::IconViews>, etc.  For setting tooltips on B<Gnome::Gtk3::TreeView>, please refer to the convenience functions for this: C<gtk_tree_view_set_tooltip_row()> and C<gtk_tree_view_set_tooltip_cell()>.

  method gtk_tooltip_set_tip_area ( N-GObject $rect )

=item N-GObject $rect; a B<Gnome::Gdk3::Rectangle>

=end pod

sub gtk_tooltip_set_tip_area ( N-GObject $tooltip, N-GObject $rect  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tooltip_trigger_tooltip_query:
=begin pod
=head2 [[gtk_] tooltip_] trigger_tooltip_query

Triggers a new tooltip query on I<$display>, in order to update the current visible tooltip, or to show/hide the current tooltip.  This function is useful to call when, for example, the state of the widget changed by a key press.

  method gtk_tooltip_trigger_tooltip_query ( N-GObject $display )

=item N-GObject $display; a B<Gnome::Gdk3::Display>

=end pod

sub gtk_tooltip_trigger_tooltip_query ( N-GObject $display  )
  is native(&gtk-lib)
  { * }
