#TL:1:Gnome::Gtk3::RecentChooserDialog:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentChooserDialog

Displays recently used files in a dialog

![](images/recentchooserdialog.png)


=head1 Description

B<Gnome::Gtk3::RecentChooserDialog> is a dialog box suitable for displaying the recently used documents.  This widgets works by putting a B<Gnome::Gtk3::RecentChooserWidget> inside a B<Gnome::Gtk3::Dialog>. It exposes the B<Gnome::Gtk3::RecentChooserIface> interface, so you can use all the B<Gnome::Gtk3::RecentChooser> functions on the recent chooser dialog as well as those for B<Gnome::Gtk3::Dialog>.

Note that B<Gnome::Gtk3::RecentChooserDialog> does not have any methods of its own. Instead, you can use the functions added by the interface B<Gnome::Gtk3::RecentChooser>.


=head2 Typical usage

In the simplest of cases, you can use the following code to use
a B<Gnome::Gtk3::RecentChooserDialog> to select a recently used file:

  my Gnome::Gtk3::Window $top .= new;
  # … build up application window

  my Gnome::Gtk3::RecentChooserDialog $recent-dialog .= new(
    :title('Recent Documents'), :parent($top),
    :button-spec(
      'Select', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT
    )
  );

  # … later
  my Int $r = $recent-dialog.run;
  if $r ~~ GTK_RESPONSE_ACCEPT {
    my Gnome::Gtk3::RecentInfo $selected-item = $recent-dialog.get-uri;
    my Str $uri = $selected-item.get-uri;
    $selected-item.clear-object;
    # … do something with $uri
  }

  $recent-dialog.destroy;


=head2 See Also

B<Gnome::Gtk3::RecentChooser>, B<Gnome::Gtk3::Dialog>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentChooserDialog;
  also is Gnome::Gtk3::Dialog;
  also does Gnome::Gtk3::RecentChooser


=comment head2 Uml Diagram

=comment ![](plantuml/RecentChooserDialog.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::RecentChooserDialog:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::RecentChooserDialog;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::RecentChooserDialog class process the options
    self.bless( :GtkRecentChooserDialog, |c);
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
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Dialog:api<1>;
use Gnome::Gtk3::RecentChooser:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentChooserDialog:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Dialog;
also does Gnome::Gtk3::RecentChooser;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :title, :parent, :buttons, :manager

Creates a new B<Gnome::Gtk3::RecentChooserDialog>. This function is analogous to C<new()> from B<Gnome::Gtk3::Dialog>.

  multi method new (
    Str :$title!, N-GObject :$parent, N-GObject :$manager,
    List :$button-spec
  )

=item Str $title; Title of the dialog, or undefined
=item N-GObject $parent; Transient parent of the dialog, or undefined,
=item N-GObject $manager; a native B<Gnome::Gtk3::RecentManager>.
=item List $button-spec; a ittermittend list of button label and button reponse. The number elements are therefore always and even.number of items. For example: C<:button-spec( 'Select', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)>


=head3 :native-object

Create a RecentChooserDialog object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a RecentChooserDialog object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new(:title,:parent,:buttons,:manager):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RecentChooserDialog' or
    %options<GtkRecentChooserDialog> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<title> {
        my $pno = %options<parent> // N-GObject;
        $pno .= _get-native-object unless $pno ~~ N-GObject;
        my Str $title = %options<title> // Str;
        my @buttons = %options<button-spec> // ();
        if %options<manager>:exists {
          my $mno = %options<manager> // N-GObject;
          $mno .= _get-native-object-no-reffing unless $no ~~ N-GObject;
          $no = _gtk_recent_chooser_dialog_new_for_manager(
            $title, $pno, $mno, |@buttons
          );
        }

        else {
          $no = _gtk_recent_chooser_dialog_new(
            $title, $pno, |@buttons
          );
        }
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
        $no = _gtk_recent_chooser_dialog_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkRecentChooserDialog');
  }
}

#`{{
#-------------------------------------------------------------------------------
#TM:1:_gtk_recent_chooser_dialog_new:
#`{{
=begin pod
=head2 _gtk_recent_chooser_dialog_new

Creates a new B<Gnome::Gtk3::RecentChooserDialog>.  This function is analogous to C<gtk_dialog_new_with_buttons()>.

