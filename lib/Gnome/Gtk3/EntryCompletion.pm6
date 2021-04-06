#TL:1:Gnome::Gtk3::EntryCompletion:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::EntryCompletion

Completion functionality for GtkEntry

=comment ![](images/X.png)

=head1 Description

 B<Gnome::Gtk3::EntryCompletion> is an auxiliary object to be used in conjunction with B<Gnome::Gtk3::Entry> to provide the completion functionality. It implements the B<Gnome::Gtk3::CellLayout> interface, to allow the user to add extra cells to the B<Gnome::Gtk3::TreeView> with completion matches.

“Completion functionality” means that when the user modifies the text in the entry, B<Gnome::Gtk3::EntryCompletion> checks which rows in the model match the current content of the entry, and displays a list of matches. By default, the matching is done by comparing the entry text case-insensitively against the text column of the model (see C<set-text-column()>), but this can be overridden with a custom match function (see C<gtk-entry-completion-set-match-func()>).

When the user selects a completion, the content of the entry is updated. By default, the content of the entry is replaced by the text column of the model, but this can be overridden by connecting to the  I<match-selected> signal and updating the entry in the signal handler. Note that you should return C<True> from the signal handler to suppress the default behaviour.

To add completion functionality to an entry, use C<set-completion()> from B<Gnome::Gtk3::Entry>.

In addition to regular completion matches, which will be inserted into the entry when they are selected, B<Gnome::Gtk3::EntryCompletion> also allows to display “actions” in the popup window. Their appearance is similar to menuitems, to differentiate them clearly from completion strings. When an action is selected, the  I<action-activated> signal is emitted.

B<Gnome::Gtk3::EntryCompletion> uses a B<Gnome::Gtk3::TreeModelFilter> model to represent the subset of the entire model that is currently matching. While the GtkEntryCompletion signals I<match-selected> and I<cursor-on-match> take the original model and an iter pointing to that model as arguments, other callbacks and signals (such as B<Gnome::Gtk3::CellLayoutDataFuncs> or  I<apply-attributes>) will generally take the filter model as argument. As long as you are only calling C<gtk-tree-model-get()>, this will make no difference to you. If for some reason, you need the original model, use C<gtk-tree-model-filter-get-model()>. Don’t forget to use C<convert-iter-to-child-iter()> in B<Gnome::Gtk3::TreeModelFilter> to obtain a matching iter.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::EntryCompletion;
  also is Gnome::GObject::Object;
  also does Gnome::Gtk3::CellLayout;


=comment head2 Uml Diagram

=comment ![](plantuml/EntryCompletion.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::EntryCompletion;

  unit class MyGuiClass;
  also is Gnome::Gtk3::EntryCompletion;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::EntryCompletion class process the options
    self.bless( :GtkEntryCompletion, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::Object;

use Gnome::Gtk3::CellLayout;
use Gnome::Gtk3::Entry;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::EntryCompletion:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Object;
also does Gnome::Gtk3::CellLayout;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new EntryCompletion object.

  multi method new ( )


=head3 :area

Creates a new B<Gnome::Gtk3::EntryCompletion> object using the specified I<$area> to layout cells in the underlying B<Gnome::Gtk3::TreeViewColumn> for the drop-down menu.

  multi method new ( N-GObject :$area! )


=head3 :native-object

Create an EntryCompletion object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=begin comment
=head3 :build-id

Create a EntryCompletion object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end comment
=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:0:new(:area):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
# TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<no-matches>,
      :w1<insert-prefix action-activated>,
      :w2<match-selected cursor-on-match>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::EntryCompletion' #`{{ or %options<GtkEntryCompletion> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
#    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<area> {
        $no = %options<area>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        $no = _gtk_entry_completion_new_with_area($no);
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_entry_completion_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkEntryCompletion');
  }
}


#-------------------------------------------------------------------------------
#TM:0:complete:
=begin pod
=head2 complete

