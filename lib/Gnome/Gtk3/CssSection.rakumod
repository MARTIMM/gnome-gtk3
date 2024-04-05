#TL:1:Gnome::Gtk3::CssSection:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CssSection

Defines a part of a CSS document


=comment ![](images/X.png)


=head1 Description

Defines a part of a CSS document. Because sections are nested into one another, you can use C<get-parent()> to get the containing region.


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::CssSection;
  also is Gnome::GObject::Boxed;


=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=head2 Example

  my Gnome::Gtk3::CssProvider $css-provider .= new;
  $css-provider.load-from-path('my-style.css');

  my Gnome::Gtk3::StyleContext $context .= new;
  $context.add-provider-for-screen(
    Gnome::Gdk3::Screen.new, $css-provider, GTK_STYLE_PROVIDER_PRIORITY_USER
  );

  my Gnome::Gtk3::CssSection $section .= new(
    :native-object($context.get-section('window')
  );


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::GObject::Boxed:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::CssSection:auth<github:MARTIMM>:api<1>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkCssSectionType

The different types of sections indicate parts of a CSS document as parsed by GTK’s CSS parser. They are oriented towards the [CSS Grammar](http://www.w3.org/TR/CSS21/grammar.html), but may contain extensions.

More types might be added in the future as the parser incorporates more features.

=item GTK-CSS-SECTION-DOCUMENT: The section describes a complete document. This section time is the only one where C<get-parent()> might return C<undefined>.
=item GTK-CSS-SECTION-IMPORT: The section defines an import rule.
=item GTK-CSS-SECTION-COLOR-DEFINITION: The section defines a color. This is a GTK extension to CSS.
=item GTK-CSS-SECTION-BINDING-SET: The section defines a binding set. This is a GTK extension to CSS.
=item GTK-CSS-SECTION-RULESET: The section defines a CSS ruleset.
=item GTK-CSS-SECTION-SELECTOR: The section defines a CSS selector.
=item GTK-CSS-SECTION-DECLARATION: The section defines the declaration of a CSS variable.
=item GTK-CSS-SECTION-VALUE: The section defines the value of a CSS declaration.
=item GTK-CSS-SECTION-KEYFRAMES: The section defines keyframes. See [CSS Animations](http://dev.w3.org/csswg/css3-animations/B<keyframes>) for details.

=end pod

#TE:0:GtkCssSectionType:
enum GtkCssSectionType is export (
  'GTK_CSS_SECTION_DOCUMENT',
  'GTK_CSS_SECTION_IMPORT',
  'GTK_CSS_SECTION_COLOR_DEFINITION',
  'GTK_CSS_SECTION_BINDING_SET',
  'GTK_CSS_SECTION_RULESET',
  'GTK_CSS_SECTION_SELECTOR',
  'GTK_CSS_SECTION_DECLARATION',
  'GTK_CSS_SECTION_VALUE',
  'GTK_CSS_SECTION_KEYFRAMES'
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :native-object

Create a CssSection object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CssSection' {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
#    elsif %options<build-id>:exists { }

    # process all other options
    else {
      #my $no;
      if ? %options<___x___> {
#        $no = %options<___x___>;
#        $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
#        #$no = _gtk_css_section_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_css_section_new();
      }
      }}

      #self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCssSection');
  }
}

#-------------------------------------------------------------------------------
# ? no ref/unref for a variant type
method native-object-ref ( $n-native-object --> Any ) {
  _gtk_css_section_ref($n-native-object)
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
#  _g_object_free($n-native-object)
  _gtk_css_section_unref($n-native-object)
}

#-------------------------------------------------------------------------------
#TM:0:get-end-line:
=begin pod
=head2 get-end-line

Returns the line in the CSS document where this section end. The line number is 0-indexed, so the first line of the document will return 0. This value may change in future invocations of this function if I<section> is not yet parsed completely. This will for example happen in the GtkCssProvider::parsing-error signal. The end position and line may be identical to the start position and line for sections which failed to parse anything successfully.

Returns: the line number

  method get-end-line ( --> UInt )

=end pod

method get-end-line ( --> UInt ) {
  gtk_css_section_get_end_line(self._get-native-object-no-reffing)
}

sub gtk_css_section_get_end_line (
  N-GObject $section --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-end-position:
=begin pod
=head2 get-end-position

Returns the offset in bytes from the start of the current line returned via C<get-end-line()>. This value may change in future invocations of this function if I<section> is not yet parsed completely. This will for example happen in the GtkCssProvider::parsing-error signal. The end position and line may be identical to the start position and line for sections which failed to parse anything successfully.

Returns: the offset in bytes from the start of the line.

  method get-end-position ( --> UInt )

=end pod

method get-end-position ( --> UInt ) {
  gtk_css_section_get_end_position(self._get-native-object-no-reffing)
}

sub gtk_css_section_get_end_position (
  N-GObject $section --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-file:
=begin pod
=head2 get-file

Gets the file that I<section> was parsed from. If no such file exists, for example because the CSS was loaded via I<gtk-css-provider-load-from-data>(), then C<undefined> is returned.

Returns: the native B<Gnome::Gtk3::File> that I<section> was parsed from or C<undefined> if I<section> was parsed from other data

  method get-file ( --> N-GObject )

=end pod

method get-file ( --> N-GObject ) {
  gtk_css_section_get_file(self._get-native-object-no-reffing)
}

sub gtk_css_section_get_file (
  N-GObject $section --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-parent:
=begin pod
=head2 get-parent

Gets the parent section for the given I<section>. The parent section is the section that contains this I<section>. A special case are sections of type C<GTK-CSS-SECTION-DOCUMENT>. Their parent will either be C<undefined> if they are the original CSS document that was loaded by C<Gnome::Gtk3::CssProvider.load-from-file()> or a section of type C<GTK-CSS-SECTION-IMPORT> if it was loaded with an import rule from a different file.

Returns: the parent section or C<undefined> if none

  method get-parent ( --> N-GObject )

=end pod

method get-parent ( --> N-GObject ) {
  gtk_css_section_get_parent(self._get-native-object-no-reffing)
}

sub gtk_css_section_get_parent (
  N-GObject $section --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-section-type:
=begin pod
=head2 get-section-type

Gets the type of information that I<section> describes.

Returns: the type of I<section>

  method get-section-type ( --> GtkCssSectionType )

=end pod

method get-section-type ( --> GtkCssSectionType ) {
  GtkCssSectionType(
    gtk_css_section_get_section_type(self._get-native-object-no-reffing)
  )
}

sub gtk_css_section_get_section_type (
  N-GObject $section --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-start-line:
=begin pod
=head2 get-start-line

Returns the line in the CSS document where this section starts. The line number is 0-indexed, so the first line of the document will return 0.

Returns: the line number

  method get-start-line ( --> UInt )

=end pod

method get-start-line ( --> UInt ) {
  gtk_css_section_get_start_line(self._get-native-object-no-reffing)
}

sub gtk_css_section_get_start_line (
  N-GObject $section --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-start-position:
=begin pod
=head2 get-start-position

Returns the offset in bytes from the start of the current line returned via C<get-start-line()>.

Returns: the offset in bytes from the start of the line.

  method get-start-position ( --> UInt )

=end pod

method get-start-position ( --> UInt ) {
  gtk_css_section_get_start_position(self._get-native-object-no-reffing)
}

sub gtk_css_section_get_start_position (
  N-GObject $section --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_css_section_ref:
#`{{
=begin pod
=head2 ref

Increments the reference count on I<section>.

Returns: I<section> itself.

  method ref ( --> N-GObject )

=end pod

method ref ( --> N-GObject ) {
  gtk_css_section_ref(self._get-native-object-no-reffing)
}
}}

sub _gtk_css_section_ref (
  N-GObject $section --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_css_section_ref')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_css_section_unref:
#`{{
=begin pod
=head2 unref

Decrements the reference count on I<section>, freeing the structure if the reference count reaches 0.

  method unref ( )

=end pod

method unref ( ) {
  gtk_css_section_unref(self._get-native-object-no-reffing);
}
}}

sub _gtk_css_section_unref (
  N-GObject $section
) is native(&gtk-lib)
  is symbol('gtk_css_section_unref')
  { * }