Returns: a new B<Gnome::Gtk3::RecentChooserDialog>

  method _gtk_recent_chooser_dialog_new (  Str  $title, N-GObject $parent,  Str  $first_button_text --> N-GObject )

=item  Str  $title; (allow-none): Title of the dialog, or C<Any>
=item N-GObject $parent; (allow-none): Transient parent of the dialog, or C<Any>,
=item  Str  $first_button_text; (allow-none): stock ID or text to go in the first button, or C<Any> @...: response ID for the first button, then additional (button, id) pairs, ending with C<Any>

=end pod
}}

sub _gtk_recent_chooser_dialog_new ( gchar-ptr $title, N-GObject $parent, gchar-ptr $first_button_text, Any $any = Any --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_chooser_dialog_new')
  { * }
}}
sub _gtk_recent_chooser_dialog_new (
  Str $title, N-GObject $parent, *@buttons
  --> N-GObject
) {
  # create parameter list and start with inserting fixed arguments
  my @parameterList = (
    Parameter.new(type => Str),         # $title
    Parameter.new(type => N-GObject),   # $parent
  );

  # check the button list parameters
  my CArray $native-bspec .= new;
  if @buttons.elems %% 2 {
    for @buttons -> Str $button-text, Int $response-code {
      # values not used here, just a check on type
      @parameterList.push(Parameter.new(type => Str));
      @parameterList.push(Parameter.new(type => GEnum));
    }
    # end list with a Nil
    @parameterList.push(Parameter.new(type => Pointer));
  }

  else {
    die X::Gnome.new(:message('Odd number of button specs'));
  }

  # create signature
  my Signature $signature .= new(
    :params(|@parameterList),
    :returns(N-GObject)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_recent_chooser_dialog_new', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( $title, $parent, |@buttons, Nil)
}

#`{{
#-------------------------------------------------------------------------------
#TM:1:_gtk_recent_chooser_dialog_new_for_manager:
#`{{
=begin pod
=head2 _gtk_recent_chooser_dialog_new_for_manager

Creates a new B<Gnome::Gtk3::RecentChooserDialog> with a specified recent manager.  This is useful if you have implemented your own recent manager, or if you have a customized instance of a B<Gnome::Gtk3::RecentManager> object.

Returns: a new B<Gnome::Gtk3::RecentChooserDialog>

  method _gtk_recent_chooser_dialog_new_for_manager (  Str  $title, N-GObject $parent, N-GObject $manager,  Str  $first_button_text --> N-GObject )

=item  Str  $title; (allow-none): Title of the dialog, or C<Any>
=item N-GObject $parent; (allow-none): Transient parent of the dialog, or C<Any>,
=item N-GObject $manager; a B<Gnome::Gtk3::RecentManager>
=item  Str  $first_button_text; (allow-none): stock ID or text to go in the first button, or C<Any> @...: response ID for the first button, then additional (button, id) pairs, ending with C<Any>

=end pod
}}

sub _gtk_recent_chooser_dialog_new_for_manager ( gchar-ptr $title, N-GObject $parent, N-GObject $manager, gchar-ptr $first_button_text, Any $any = Any --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_chooser_dialog_new_for_manager')
  { * }
}}

sub _gtk_recent_chooser_dialog_new_for_manager (
  Str $title, N-GObject $parent, N-GObject $manager, *@buttons
  --> N-GObject
) {
  # create parameter list and start with inserting fixed arguments
  my @parameterList = (
    Parameter.new(type => Str),         # $title
    Parameter.new(type => N-GObject),   # $parent
    Parameter.new(type => N-GObject),   # $manager
  );

  # check the button list parameters
  my CArray $native-bspec .= new;
  if @buttons.elems %% 2 {
    for @buttons -> Str $button-text, Int $response-code {
      # values not used here, just a check on type
      @parameterList.push(Parameter.new(type => Str));
      @parameterList.push(Parameter.new(type => GEnum));
    }

    # end list with a Nil
    @parameterList.push(Parameter.new(type => Pointer));
  }

  else {
    die X::Gnome.new(:message('Odd number of button specs'));
  }

  # create signature
  my Signature $signature .= new(
    :params(|@parameterList),
    :returns(N-GObject)
  );


  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal(
    &gtk-lib, 'gtk_recent_chooser_dialog_new_for_manager', Pointer
  );
  my Callable $f = nativecast( $signature, $ptr);

  $f( $title, $parent, $manager, |@buttons, Nil)
}