Requests a completion operation, or in other words a refiltering of the current list with completions, using the current key. The completion list view will be updated accordingly.

  method complete ( )

=end pod

method complete ( ) {
  gtk_entry_completion_complete(self.get-native-object-no-reffing);
}

sub gtk_entry_completion_complete (
  N-GObject $completion
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:compute-prefix:
=begin pod
=head2 compute-prefix

Computes the common prefix that is shared by all rows in in this entry completion that start with I<$key>. If no row matches I<$key>, C<undefined> will be returned. Note that a text column must have been set for this function to work, see C<set-text-column()> for details.

Returns: The common prefix all rows starting with I<$key> or C<undefined> if no row matches I<$key>.

  method compute-prefix ( Str $key --> Str )

=item Str $key; The text to complete for
=end pod

method compute-prefix ( Str $key --> Str ) {
  gtk_entry_completion_compute_prefix(
    self.get-native-object-no-reffing, $key
  )
}

sub gtk_entry_completion_compute_prefix (
  N-GObject $completion, gchar-ptr $key --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:delete-action:
=begin pod
=head2 delete-action

Deletes the action at I<$index> from in this entry completion’s action list.

Note that I<$index> is a relative position and the position of an action may have changed since it was inserted.

  method delete-action ( Int $index )

=item Int $index; the index of the item to delete
=end pod

method delete-action ( Int $index ) {
  gtk_entry_completion_delete_action(
    self.get-native-object-no-reffing, $index
  );
}

sub gtk_entry_completion_delete_action (
  N-GObject $completion, gint $index
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-completion-prefix:
=begin pod
=head2 get-completion-prefix

Get the original text entered by the user that triggered the completion or C<undefined> if there’s no completion ongoing.

Returns: the prefix for the current completion

  method get-completion-prefix ( --> Str )

=end pod

method get-completion-prefix ( --> Str ) {
  gtk_entry_completion_get_completion_prefix(
    self.get-native-object-no-reffing,
  )
}

sub gtk_entry_completion_get_completion_prefix (
  N-GObject $completion --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-entry:
=begin pod
=head2 get-entry

Gets the entry in this entry completion has been attached to.

Returns: The entry in this entry completion has been attached to

  method get-entry ( --> Gnome::Gtk3::Entry )

=end pod

method get-entry ( --> Gnome::Gtk3::Entry ) {
  Gnome::Gtk3::Entry.new(
    :native-object(
      gtk_entry_completion_get_entry(self.get-native-object-no-reffing)
    )
  )
}

sub gtk_entry_completion_get_entry (
  N-GObject $completion --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-inline-completion:
=begin pod
=head2 get-inline-completion

Returns whether the common prefix of the possible completions should be automatically inserted in the entry.

Returns: C<True> if inline completion is turned on

  method get-inline-completion ( --> Bool )

=end pod

method get-inline-completion ( --> Bool ) {
  gtk_entry_completion_get_inline_completion(
    self.get-native-object-no-reffing,
  ).Bool
}

sub gtk_entry_completion_get_inline_completion (
  N-GObject $completion --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-inline-selection:
=begin pod
=head2 get-inline-selection

Returns C<True> if inline-selection mode is turned on.

Returns: C<True> if inline-selection mode is on

  method get-inline-selection ( --> Bool )

=end pod

method get-inline-selection ( --> Bool ) {

  gtk_entry_completion_get_inline_selection(
    self.get-native-object-no-reffing,
  ).Bool
}

sub gtk_entry_completion_get_inline_selection (
  N-GObject $completion --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-minimum-key-length:
=begin pod
=head2 get-minimum-key-length

Returns the minimum key length as set for in this entry completion.

  method get-minimum-key-length ( --> Int )

=end pod

method get-minimum-key-length ( --> Int ) {
  gtk_entry_completion_get_minimum_key_length(
    self.get-native-object-no-reffing,
  )
}

sub gtk_entry_completion_get_minimum_key_length (
  N-GObject $completion --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-model:
=begin pod
=head2 get-model

Returns the model the B<Gnome::Gtk3::EntryCompletion> is using as data source. Returns C<undefined> if the model is unset.

Returns: A B<Gnome::Gtk3::TreeModel>, or C<undefined> if none is currently being used. The model can be any of TreeStore or ListStore.

  method get-model ( --> N-GObject )

=end pod

method get-model ( --> N-GObject ) {

  gtk_entry_completion_get_model(
    self.get-native-object-no-reffing,
  )
}

sub gtk_entry_completion_get_model (
  N-GObject $completion --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-popup-completion:
=begin pod
=head2 get-popup-completion

Returns whether the completions should be presented in a popup window.

Returns: C<True> if popup completion is turned on

  method get-popup-completion ( --> Bool )

=end pod

method get-popup-completion ( --> Bool ) {

  gtk_entry_completion_get_popup_completion(
    self.get-native-object-no-reffing,
  ).Bool
}

sub gtk_entry_completion_get_popup_completion (
  N-GObject $completion --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-popup-set-width:
=begin pod
=head2 get-popup-set-width

Returns whether the completion popup window will be resized to the width of the entry.

Returns: C<True> if the popup window will be resized to the width of the entry

  method get-popup-set-width ( --> Bool )

=end pod

method get-popup-set-width ( --> Bool ) {

  gtk_entry_completion_get_popup_set_width(
    self.get-native-object-no-reffing,
  ).Bool
}

sub gtk_entry_completion_get_popup_set_width (
  N-GObject $completion --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-popup-single-match:
=begin pod
=head2 get-popup-single-match

Returns whether the completion popup window will appear even if there is only a single match.

Returns: C<True> if the popup window will appear regardless of the number of matches

  method get-popup-single-match ( --> Bool )

=end pod

method get-popup-single-match ( --> Bool ) {

  gtk_entry_completion_get_popup_single_match(
    self.get-native-object-no-reffing,
  ).Bool
}

sub gtk_entry_completion_get_popup_single_match (
  N-GObject $completion --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-text-column:
=begin pod
=head2 get-text-column

Returns the column in the model of in this entry completion to get strings from. Returns -1 if no column is set.

  method get-text-column ( --> Int )

=end pod

method get-text-column ( --> Int ) {
  gtk_entry_completion_get_text_column(
    self.get-native-object-no-reffing,
  )
}

sub gtk_entry_completion_get_text_column (
  N-GObject $completion --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:insert-action-markup:
=begin pod
=head2 insert-action-markup

Inserts an action in in this entry completion’s action item list at position I<$index> with markup I<$markup>.

  method insert-action-markup ( Int $index, Str $markup )

=item Int $index; the index of the item to insert
=item Str $markup; markup of the item to insert
=end pod

method insert-action-markup ( Int $index, Str $markup ) {

  gtk_entry_completion_insert_action_markup(
    self.get-native-object-no-reffing, $index, $markup
  );
}

sub gtk_entry_completion_insert_action_markup (
  N-GObject $completion, gint $index, gchar-ptr $markup
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:insert-action-text:
=begin pod
=head2 insert-action-text

Inserts an action in in this entry completion’s action item list at position I<index> with text I<text>. If you want the action item to have markup, use C<insert-action-markup()>.

Note that I<index> is a relative position in the list of actions and the position of an action can change when deleting a different action.

  method insert-action-text ( Int $index, Str $text )

=item Int $index; the index of the item to insert
=item Str $text; text of the item to insert
=end pod

method insert-action-text ( Int $index, Str $text ) {

  gtk_entry_completion_insert_action_text(
    self.get-native-object-no-reffing, $index, $text
  );
}

sub gtk_entry_completion_insert_action_text (
  N-GObject $completion, gint $index, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:insert-prefix:
=begin pod
=head2 insert-prefix

Requests a prefix insertion.

  method insert-prefix ( )

=end pod

method insert-prefix ( ) {
  gtk_entry_completion_insert_prefix(self.get-native-object-no-reffing);
}

sub gtk_entry_completion_insert_prefix (
  N-GObject $completion
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-inline-completion:
=begin pod
=head2 set-inline-completion

Sets whether the common prefix of the possible completions should be automatically inserted in the entry.

  method set-inline-completion ( Bool $inline_completion )

=item Bool $inline_completion; C<True> to do inline completion
=end pod

method set-inline-completion ( Bool $inline_completion ) {

  gtk_entry_completion_set_inline_completion(
    self.get-native-object-no-reffing, $inline_completion
  );
}

sub gtk_entry_completion_set_inline_completion (
  N-GObject $completion, gboolean $inline_completion
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-inline-selection:
=begin pod
=head2 set-inline-selection

Sets whether it is possible to cycle through the possible completions inside the entry.

  method set-inline-selection ( Bool $inline_selection )

=item Bool $inline_selection; C<True> to do inline selection
=end pod

method set-inline-selection ( Bool $inline_selection ) {

  gtk_entry_completion_set_inline_selection(
    self.get-native-object-no-reffing, $inline_selection
  );
}

sub gtk_entry_completion_set_inline_selection (
  N-GObject $completion, gboolean $inline_selection
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-match-func:
=begin pod
=head2 set-match-func

Sets the match function for in this entry completion to be I<func>. The match function is used to determine if a row should or should not be in the completion list.

  method set-match-func ( GtkEntryCompletionMatchFunc $func, Pointer $func_data, GDestroyNotify $func_notify )

=item GtkEntryCompletionMatchFunc $func; the B<Gnome::Gtk3::EntryCompletionMatchFunc> to use
=item Pointer $func_data; user data for I<func>
=item GDestroyNotify $func_notify; destroy notify for I<func-data>.
=end pod

method set-match-func (
  GtkEntryCompletionMatchFunc $func,
  Pointer $func_data,
  GDestroyNotify $func_notify
) {

  gtk_entry_completion_set_match_func(
    self.get-native-object-no-reffing, $func, $func_data, $func_notify
  );
}

sub gtk_entry_completion_set_match_func (
  N-GObject $completion,

  Callable $func (          # GtkEntryCompletionMatchFunc
    N-GObject $completion,  # GtkEntryCompletion
    str $key,
    N-GObject $iter,        # GtkTreeIter
    gpointer $user_data
  ),
  gpointer $func_data,

  Callable $func_notify (   # GDestroyNotify
    gpointer $data
  )
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-minimum-key-length:
=begin pod
=head2 set-minimum-key-length

Requires the length of the search key for in this entry completion to be at least I<length>. This is useful for long lists, where completing using a small key takes a lot of time and will come up with meaningless results anyway (ie, a too large dataset).

  method set-minimum-key-length ( Int $length )

=item Int $length; the minimum length of the key in order to start completing
=end pod

method set-minimum-key-length ( Int $length ) {

  gtk_entry_completion_set_minimum_key_length(
    self.get-native-object-no-reffing, $length
  );
}

sub gtk_entry_completion_set_minimum_key_length (
  N-GObject $completion, gint $length
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-model:
=begin pod
=head2 set-model

Sets the model for a B<Gnome::Gtk3::EntryCompletion>. If in this entry completion already has a model set, it will remove it before setting the new model. If model is C<undefined>, then it will unset the model.

  method set-model ( N-GObject $model )

=item N-GObject $model; the B<Gnome::Gtk3::TreeModel>
=end pod

method set-model ( $model is copy ) {
  $model .= get-native-object-no-reffing unless $model ~~ N-GObject;

  gtk_entry_completion_set_model(
    self.get-native-object-no-reffing, $model
  );
}

sub gtk_entry_completion_set_model (
  N-GObject $completion, N-GObject $model
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-popup-completion:
=begin pod
=head2 set-popup-completion

Sets whether the completions should be presented in a popup window.

  method set-popup-completion ( Bool $popup_completion )

=item Bool $popup_completion; C<True> to do popup completion
=end pod

method set-popup-completion ( Bool $popup_completion ) {

  gtk_entry_completion_set_popup_completion(
    self.get-native-object-no-reffing, $popup_completion
  );
}

sub gtk_entry_completion_set_popup_completion (
  N-GObject $completion, gboolean $popup_completion
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-popup-set-width:
=begin pod
=head2 set-popup-set-width

Sets whether the completion popup window will be resized to be the same width as the entry.

  method set-popup-set-width ( Bool $popup_set_width )

=item Bool $popup_set_width; C<True> to make the width of the popup the same as the entry
=end pod

method set-popup-set-width ( Bool $popup_set_width ) {

  gtk_entry_completion_set_popup_set_width(
    self.get-native-object-no-reffing, $popup_set_width
  );
}

sub gtk_entry_completion_set_popup_set_width (
  N-GObject $completion, gboolean $popup_set_width
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-popup-single-match:
=begin pod
=head2 set-popup-single-match

Sets whether the completion popup window will appear even if there is only a single match. You may want to set this to C<False> if you are using inline completion.

  method set-popup-single-match ( Bool $popup_single_match )

=item Bool $popup_single_match; C<True> if the popup should appear even for a single match
=end pod

method set-popup-single-match ( Bool $popup_single_match ) {

  gtk_entry_completion_set_popup_single_match(
    self.get-native-object-no-reffing, $popup_single_match
  );
}

sub gtk_entry_completion_set_popup_single_match (
  N-GObject $completion, gboolean $popup_single_match
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-text-column:
=begin pod
=head2 set-text-column

Convenience function for setting up the most used case of this code: a completion list with just strings. This function will set up in this entry completion to have a list displaying all (and just) strings in the completion list, and to get those strings from I<column> in the model of in this entry completion.

This functions creates and adds a B<Gnome::Gtk3::CellRendererText> for the selected column. If you need to set the text column, but don't want the cell renderer, use C<g-object-set()> to set the  I<text-column> property directly.

  method set-text-column ( Int $column )

=item Int $column; the column in the model of this entry completion to get strings from
=end pod

method set-text-column ( Int $column ) {

  gtk_entry_completion_set_text_column(
    self.get-native-object-no-reffing, $column
  );
}

sub gtk_entry_completion_set_text_column (
  N-GObject $completion, gint $column
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_entry_completion_new:
#`{{
=begin pod
=head2 _gtk_entry_completion_new

Creates a new B<Gnome::Gtk3::EntryCompletion> object.

Returns: A newly created B<Gnome::Gtk3::EntryCompletion> object

  method _gtk_entry_completion_new ( --> N-GObject )

=end pod
}}

sub _gtk_entry_completion_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_entry_completion_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_entry_completion_new_with_area:
#`{{
=begin pod
=head2 _gtk_entry_completion_new_with_area

Creates a new B<Gnome::Gtk3::EntryCompletion> object using the specified I<area> to layout cells in the underlying B<Gnome::Gtk3::TreeViewColumn> for the drop-down menu.

Returns: A newly created B<Gnome::Gtk3::EntryCompletion> object

  method _gtk_entry_completion_new_with_area ( N-GObject $area --> N-GObject )

=item N-GObject $area; the B<Gnome::Gtk3::CellArea> used to layout cells
=end pod
}}

sub _gtk_entry_completion_new_with_area ( N-GObject $area --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_entry_completion_new_with_area')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment -----------------------------------------------------------------------
=comment #TS:0:action-activated:
=head3 action-activated

Gets emitted when an action is activated.


  method handler (
    Int $index,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $index; the index of the activated action


=comment -----------------------------------------------------------------------
=comment #TS:0:cursor-on-match:
=head3 cursor-on-match

Gets emitted when a match from the cursor is on a match of the list. The default behaviour is to replace the contents of the entry with the contents of the text column in the row pointed to by I<iter>.

Note that I<model> is the model that was passed to C<set-model()>.

Returns: C<True> if the signal has been handled

  method handler (
    Unknown type GTK_TYPE_TREE_MODEL $model,
    N-GtkTreeIter #`{ native Gnome::Gtk3::TreeIter } $iter,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $model; the B<Gnome::Gtk3::TreeModel> containing the matches

=item $iter; a B<Gnome::Gtk3::TreeIter> positioned at the selected match


=comment -----------------------------------------------------------------------
=comment #TS:0:insert-prefix:
=head3 insert-prefix

Gets emitted when the inline autocompletion is triggered. The default behaviour is to make the entry display the whole prefix and select the newly inserted part.

Applications may connect to this signal in order to insert only a smaller part of the I<prefix> into the entry - e.g. the entry used in the B<Gnome::Gtk3::FileChooser> inserts only the part of the prefix up to the next '/'.

Returns: C<True> if the signal has been handled


  method handler (
    Str $prefix,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $prefix; the common prefix of all possible completions


=comment -----------------------------------------------------------------------
=comment #TS:0:match-selected:
=head3 match-selected

Gets emitted when a match from the list is selected. The default behaviour is to replace the contents of the entry with the contents of the text column in the row pointed to by I<iter>.

Note that I<model> is the model that was passed to C<set-model()>.

Returns: C<True> if the signal has been handled

  method handler (
    Unknown type GTK_TYPE_TREE_MODEL $model,
    N-GtkTreeIter #`{ native Gnome::Gtk3::TreeIter } $iter,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $model; the B<Gnome::Gtk3::TreeModel> containing the matches

=item $iter; a B<Gnome::Gtk3::TreeIter> positioned at the selected match


=comment -----------------------------------------------------------------------
=comment #TS:0:no-matches:
=head3 no-matches

Gets emitted when the filter model has zero number of rows in completion-complete method. (In other words when GtkEntryCompletion is out of suggestions)


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:cell-area:
=head3 Cell Area: cell-area

The B<Gnome::Gtk3::CellArea> used to layout cell renderers in the treeview column.

If no area is specified when creating the entry completion with C<new-with-area()> a horizontally oriented B<Gnome::Gtk3::CellAreaBox> will be used.

   Widget type: GTK_TYPE_CELL_AREA

The B<Gnome::GObject::Value> type of property I<cell-area> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:inline-completion:
=head3 Inline completion: inline-completion

Determines whether the common prefix of the possible completions should be inserted automatically in the entry. Note that this requires text-column to be set, even if you are using a custom match function.

The B<Gnome::GObject::Value> type of property I<inline-completion> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:inline-selection:
=head3 Inline selection: inline-selection

Determines whether the possible completions on the popup will appear in the entry as you navigate through them.

The B<Gnome::GObject::Value> type of property I<inline-selection> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:minimum-key-length:
=head3 Minimum Key Length: minimum-key-length

The B<Gnome::GObject::Value> type of property I<minimum-key-length> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:model:
=head3 Completion Model: model

The model to find matches in Widget type: GTK-TYPE-TREE-MODEL

The B<Gnome::GObject::Value> type of property I<model> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:popup-completion:
=head3 Popup completion: popup-completion

Determines whether the possible completions should be
shown in a popup window.

The B<Gnome::GObject::Value> type of property I<popup-completion> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:popup-set-width:
=head3 Popup set width: popup-set-width

Determines whether the completions popup window will be resized to the width of the entry.

The B<Gnome::GObject::Value> type of property I<popup-set-width> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:popup-single-match:
=head3 Popup single match: popup-single-match

Determines whether the completions popup window will shown for a single possible completion. You probably want to set this to C<False> if you are using [inline completion][GtkEntryCompletion--inline-completion].

The B<Gnome::GObject::Value> type of property I<popup-single-match> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:text-column:
=head3 Text column: text-column

The column of the model containing the strings. Note that the strings must be UTF-8.

The B<Gnome::GObject::Value> type of property I<text-column> is C<G_TYPE_INT>.
=end pod
