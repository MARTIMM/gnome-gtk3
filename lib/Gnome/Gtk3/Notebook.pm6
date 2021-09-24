#TL:1:Gnome::Gtk3::Notebook:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Notebook

A tabbed notebook container

![](images/notebook.png)

=head1 Description

The B<Gnome::Gtk3::Notebook> widget is a B<Gnome::Gtk3::Container> whose children are pages that can be switched between using tab labels along one edge.

There are many configuration options for B<Gnome::Gtk3::Notebook>. Among other things, you can choose on which edge the tabs appear (see C<gtk_notebook_set_tab_pos()>), whether, if there are too many tabs to fit the notebook should be made bigger or scrolling arrows added (see C<gtk_notebook_set_scrollable()>), and whether there will be a popup menu allowing the users to switch pages. (see C<gtk_notebook_popup_enable()>, C<gtk_notebook_popup_disable()>)


=head2 B<Gnome::Gtk3::Notebook> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::Notebook> implementation of the B<Gnome::Gtk3::Buildable> interface supports placing children into tabs by specifying “tab” as the “type” attribute of a <child> element. Note that the content of the tab must be created before the tab can be filled. A tab child can be specified without specifying a <child> type attribute.

To add a child widget in the notebooks action area, specify "action-start" or “action-end” as the “type” attribute of the <child> element.

An example of a UI definition fragment with B<Gnome::Gtk3::Notebook>:

  <object class="GtkNotebook">
    <child>
      <object class="GtkLabel" id="notebook-content">
        <property name="label">Content</property>
      </object>
    </child>
    <child type="tab">
      <object class="GtkLabel" id="notebook-tab">
        <property name="label">Tab</property>
      </object>
    </child>
  </object>


=head2 Css Nodes

  notebook
  ├── header.top
  │   ├── [<action widget>]
  │   ├── tabs
  │   │   ├── [arrow]
  │   │   ├── tab
  │   │   │   ╰── <tab label>
  ┊   ┊   ┊
  │   │   ├── tab[.reorderable-page]
  │   │   │   ╰── <tab label>
  │   │   ╰── [arrow]
  │   ╰── [<action widget>]
  │
  ╰── stack
      ├── <child>
      ┊
      ╰── <child>

B<Gnome::Gtk3::Notebook> has a main CSS node with name notebook, a subnode with name header and below that a subnode with name tabs which contains one subnode per tab with name tab.

If action widgets are present, their CSS nodes are placed next to the tabs node. If the notebook is scrollable, CSS nodes with name arrow are placed as first and last child of the tabs node.

The main node gets the .frame style class when the notebook has a border (see C<gtk_notebook_set_show_border()>).

The header node gets one of the style class .top, .bottom, .left or .right, depending on where the tabs are placed. For reorderable pages, the tab node gets the .reorderable-page class.

A tab node gets the .dnd style class while it is moved with drag-and-drop.

The nodes are always arranged from left-to-right, regardless of text direction.


=head2 See Also

B<Gnome::Gtk3::Container>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Notebook;
  also is Gnome::Gtk3::Container;


=head2 Uml Diagram

![](plantuml/Notebook.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Notebook;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Notebook;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Notebook class process the options
    self.bless( :GtkNotebook, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::Object;

use Gnome::Gtk3::Container;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Notebook:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new Notebook object.

  multi method new ( )


=head3 :native-object

Create a Notebook object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Notebook object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting:
#TM:1:new():
#TM:4:new(:native-object):TopLevelClassSupport
#TM:4:new(:build-id):Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<page-reordered page-removed page-added create-window>,
      :w2<switch-page reorder-tab page-reordered page-removed page-added>,
      :w3<create-window>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Notebook' or %options<GtkNotebook> {

    # process all named arguments
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other arguments
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_notebook_new___x___($no);
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_notebook_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkNotebook');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_notebook_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkNotebook');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:append-page:
=begin pod
=head2 append-page

Appends a page to I<notebook>.

Returns: the index (starting from 0) of the appended page in the notebook, or -1 if function fails

  method append-page (
    N-GObject $child, N-GObject $tab_label --> Int
  )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<undefined> to use the default label, “page N”
=end pod

method append-page ( $child is copy, $tab_label is copy --> Int ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $tab_label .= get-native-object-no-reffing unless $tab_label ~~ N-GObject;

  gtk_notebook_append_page(
    self.get-native-object-no-reffing, $child, $tab_label
  )
}

sub gtk_notebook_append_page (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:append-page-menu:
=begin pod
=head2 append-page-menu

Appends a page to I<notebook>, specifying the widget to use as the label in the popup menu.

Returns: the index (starting from 0) of the appended page in the notebook, or -1 if function fails

  method append-page-menu (
    N-GObject $child, N-GObject $tab_label, N-GObject $menu_label
    --> Int
  )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<undefined> to use the default label, “page N”
=item N-GObject $menu_label; the widget to use as a label for the page-switch menu, if that is enabled. If C<undefined>, and I<$tab-label> is a B<Gnome::Gtk3::Label> or C<undefined>, then the menu label will be a newly created label with the same text as I<$tab-label>; if I<$tab-label> is not a B<Gnome::Gtk3::Label>, I<$menu-label> must be specified if the page-switch menu is to be used.
=end pod

method append-page-menu (
  $child is copy, $tab_label is copy, $menu_label is copy
  --> Int
) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $tab_label .= get-native-object-no-reffing unless $tab_label ~~ N-GObject;
  $menu_label .= get-native-object-no-reffing unless $menu_label ~~ N-GObject;

  gtk_notebook_append_page_menu(
    self.get-native-object-no-reffing, $child, $tab_label, $menu_label
  )
}

sub gtk_notebook_append_page_menu (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:detach-tab:
=begin pod
=head2 detach-tab

Removes the child from the notebook.

This function is very similar to C<Gnome::Gtk3::Container.remove()>, but additionally informs the notebook that the removal is happening as part of a tab DND operation, which should not be cancelled.

  method detach-tab ( N-GObject $child )

=item N-GObject $child; a child
=end pod

method detach-tab ( $child is copy ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_detach_tab(
    self.get-native-object-no-reffing, $child
  );
}

sub gtk_notebook_detach_tab (
  N-GObject $notebook, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-action-widget:
#TM:1:get-action-widget-rk:
=begin pod
=head2 get-action-widget, get-action-widget-rk

Gets one of the action widgets. See C<set-action-widget()>.

Returns: The action widget with the given I<$pack-type> or C<undefined> when this action widget has not been set

  method get-action-widget ( GtkPackType $pack_type --> N-GObject )

  method get-action-widget-rk (
    GtkPackType $pack_type, :$child-type? --> Gnome::GObject::Object
  )

=item GtkPackType $pack_type; pack type of the action widget to receive
=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.

=end pod

method get-action-widget ( GtkPackType $pack_type --> N-GObject ) {
  gtk_notebook_get_action_widget(
    self.get-native-object-no-reffing, $pack_type
  )
}

method get-action-widget-rk (
  GtkPackType $pack_type, *%options --> Gnome::GObject::Object
) {
  self._wrap-native-type-from-no(
    gtk_notebook_get_action_widget(
      self.get-native-object-no-reffing, $pack_type
    ), |%options
  )
}

sub gtk_notebook_get_action_widget (
  N-GObject $notebook, GEnum $pack_type --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-current-page:
=begin pod
=head2 get-current-page

Returns the page number of the current page.

Returns: the index (starting from 0) of the current page in the notebook. If the notebook has no pages, then -1 will be returned.

  method get-current-page ( --> Int )

=end pod

method get-current-page ( --> Int ) {
  gtk_notebook_get_current_page(self.get-native-object-no-reffing)
}

sub gtk_notebook_get_current_page (
  N-GObject $notebook --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-group-name:
=begin pod
=head2 get-group-name

Gets the current group name for I<notebook>.

Returns: the group name, or C<undefined> if none is set

  method get-group-name ( --> Str )

=end pod

method get-group-name ( --> Str ) {
  gtk_notebook_get_group_name(self.get-native-object-no-reffing)
}

sub gtk_notebook_get_group_name (
  N-GObject $notebook --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-menu-label:
#TM:1:get-menu-label-rk:
=begin pod
=head2 get-menu-label, get-menu-label-rk

Retrieves the menu label widget of the page containing I<$child>.

Returns: the menu label, or C<undefined> if the notebook page does not have a menu label other than the default (the tab label).

  method get-menu-label ( N-GObject $child --> N-GObject )
  method get-menu-label-rk (
    N-GObject $child, :$child-type? --> Gnome::GObject::Object
  )

=item N-GObject $child; a widget contained in a page of I<notebook>
=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.
=end pod

method get-menu-label ( $child is copy --> N-GObject ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  gtk_notebook_get_menu_label( self.get-native-object-no-reffing, $child)
}

method get-menu-label-rk (
  $child is copy, *%options --> Gnome::GObject::Object
) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  self._wrap-native-type-from-no(
    gtk_notebook_get_menu_label( self.get-native-object-no-reffing, $child),
    |%options
  );
}

sub gtk_notebook_get_menu_label (
  N-GObject $notebook, N-GObject $child --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-menu-label-text:
=begin pod
=head2 get-menu-label-text

Retrieves the text of the menu label for the page containing I<$child>.

Returns: the text of the tab label, or C<undefined> if the widget does not have a menu label other than the default menu label, or the menu label widget is not a B<Gnome::Gtk3::Label>. The string is owned by the widget and must not be freed.

  method get-menu-label-text ( N-GObject $child --> Str )

=item N-GObject $child; the child widget of a page of the notebook.
=end pod

method get-menu-label-text ( $child is copy --> Str ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_get_menu_label_text(
    self.get-native-object-no-reffing, $child
  )
}

sub gtk_notebook_get_menu_label_text (
  N-GObject $notebook, N-GObject $child --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-n-pages:
=begin pod
=head2 get-n-pages

Gets the number of pages in a notebook.

Returns: the number of pages in the notebook

  method get-n-pages ( --> Int )

=end pod

method get-n-pages ( --> Int ) {
  gtk_notebook_get_n_pages(self.get-native-object-no-reffing)
}

sub gtk_notebook_get_n_pages (
  N-GObject $notebook --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-nth-page:
#TM:1:get-nth-page-rk:
=begin pod
=head2 get-nth-page, get-nth-page-rk

Returns the child widget contained in page number I<$page-num>.

Returns: the child widget, or C<undefined> if I<$page-num> is out of bounds

  method get-nth-page ( Int() $page_num --> N-GObject )
  method get-nth-page-rk (
    Int() $page_num, :$child-type? --> Gnome::GObject::Object
  )

=item Int() $page_num; the index of a page in the notebook, or -1 to get the last page
=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.
=end pod

method get-nth-page ( Int() $page_num --> N-GObject ) {
  gtk_notebook_get_nth_page( self.get-native-object-no-reffing, $page_num)
}

method get-nth-page-rk (
  Int() $page_num, *%options --> Gnome::GObject::Object
) {
  self._wrap-native-type-from-no(
    gtk_notebook_get_nth_page( self.get-native-object-no-reffing, $page_num),
    |%options
  )
}

sub gtk_notebook_get_nth_page (
  N-GObject $notebook, gint $page_num --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-scrollable:
=begin pod
=head2 get-scrollable

Returns whether the tab label area has arrows for scrolling. See C<set-scrollable()>.

Returns: C<True> if arrows for scrolling are present

  method get-scrollable ( --> Bool )

=end pod

method get-scrollable ( --> Bool ) {
  gtk_notebook_get_scrollable(self.get-native-object-no-reffing).Bool
}

sub gtk_notebook_get_scrollable (
  N-GObject $notebook --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-border:
=begin pod
=head2 get-show-border

Returns whether a bevel will be drawn around the notebook pages. See C<set-show-border()>.

Returns: C<True> if the bevel is drawn

  method get-show-border ( --> Bool )

=end pod

method get-show-border ( --> Bool ) {
  gtk_notebook_get_show_border(self.get-native-object-no-reffing).Bool
}

sub gtk_notebook_get_show_border (
  N-GObject $notebook --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-tabs:
=begin pod
=head2 get-show-tabs

Returns whether the tabs of the notebook are shown. See C<set-show-tabs()>.

Returns: C<True> if the tabs are shown

  method get-show-tabs ( --> Bool )

=end pod

method get-show-tabs ( --> Bool ) {
  gtk_notebook_get_show_tabs(self.get-native-object-no-reffing).Bool
}

sub gtk_notebook_get_show_tabs (
  N-GObject $notebook --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-tab-detachable:
=begin pod
=head2 get-tab-detachable

Returns whether the tab contents can be detached from I<notebook>.

Returns: C<True> if the tab is detachable.

  method get-tab-detachable ( N-GObject $child --> Bool )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>
=end pod

method get-tab-detachable ( $child is copy --> Bool ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  gtk_notebook_get_tab_detachable(
    self.get-native-object-no-reffing, $child
  ).Bool
}

sub gtk_notebook_get_tab_detachable (
  N-GObject $notebook, N-GObject $child --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-tab-label:
#TM:1:get-tab-label-rk:
=begin pod
=head2 get-tab-label, get-tab-label-rk

Returns the tab label widget for the page I<$$child>. C<undefined> is returned if I<$$child> is not in I<notebook> or if no tab label has specifically been set for I<$$child>.

Returns: the tab label

  method get-tab-label ( N-GObject $child --> N-GObject )
  method get-tab-label-rk (
    N-GObject $child, :$child-type? --> Gnome::GObject::Object
  )

=item N-GObject $child; the page
=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.
=end pod

method get-tab-label ( $child is copy --> N-GObject ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  gtk_notebook_get_tab_label( self.get-native-object-no-reffing, $child)
}

method get-tab-label-rk (
  $child is copy, *%options --> Gnome::GObject::Object
) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  self._wrap-native-type-from-no(
    gtk_notebook_get_tab_label( self.get-native-object-no-reffing, $child),
    |%options
  )
}

sub gtk_notebook_get_tab_label (
  N-GObject $notebook, N-GObject $child --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-tab-label-text:
=begin pod
=head2 get-tab-label-text

Retrieves the text of the tab label for the page containing I<$child>.

Returns: the text of the tab label, or C<undefined> if the tab label widget is not a B<Gnome::Gtk3::Label>. The string is owned by the widget and must not be freed.

  method get-tab-label-text ( N-GObject $child --> Str )

=item N-GObject $child; a widget contained in a page of I<notebook>
=end pod

method get-tab-label-text ( $child is copy --> Str ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  gtk_notebook_get_tab_label_text( self.get-native-object-no-reffing, $child)
}

sub gtk_notebook_get_tab_label_text (
  N-GObject $notebook, N-GObject $child --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-tab-pos:
=begin pod
=head2 get-tab-pos

Gets the edge at which the tabs for switching pages in the notebook are drawn.

Returns: the edge at which the tabs are drawn

  method get-tab-pos ( --> GtkPositionType )

=end pod

method get-tab-pos ( --> GtkPositionType ) {
  GtkPositionType(gtk_notebook_get_tab_pos(self.get-native-object-no-reffing))
}

sub gtk_notebook_get_tab_pos (
  N-GObject $notebook --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-tab-reorderable:
=begin pod
=head2 get-tab-reorderable

Gets whether the tab can be reordered via drag and drop or not.

Returns: C<True> if the tab is reorderable.

  method get-tab-reorderable ( N-GObject $child --> Bool )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>
=end pod

method get-tab-reorderable ( $child is copy --> Bool ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_get_tab_reorderable(
    self.get-native-object-no-reffing, $child
  ).Bool
}

sub gtk_notebook_get_tab_reorderable (
  N-GObject $notebook, N-GObject $child --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:insert-page:
=begin pod
=head2 insert-page

Insert a page into I<notebook> at the given position.

Returns: the index (starting from 0) of the inserted page in the notebook, or -1 if function fails

  method insert-page (
    N-GObject $child, N-GObject $tab_label, Int() $position
    --> Int
  )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<undefined> to use the default label, “page N”
=item Int() $position; the index (starting at 0) at which to insert the page, or -1 to append the page after all other pages
=end pod

method insert-page ( $child is copy, $tab_label is copy, Int() $position --> Int ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $tab_label .= get-native-object-no-reffing unless $tab_label ~~ N-GObject;

  gtk_notebook_insert_page(
    self.get-native-object-no-reffing, $child, $tab_label, $position
  )
}

sub gtk_notebook_insert_page (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label, gint $position --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:insert-page-menu:
=begin pod
=head2 insert-page-menu

Insert a page into I<notebook> at the given position, specifying the widget to use as the label in the popup menu.

Returns: the index (starting from 0) of the inserted page in the notebook

  method insert-page-menu (
    N-GObject $child, N-GObject $tab_label,
    N-GObject $menu_label, Int() $position
    --> Int
  )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<undefined> to use the default label, “page N”
=item N-GObject $menu_label; the widget to use as a label for the page-switch menu, if that is enabled. If C<undefined>, and I<$tab-label> is a B<Gnome::Gtk3::Label> or C<undefined>, then the menu label will be a newly created label with the same text as I<$tab-label>; if I<$tab-label> is not a B<Gnome::Gtk3::Label>, I<$menu-label> must be specified if the page-switch menu is to be used.
=item Int() $position; the index (starting at 0) at which to insert the page, or -1 to append the page after all other pages.
=end pod

method insert-page-menu ( $child is copy, $tab_label is copy, $menu_label is copy, Int() $position --> Int ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $tab_label .= get-native-object-no-reffing unless $tab_label ~~ N-GObject;
  $menu_label .= get-native-object-no-reffing unless $menu_label ~~ N-GObject;

  gtk_notebook_insert_page_menu(
    self.get-native-object-no-reffing,
    $child, $tab_label, $menu_label, $position
  )
}

sub gtk_notebook_insert_page_menu (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label, N-GObject $menu_label, gint $position --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:next-page:
=begin pod
=head2 next-page

Switches to the next page. Nothing happens if the current page is the last page.

  method next-page ( )

=end pod

method next-page ( ) {
  gtk_notebook_next_page(self.get-native-object-no-reffing);
}

sub gtk_notebook_next_page (
  N-GObject $notebook
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:page-num:
=begin pod
=head2 page-num

Finds the index of the page which contains the given child widget.

Returns: the index of the page containing I<$child>, or -1 if I<$child> is not in the notebook

  method page-num ( N-GObject $child --> Int )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>
=end pod

method page-num ( $child is copy --> Int ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_page_num(
    self.get-native-object-no-reffing, $child
  )
}

sub gtk_notebook_page_num (
  N-GObject $notebook, N-GObject $child --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:popup-disable:
=begin pod
=head2 popup-disable

Disables the popup menu.

  method popup-disable ( )

=end pod

method popup-disable ( ) {
  gtk_notebook_popup_disable(self.get-native-object-no-reffing);
}

sub gtk_notebook_popup_disable (
  N-GObject $notebook
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:popup-enable:
=begin pod
=head2 popup-enable

Enables the popup menu: if the user clicks with the right mouse button on the tab labels, a menu with all the pages will be popped up.

  method popup-enable ( )

=end pod

method popup-enable ( ) {

  gtk_notebook_popup_enable(
    self.get-native-object-no-reffing,
  );
}

sub gtk_notebook_popup_enable (
  N-GObject $notebook
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:prepend-page:
=begin pod
=head2 prepend-page

Prepends a page to I<notebook>.

Returns: the index (starting from 0) of the prepended page in the notebook, or -1 if function fails

  method prepend-page ( N-GObject $child, N-GObject $tab_label --> Int )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<undefined> to use the default label, “page N”
=end pod

method prepend-page ( $child is copy, $tab_label is copy --> Int ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $tab_label .= get-native-object-no-reffing unless $tab_label ~~ N-GObject;

  gtk_notebook_prepend_page(
    self.get-native-object-no-reffing, $child, $tab_label
  )
}

sub gtk_notebook_prepend_page (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:prepend-page-menu:
=begin pod
=head2 prepend-page-menu

Prepends a page to I<notebook>, specifying the widget to use as the label in the popup menu.

Returns: the index (starting from 0) of the prepended page in the notebook, or -1 if function fails

  method prepend-page-menu ( N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> Int )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<undefined> to use the default label, “page N”
=item N-GObject $menu_label; the widget to use as a label for the page-switch menu, if that is enabled. If C<undefined>, and I<$tab-label> is a B<Gnome::Gtk3::Label> or C<undefined>, then the menu label will be a newly created label with the same text as I<$tab-label>; if I<$tab-label> is not a B<Gnome::Gtk3::Label>, I<$menu-label> must be specified if the page-switch menu is to be used.
=end pod

method prepend-page-menu ( $child is copy, $tab_label is copy, $menu_label is copy --> Int ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $tab_label .= get-native-object-no-reffing unless $tab_label ~~ N-GObject;
  $menu_label .= get-native-object-no-reffing unless $menu_label ~~ N-GObject;

  gtk_notebook_prepend_page_menu(
    self.get-native-object-no-reffing, $child, $tab_label, $menu_label
  )
}

sub gtk_notebook_prepend_page_menu (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:prev-page:
=begin pod
=head2 prev-page

Switches to the previous page. Nothing happens if the current page is the first page.

  method prev-page ( )

=end pod

method prev-page ( ) {

  gtk_notebook_prev_page(
    self.get-native-object-no-reffing,
  );
}

sub gtk_notebook_prev_page (
  N-GObject $notebook
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove-page:
=begin pod
=head2 remove-page

Removes a page from the notebook given its index in the notebook.

  method remove-page ( Int() $page_num )

=item Int() $page_num; the index of a notebook page, starting from 0. If -1, the last page will be removed.
=end pod

method remove-page ( Int() $page_num ) {

  gtk_notebook_remove_page(
    self.get-native-object-no-reffing, $page_num
  );
}

sub gtk_notebook_remove_page (
  N-GObject $notebook, gint $page_num
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:reorder-child:
=begin pod
=head2 reorder-child

Reorders the page containing I<$child>, so that it appears in position I<$position>. If I<$position> is greater than or equal to the number of children in the list or negative, I<$child> will be moved to the end of the list.

  method reorder-child ( N-GObject $child, Int() $position )

=item N-GObject $child; the child to move
=item Int() $position; the new position, or -1 to move to the end
=end pod

method reorder-child ( $child is copy, Int() $position ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_reorder_child(
    self.get-native-object-no-reffing, $child, $position
  );
}

sub gtk_notebook_reorder_child (
  N-GObject $notebook, N-GObject $child, gint $position
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-action-widget:
=begin pod
=head2 set-action-widget

Sets I<$widget> as one of the action widgets. Depending on the pack type the widget will be placed before or after the tabs. You can use a B<Gnome::Gtk3::Box> if you need to pack more than one widget on the same side.

Note that action widgets are “internal” children of the notebook and thus not included in the list returned from C<gtk-container-foreach()>.

  method set-action-widget ( N-GObject $widget, GtkPackType $pack_type )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item GtkPackType $pack_type; pack type of the action widget
=end pod

method set-action-widget ( $widget is copy, GtkPackType $pack_type ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_notebook_set_action_widget(
    self.get-native-object-no-reffing, $widget, $pack_type
  );
}

sub gtk_notebook_set_action_widget (
  N-GObject $notebook, N-GObject $widget, GEnum $pack_type
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-current-page:
=begin pod
=head2 set-current-page

Switches to the page number I<$page-num>.

Note that due to historical reasons, GtkNotebook refuses to switch to a page unless the child widget is visible. Therefore, it is recommended to show child widgets before adding them to a notebook.

  method set-current-page ( Int() $page_num )

=item Int() $page_num; index of the page to switch to, starting from 0. If negative, the last page will be used. If greater than the number of pages in the notebook, nothing will be done.
=end pod

method set-current-page ( Int() $page_num ) {

  gtk_notebook_set_current_page(
    self.get-native-object-no-reffing, $page_num
  );
}

sub gtk_notebook_set_current_page (
  N-GObject $notebook, gint $page_num
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-group-name:
=begin pod
=head2 set-group-name

Sets a group name for I<notebook>.

Notebooks with the same name will be able to exchange tabs via drag and drop. A notebook with a C<undefined> group name will not be able to exchange tabs with any other notebook.

  method set-group-name ( Str $group_name )

=item Str $group_name; the name of the notebook group, or C<undefined> to unset it
=end pod

method set-group-name ( Str $group_name ) {
  gtk_notebook_set_group_name( self.get-native-object-no-reffing, $group_name);
}

sub gtk_notebook_set_group_name (
  N-GObject $notebook, gchar-ptr $group_name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-menu-label:
=begin pod
=head2 set-menu-label

Changes the menu label for the page containing I<$child>.

  method set-menu-label ( N-GObject $child, N-GObject $menu_label )

=item N-GObject $child; the child widget
=item N-GObject $menu_label; the menu label, or C<undefined> for default
=end pod

method set-menu-label ( $child is copy, $menu_label is copy ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $menu_label .= get-native-object-no-reffing unless $menu_label ~~ N-GObject;

  gtk_notebook_set_menu_label(
    self.get-native-object-no-reffing, $child, $menu_label
  );
}

sub gtk_notebook_set_menu_label (
  N-GObject $notebook, N-GObject $child, N-GObject $menu_label
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-menu-label-text:
=begin pod
=head2 set-menu-label-text

Creates a new label and sets it as the menu label of I<$child>.

  method set-menu-label-text ( N-GObject $child, Str $menu_text )

=item N-GObject $child; the child widget
=item Str $menu_text; the label text
=end pod

method set-menu-label-text ( $child is copy, Str $menu_text ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_set_menu_label_text(
    self.get-native-object-no-reffing, $child, $menu_text
  );
}

sub gtk_notebook_set_menu_label_text (
  N-GObject $notebook, N-GObject $child, gchar-ptr $menu_text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-scrollable:
=begin pod
=head2 set-scrollable

Sets whether the tab label area will have arrows for scrolling if there are too many tabs to fit in the area.

  method set-scrollable ( Bool $scrollable )

=item Bool $scrollable; C<True> if scroll arrows should be added
=end pod

method set-scrollable ( Bool $scrollable ) {
  gtk_notebook_set_scrollable( self.get-native-object-no-reffing, $scrollable);
}

sub gtk_notebook_set_scrollable (
  N-GObject $notebook, gboolean $scrollable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-border:
=begin pod
=head2 set-show-border

Sets whether a bevel will be drawn around the notebook pages. This only has a visual effect when the tabs are not shown. See C<set-show-tabs()>.

  method set-show-border ( Bool $show_border )

=item Bool $show_border; C<True> if a bevel should be drawn around the notebook
=end pod

method set-show-border ( Bool $show_border ) {

  gtk_notebook_set_show_border(
    self.get-native-object-no-reffing, $show_border
  );
}

sub gtk_notebook_set_show_border (
  N-GObject $notebook, gboolean $show_border
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-tabs:
=begin pod
=head2 set-show-tabs

Sets whether to show the tabs for the notebook or not.

  method set-show-tabs ( Bool $show_tabs )

=item Bool $show_tabs; C<True> if the tabs should be shown
=end pod

method set-show-tabs ( Bool $show_tabs ) {

  gtk_notebook_set_show_tabs(
    self.get-native-object-no-reffing, $show_tabs
  );
}

sub gtk_notebook_set_show_tabs (
  N-GObject $notebook, gboolean $show_tabs
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-tab-detachable:
=begin pod
=head2 set-tab-detachable

Sets whether the tab can be detached from I<notebook> to another notebook or widget.

Note that 2 notebooks must share a common group identificator (see C<set-group-name()>) to allow automatic tabs interchange between them.

If you want a widget to interact with a notebook through DnD (i.e.: accept dragged tabs from it) it must be set as a drop destination and accept the target “GTK-NOTEBOOK-TAB”. The notebook will fill the selection with a GtkWidget** pointing to the child widget that corresponds to the dropped tab.

Note that you should use C<detach-tab()> instead of C<Gnome::Gtk3::Container.remove()> if you want to remove the tab from the source notebook as part of accepting a drop. Otherwise, the source notebook will think that the dragged tab was removed from underneath the ongoing drag operation, and will initiate a drag cancel animation.

=begin comment
  static void on-drag-data-received (
    GtkWidget *widget, GdkDragContext *context, gint x, gint y, GtkSelectionData *data, guint info, guint time, gpointer user-data
  ) {
    GtkWidget *notebook; GtkWidget **child;

    notebook = gtk-drag-get-source-widget (context); child = (void*) gtk-selection-data-get-data (data);

  // process-widget (*child);

    gtk-notebook-detach-tab (GTK-NOTEBOOK (notebook), *child);
  }
=end comment

If you want a notebook to accept drags from other widgets, you will have to set your own DnD code to do it.

  method set-tab-detachable ( N-GObject $child, Bool $detachable )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>
=item Bool $detachable; whether the tab is detachable or not
=end pod

method set-tab-detachable ( $child is copy, Bool $detachable ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_set_tab_detachable(
    self.get-native-object-no-reffing, $child, $detachable
  );
}

sub gtk_notebook_set_tab_detachable (
  N-GObject $notebook, N-GObject $child, gboolean $detachable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-tab-label:
=begin pod
=head2 set-tab-label

Changes the tab label for I<$child>. If C<undefined> is specified for I<$tab-label>, then the page will have the label “page N”.

  method set-tab-label ( N-GObject $child, N-GObject $tab_label )

=item N-GObject $child; the page
=item N-GObject $tab_label; the tab label widget to use, or C<undefined> for default tab label
=end pod

method set-tab-label ( $child is copy, $tab_label is copy ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  $tab_label .= get-native-object-no-reffing unless $tab_label ~~ N-GObject;

  gtk_notebook_set_tab_label(
    self.get-native-object-no-reffing, $child, $tab_label
  );
}

sub gtk_notebook_set_tab_label (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-tab-label-text:
=begin pod
=head2 set-tab-label-text

Creates a new label and sets it as the tab label for the page containing I<$child>.

  method set-tab-label-text ( N-GObject $child, Str $tab_text )

=item N-GObject $child; the page
=item Str $tab_text; the label text
=end pod

method set-tab-label-text ( $child is copy, Str $tab_text ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;
  gtk_notebook_set_tab_label_text(
    self.get-native-object-no-reffing, $child, $tab_text
  );
}

sub gtk_notebook_set_tab_label_text (
  N-GObject $notebook, N-GObject $child, gchar-ptr $tab_text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-tab-pos:
=begin pod
=head2 set-tab-pos

Sets the edge at which the tabs for switching pages in the notebook are drawn.

  method set-tab-pos ( GtkPositionType $pos )

=item GtkPositionType $pos; the edge to draw the tabs at
=end pod

method set-tab-pos ( GtkPositionType $pos ) {
  gtk_notebook_set_tab_pos( self.get-native-object-no-reffing, $pos);
}

sub gtk_notebook_set_tab_pos (
  N-GObject $notebook, GEnum $pos
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-tab-reorderable:
=begin pod
=head2 set-tab-reorderable

Sets whether the notebook tab can be reordered via drag and drop or not.

  method set-tab-reorderable ( N-GObject $child, Bool $reorderable )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>
=item Bool $reorderable; whether the tab is reorderable or not
=end pod

method set-tab-reorderable ( $child is copy, Bool $reorderable ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_notebook_set_tab_reorderable(
    self.get-native-object-no-reffing, $child, $reorderable
  );
}

sub gtk_notebook_set_tab_reorderable (
  N-GObject $notebook, N-GObject $child, gboolean $reorderable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_notebook_new:
#`{{
=begin pod
=head2 _gtk_notebook_new

Creates a new B<Gnome::Gtk3::Notebook> widget with no pages.

Returns: the newly created B<Gnome::Gtk3::Notebook>

  method _gtk_notebook_new ( --> N-GObject )

=end pod
}}

sub _gtk_notebook_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_notebook_new')
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
=comment #TS:0:create-window:
=head3 create-window

  method handler (
    N-GObject #`{ is widget } $n-gobject #`{ is widget },
    Int $int,
    Int $int,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Unknown type GTK_TYPE_NOTEBOOK
  );

=item $notebook;
=item $n-gobject #`{ is widget };
=item $int;
=item $int;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:page-added:
=head3 page-added

  method handler (
    N-GObject #`{ is widget } $n-gobject #`{ is widget },
     $,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook;
=item $n-gobject #`{ is widget };
=item $;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:page-removed:
=head3 page-removed

  method handler (
    N-GObject #`{ is widget } $n-gobject #`{ is widget },
     $,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook;
=item $n-gobject #`{ is widget };
=item $;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:page-reordered:
=head3 page-reordered

  method handler (
    N-GObject #`{ is widget } $n-gobject #`{ is widget },
     $,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook;
=item $n-gobject #`{ is widget };
=item $;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:reorder-tab:
=head3 reorder-tab

  method handler (
    Unknown type GTK_TYPE_DIRECTION_TYPE $unknown type gtk_type_direction_type,
    Int $int,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook;
=item $unknown type gtk_type_direction_type;
=item $int;
=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:switch-page:
=head3 switch-page

Emitted when the user or a function changes the current page.

  method handler (
    N-GObject #`{ is widget } $page,
     $page_num,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the object which received the signal.

=item $page; the new current page

=item $page_num; the index of the page

=item $_handle_id; the registered event handler id

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
=comment #TP:1:enable-popup:
=head3 Enable Popup: enable-popup

If TRUE, pressing the right mouse button on the notebook pops up a menu that you can use to go to a page

Default value: False

The B<Gnome::GObject::Value> type of property I<enable-popup> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:group-name:
=head3 Group Name: group-name

 Group name for tab drag and drop.

The B<Gnome::GObject::Value> type of property I<group-name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:page:
=head3 Page: page

The B<Gnome::GObject::Value> type of property I<page> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:scrollable:
=head3 Scrollable: scrollable

If TRUE, scroll arrows are added if there are too many tabs to fit
Default value: False

The B<Gnome::GObject::Value> type of property I<scrollable> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:show-border:
=head3 Show Border: show-border

Whether the border should be shown
Default value: True

The B<Gnome::GObject::Value> type of property I<show-border> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:show-tabs:
=head3 Show Tabs: show-tabs

Whether tabs should be shown
Default value: True

The B<Gnome::GObject::Value> type of property I<show-tabs> is C<G_TYPE_BOOLEAN>.

=begin comment
=comment -----------------------------------------------------------------------
=comment #TP:0:tab-pos:
=head3 Tab Position: tab-pos

Which side of the notebook holds the tabs
Default value: False

The B<Gnome::GObject::Value> type of property I<tab-pos> is C<G_TYPE_ENUM>.
=end comment
=end pod









































=finish
#-------------------------------------------------------------------------------
#TM:2:_gtk_notebook_new:new()
# Creates a new Notebook widget with no pages.
sub _gtk_notebook_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_notebook_new')
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_notebook_append_page:QAManager package
=begin pod
=head2 [gtk_notebook_] append_page

Appends a page to the I<notebook>.

Returns: the index (starting from 0) of the appended page in the notebook, or -1 if function fails

  method gtk_notebook_append_page (
    N-GObject $child, N-GObject $tab_label
    --> Int
  )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page.
=item N-GObject $tab_label; the B<Gnome::Gtk3::Widget> to be used as the label for the page, or an undefined value to use the default label, “page N”

=end pod

sub gtk_notebook_append_page (
  N-GObject $notebook, N-GObject $child, N-GObject $tab_label
  --> int32
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_append_page_menu:
=begin pod
=head2 [gtk_notebook_] append_page_menu

Appends a page to I<notebook>, specifying the widget to use as the
label in the popup menu.

Returns: the index (starting from 0) of the appended
page in the notebook, or -1 if function fails

  method gtk_notebook_append_page_menu ( N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> Int )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; (allow-none): the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<Any> to use the default label, “page N”
=item N-GObject $menu_label; (allow-none): the widget to use as a label for the page-switch menu, if that is enabled. If C<Any>, and I<tab_label> is a B<Gnome::Gtk3::Label> or C<Any>, then the menu label will be a newly created label with the same text as I<tab_label>; if I<tab_label> is not a B<Gnome::Gtk3::Label>, I<menu_label> must be specified if the page-switch menu is to be used.

=end pod

sub gtk_notebook_append_page_menu ( N-GObject $notebook, N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_prepend_page:
=begin pod
=head2 [gtk_notebook_] prepend_page

Prepends a page to I<notebook>.

Returns: the index (starting from 0) of the prepended
page in the notebook, or -1 if function fails

  method gtk_notebook_prepend_page ( N-GObject $child, N-GObject $tab_label --> Int )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; (allow-none): the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<Any> to use the default label, “page N”

=end pod

sub gtk_notebook_prepend_page ( N-GObject $notebook, N-GObject $child, N-GObject $tab_label --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_prepend_page_menu:
=begin pod
=head2 [gtk_notebook_] prepend_page_menu

Prepends a page to I<notebook>, specifying the widget to use as the
label in the popup menu.

Returns: the index (starting from 0) of the prepended
page in the notebook, or -1 if function fails

  method gtk_notebook_prepend_page_menu ( N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> Int )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; (allow-none): the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<Any> to use the default label, “page N”
=item N-GObject $menu_label; (allow-none): the widget to use as a label for the page-switch menu, if that is enabled. If C<Any>, and I<tab_label> is a B<Gnome::Gtk3::Label> or C<Any>, then the menu label will be a newly created label with the same text as I<tab_label>; if I<tab_label> is not a B<Gnome::Gtk3::Label>, I<menu_label> must be specified if the page-switch menu is to be used.

=end pod

sub gtk_notebook_prepend_page_menu ( N-GObject $notebook, N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_insert_page:
=begin pod
=head2 [gtk_notebook_] insert_page

Insert a page into I<notebook> at the given position.

Returns: the index (starting from 0) of the inserted
page in the notebook, or -1 if function fails

  method gtk_notebook_insert_page ( N-GObject $child, N-GObject $tab_label, Int $position --> Int )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; (allow-none): the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<Any> to use the default label, “page N”
=item Int $position; the index (starting at 0) at which to insert the page, or -1 to append the page after all other pages

=end pod

sub gtk_notebook_insert_page ( N-GObject $notebook, N-GObject $child, N-GObject $tab_label, int32 $position --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_insert_page_menu:
=begin pod
=head2 [gtk_notebook_] insert_page_menu

Insert a page into I<notebook> at the given position, specifying
the widget to use as the label in the popup menu.

Returns: the index (starting from 0) of the inserted
page in the notebook

  method gtk_notebook_insert_page_menu ( N-GObject $child, N-GObject $tab_label, N-GObject $menu_label, Int $position --> Int )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to use as the contents of the page
=item N-GObject $tab_label; (allow-none): the B<Gnome::Gtk3::Widget> to be used as the label for the page, or C<Any> to use the default label, “page N”
=item N-GObject $menu_label; (allow-none): the widget to use as a label for the page-switch menu, if that is enabled. If C<Any>, and I<tab_label> is a B<Gnome::Gtk3::Label> or C<Any>, then the menu label will be a newly created label with the same text as I<tab_label>; if I<tab_label> is not a B<Gnome::Gtk3::Label>, I<menu_label> must be specified if the page-switch menu is to be used.
=item Int $position; the index (starting at 0) at which to insert the page, or -1 to append the page after all other pages.

=end pod

sub gtk_notebook_insert_page_menu ( N-GObject $notebook, N-GObject $child, N-GObject $tab_label, N-GObject $menu_label, int32 $position --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_remove_page:
=begin pod
=head2 [gtk_notebook_] remove_page

Removes a page from the notebook given its index
in the notebook.

  method gtk_notebook_remove_page ( Int $page_num )

=item Int $page_num; the index of a notebook page, starting from 0. If -1, the last page will be removed.

=end pod

sub gtk_notebook_remove_page ( N-GObject $notebook, int32 $page_num  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_group_name:
=begin pod
=head2 [gtk_notebook_] set_group_name

Sets a group name for I<notebook>.

Notebooks with the same name will be able to exchange tabs
via drag and drop. A notebook with a C<Any> group name will
not be able to exchange tabs with any other notebook.

Since: 2.24

  method gtk_notebook_set_group_name ( Str $group_name )

=item Str $group_name; (allow-none): the name of the notebook group, or C<Any> to unset it

=end pod

sub gtk_notebook_set_group_name ( N-GObject $notebook, Str $group_name  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_group_name:
=begin pod
=head2 [gtk_notebook_] get_group_name

Gets the current group name for I<notebook>.

Returns: (nullable) (transfer none): the group name, or C<Any> if none is set

Since: 2.24

  method gtk_notebook_get_group_name ( --> Str )


=end pod

sub gtk_notebook_get_group_name ( N-GObject $notebook --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_current_page:
=begin pod
=head2 [gtk_notebook_] get_current_page

Returns the page number of the current page.

Returns: the index (starting from 0) of the current
page in the notebook. If the notebook has no pages,
then -1 will be returned.

  method gtk_notebook_get_current_page ( --> Int )


=end pod

sub gtk_notebook_get_current_page ( N-GObject $notebook --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_nth_page:
=begin pod
=head2 [gtk_notebook_] get_nth_page

Returns the child widget contained in page number I<page_num>.

Returns: (nullable) (transfer none): the child widget, or C<Any> if I<page_num>
is out of bounds

  method gtk_notebook_get_nth_page ( Int $page_num --> N-GObject )

=item Int $page_num; the index of a page in the notebook, or -1 to get the last page

=end pod

sub gtk_notebook_get_nth_page ( N-GObject $notebook, int32 $page_num --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_n_pages:
=begin pod
=head2 [gtk_notebook_] get_n_pages

Gets the number of pages in a notebook.

Returns: the number of pages in the notebook

Since: 2.2

  method gtk_notebook_get_n_pages ( --> Int )


=end pod

sub gtk_notebook_get_n_pages ( N-GObject $notebook --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_page_num:
=begin pod
=head2 [gtk_notebook_] page_num

Finds the index of the page which contains the given child
widget.

Returns: the index of the page containing I<child>, or
-1 if I<child> is not in the notebook

  method gtk_notebook_page_num ( N-GObject $child --> Int )

=item N-GObject $child; a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_notebook_page_num ( N-GObject $notebook, N-GObject $child --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_current_page:
=begin pod
=head2 [gtk_notebook_] set_current_page

Switches to the page number I<page_num>.

Note that due to historical reasons, B<Gnome::Gtk3::Notebook> refuses
to switch to a page unless the child widget is visible.
Therefore, it is recommended to show child widgets before
adding them to a notebook.

  method gtk_notebook_set_current_page ( Int $page_num )

=item Int $page_num; index of the page to switch to, starting from 0. If negative, the last page will be used. If greater than the number of pages in the notebook, nothing will be done.

=end pod

sub gtk_notebook_set_current_page ( N-GObject $notebook, int32 $page_num  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_next_page:
=begin pod
=head2 [gtk_notebook_] next_page

Switches to the next page. Nothing happens if the current page is
the last page.

  method gtk_notebook_next_page ( )


=end pod

sub gtk_notebook_next_page ( N-GObject $notebook  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_prev_page:
=begin pod
=head2 [gtk_notebook_] prev_page

Switches to the previous page. Nothing happens if the current page
is the first page.

  method gtk_notebook_prev_page ( )


=end pod

sub gtk_notebook_prev_page ( N-GObject $notebook  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_show_border:
=begin pod
=head2 [gtk_notebook_] set_show_border

Sets whether a bevel will be drawn around the notebook pages.
This only has a visual effect when the tabs are not shown.
See C<gtk_notebook_set_show_tabs()>.

  method gtk_notebook_set_show_border ( Int $show_border )

=item Int $show_border; C<1> if a bevel should be drawn around the notebook

=end pod

sub gtk_notebook_set_show_border ( N-GObject $notebook, int32 $show_border  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_show_border:
=begin pod
=head2 [gtk_notebook_] get_show_border

Returns whether a bevel will be drawn around the notebook pages.
See C<gtk_notebook_set_show_border()>.

Returns: C<1> if the bevel is drawn

  method gtk_notebook_get_show_border ( --> Int )


=end pod

sub gtk_notebook_get_show_border ( N-GObject $notebook --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_show_tabs:
=begin pod
=head2 [gtk_notebook_] set_show_tabs

Sets whether to show the tabs for the notebook or not.

  method gtk_notebook_set_show_tabs ( Int $show_tabs )

=item Int $show_tabs; C<1> if the tabs should be shown

=end pod

sub gtk_notebook_set_show_tabs ( N-GObject $notebook, int32 $show_tabs  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_show_tabs:
=begin pod
=head2 [gtk_notebook_] get_show_tabs

Returns whether the tabs of the notebook are shown.
See C<gtk_notebook_set_show_tabs()>.

Returns: C<1> if the tabs are shown

  method gtk_notebook_get_show_tabs ( --> Int )


=end pod

sub gtk_notebook_get_show_tabs ( N-GObject $notebook --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_tab_pos:
=begin pod
=head2 [gtk_notebook_] set_tab_pos

Sets the edge at which the tabs for switching pages in the
notebook are drawn.

  method gtk_notebook_set_tab_pos ( GtkPositionType $pos )

=item GtkPositionType $pos; the edge to draw the tabs at

=end pod

sub gtk_notebook_set_tab_pos ( N-GObject $notebook, int32 $pos  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_tab_pos:
=begin pod
=head2 [gtk_notebook_] get_tab_pos

Gets the edge at which the tabs for switching pages in the
notebook are drawn.

Returns: the edge at which the tabs are drawn

  method gtk_notebook_get_tab_pos ( --> GtkPositionType )


=end pod

sub gtk_notebook_get_tab_pos ( N-GObject $notebook --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_scrollable:
=begin pod
=head2 [gtk_notebook_] set_scrollable

Sets whether the tab label area will have arrows for
scrolling if there are too many tabs to fit in the area.

  method gtk_notebook_set_scrollable ( Int $scrollable )

=item Int $scrollable; C<1> if scroll arrows should be added

=end pod

sub gtk_notebook_set_scrollable ( N-GObject $notebook, int32 $scrollable  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_scrollable:
=begin pod
=head2 [gtk_notebook_] get_scrollable

Returns whether the tab label area has arrows for scrolling.
See C<gtk_notebook_set_scrollable()>.

Returns: C<1> if arrows for scrolling are present

  method gtk_notebook_get_scrollable ( --> Int )


=end pod

sub gtk_notebook_get_scrollable ( N-GObject $notebook --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_popup_enable:
=begin pod
=head2 [gtk_notebook_] popup_enable

Enables the popup menu: if the user clicks with the right
mouse button on the tab labels, a menu with all the pages
will be popped up.

  method gtk_notebook_popup_enable ( )


=end pod

sub gtk_notebook_popup_enable ( N-GObject $notebook  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_popup_disable:
=begin pod
=head2 [gtk_notebook_] popup_disable

Disables the popup menu.

  method gtk_notebook_popup_disable ( )


=end pod

sub gtk_notebook_popup_disable ( N-GObject $notebook  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_tab_label:
=begin pod
=head2 [gtk_notebook_] get_tab_label

Returns the tab label widget for the page I<child>.
C<Any> is returned if I<child> is not in I<notebook> or
if no tab label has specifically been set for I<child>.

Returns: (transfer none) (nullable): the tab label

  method gtk_notebook_get_tab_label ( N-GObject $child --> N-GObject )

=item N-GObject $child; the page

=end pod

sub gtk_notebook_get_tab_label ( N-GObject $notebook, N-GObject $child --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_tab_label:
=begin pod
=head2 [gtk_notebook_] set_tab_label

Changes the tab label for I<child>.
If C<Any> is specified for I<tab_label>, then the page will
have the label “page N”.

  method gtk_notebook_set_tab_label ( N-GObject $child, N-GObject $tab_label )

=item N-GObject $child; the page
=item N-GObject $tab_label; (allow-none): the tab label widget to use, or C<Any> for default tab label

=end pod

sub gtk_notebook_set_tab_label ( N-GObject $notebook, N-GObject $child, N-GObject $tab_label  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_tab_label_text:
=begin pod
=head2 [gtk_notebook_] set_tab_label_text

Creates a new label and sets it as the tab label for the page
containing I<child>.

  method gtk_notebook_set_tab_label_text ( N-GObject $child, Str $tab_text )

=item N-GObject $child; the page
=item Str $tab_text; the label text

=end pod

sub gtk_notebook_set_tab_label_text ( N-GObject $notebook, N-GObject $child, Str $tab_text  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_tab_label_text:
=begin pod
=head2 [gtk_notebook_] get_tab_label_text

Retrieves the text of the tab label for the page containing
I<child>.

Returns: (nullable): the text of the tab label, or C<Any> if the tab label
widget is not a B<Gnome::Gtk3::Label>. The string is owned by the widget and must not be
freed.

  method gtk_notebook_get_tab_label_text ( N-GObject $child --> Str )

=item N-GObject $child; a widget contained in a page of I<notebook>

=end pod

sub gtk_notebook_get_tab_label_text ( N-GObject $notebook, N-GObject $child --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_menu_label:
=begin pod
=head2 [gtk_notebook_] get_menu_label

Retrieves the menu label widget of the page containing I<child>.

Returns: (nullable) (transfer none): the menu label, or C<Any> if the
notebook page does not have a menu label other than the default (the tab
label).

  method gtk_notebook_get_menu_label ( N-GObject $child --> N-GObject )

=item N-GObject $child; a widget contained in a page of I<notebook>

=end pod

sub gtk_notebook_get_menu_label ( N-GObject $notebook, N-GObject $child --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_menu_label:
=begin pod
=head2 [gtk_notebook_] set_menu_label

Changes the menu label for the page containing I<child>.

  method gtk_notebook_set_menu_label ( N-GObject $child, N-GObject $menu_label )

=item N-GObject $child; the child widget
=item N-GObject $menu_label; (allow-none): the menu label, or C<Any> for default

=end pod

sub gtk_notebook_set_menu_label ( N-GObject $notebook, N-GObject $child, N-GObject $menu_label  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_menu_label_text:
=begin pod
=head2 [gtk_notebook_] set_menu_label_text

Creates a new label and sets it as the menu label of I<child>.

  method gtk_notebook_set_menu_label_text ( N-GObject $child, Str $menu_text )

=item N-GObject $child; the child widget
=item Str $menu_text; the label text

=end pod

sub gtk_notebook_set_menu_label_text ( N-GObject $notebook, N-GObject $child, Str $menu_text  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_menu_label_text:
=begin pod
=head2 [gtk_notebook_] get_menu_label_text

Retrieves the text of the menu label for the page containing
I<child>.

Returns: (nullable): the text of the tab label, or C<Any> if the widget does
not have a menu label other than the default menu label, or the menu label
widget is not a B<Gnome::Gtk3::Label>. The string is owned by the widget and must not be
freed.

  method gtk_notebook_get_menu_label_text ( N-GObject $child --> Str )

=item N-GObject $child; the child widget of a page of the notebook.

=end pod

sub gtk_notebook_get_menu_label_text ( N-GObject $notebook, N-GObject $child --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_reorder_child:
=begin pod
=head2 [gtk_notebook_] reorder_child

Reorders the page containing I<child>, so that it appears in position
I<position>. If I<position> is greater than or equal to the number of
children in the list or negative, I<child> will be moved to the end
of the list.

  method gtk_notebook_reorder_child ( N-GObject $child, Int $position )

=item N-GObject $child; the child to move
=item Int $position; the new position, or -1 to move to the end

=end pod

sub gtk_notebook_reorder_child ( N-GObject $notebook, N-GObject $child, int32 $position  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_tab_reorderable:
=begin pod
=head2 [gtk_notebook_] get_tab_reorderable

Gets whether the tab can be reordered via drag and drop or not.

Returns: C<1> if the tab is reorderable.

Since: 2.10

  method gtk_notebook_get_tab_reorderable ( N-GObject $child --> Int )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>

=end pod

sub gtk_notebook_get_tab_reorderable ( N-GObject $notebook, N-GObject $child --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_tab_reorderable:
=begin pod
=head2 [gtk_notebook_] set_tab_reorderable

Sets whether the notebook tab can be reordered
via drag and drop or not.

Since: 2.10

  method gtk_notebook_set_tab_reorderable ( N-GObject $child, Int $reorderable )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>
=item Int $reorderable; whether the tab is reorderable or not

=end pod

sub gtk_notebook_set_tab_reorderable ( N-GObject $notebook, N-GObject $child, int32 $reorderable  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_tab_detachable:
=begin pod
=head2 [gtk_notebook_] get_tab_detachable

Returns whether the tab contents can be detached from I<notebook>.

Returns: C<1> if the tab is detachable.

Since: 2.10

  method gtk_notebook_get_tab_detachable ( N-GObject $child --> Int )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>

=end pod

sub gtk_notebook_get_tab_detachable ( N-GObject $notebook, N-GObject $child --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_tab_detachable:
=begin pod
=head2 [gtk_notebook_] set_tab_detachable

Sets whether the tab can be detached from I<notebook> to another
notebook or widget.

Note that 2 notebooks must share a common group identificator
(see C<gtk_notebook_set_group_name()>) to allow automatic tabs
interchange between them.

If you want a widget to interact with a notebook through DnD
(i.e.: accept dragged tabs from it) it must be set as a drop
destination and accept the target “GTK_NOTEBOOK_TAB”. The notebook
will fill the selection with a B<Gnome::Gtk3::Widget>** pointing to the child
widget that corresponds to the dropped tab.

Note that you should use C<gtk_notebook_detach_tab()> instead
of C<gtk_container_remove()> if you want to remove the tab from
the source notebook as part of accepting a drop. Otherwise,
the source notebook will think that the dragged tab was
removed from underneath the ongoing drag operation, and
will initiate a drag cancel animation.

|[<!-- language="C" -->
static void
on_drag_data_received (B<Gnome::Gtk3::Widget>        *widget,
B<Gnome::Gdk3::DragContext>   *context,
gint              x,
gint              y,
B<Gnome::Gtk3::SelectionData> *data,
guint             info,
guint             time,
gpointer          user_data)
{
B<Gnome::Gtk3::Widget> *notebook;
B<Gnome::Gtk3::Widget> **child;

notebook = gtk_drag_get_source_widget (context);
child = (void*) gtk_selection_data_get_data (data);

// process_widget (*child);

gtk_notebook_detach_tab (GTK_NOTEBOOK (notebook), *child);
}
]|

If you want a notebook to accept drags from other widgets,
you will have to set your own DnD code to do it.

Since: 2.10

  method gtk_notebook_set_tab_detachable ( N-GObject $child, Int $detachable )

=item N-GObject $child; a child B<Gnome::Gtk3::Widget>
=item Int $detachable; whether the tab is detachable or not

=end pod

sub gtk_notebook_set_tab_detachable ( N-GObject $notebook, N-GObject $child, int32 $detachable  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_detach_tab:
=begin pod
=head2 [gtk_notebook_] detach_tab

Removes the child from the notebook.

This function is very similar to C<gtk_container_remove()>,
but additionally informs the notebook that the removal
is happening as part of a tab DND operation, which should
not be cancelled.

Since: 3.16

  method gtk_notebook_detach_tab ( N-GObject $child )

=item N-GObject $child; a child

=end pod

sub gtk_notebook_detach_tab ( N-GObject $notebook, N-GObject $child  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_get_action_widget:
=begin pod
=head2 [gtk_notebook_] get_action_widget

Gets one of the action widgets. See C<gtk_notebook_set_action_widget()>.

Returns: (nullable) (transfer none): The action widget with the given
I<pack_type> or C<Any> when this action widget has not been set

Since: 2.20

  method gtk_notebook_get_action_widget ( GtkPackType $pack_type --> N-GObject )

=item GtkPackType $pack_type; pack type of the action widget to receive

=end pod

sub gtk_notebook_get_action_widget ( N-GObject $notebook, int32 $pack_type --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_notebook_set_action_widget:
=begin pod
=head2 [gtk_notebook_] set_action_widget

Sets I<widget> as one of the action widgets. Depending on the pack type
the widget will be placed before or after the tabs. You can use
a B<Gnome::Gtk3::Box> if you need to pack more than one widget on the same side.

Note that action widgets are “internal” children of the notebook and thus
not included in the list returned from C<gtk_container_foreach()>.

Since: 2.20

  method gtk_notebook_set_action_widget ( N-GObject $widget, GtkPackType $pack_type )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item GtkPackType $pack_type; pack type of the action widget

=end pod

sub gtk_notebook_set_action_widget ( N-GObject $notebook, N-GObject $widget, int32 $pack_type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:switch-page:
=head3 switch-page

Emitted when the user or a function changes the current page.

  method handler (
    N-GObject #`{ is widget } $page,
    UInt $page_num,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the object which received the signal.
=item $page; the new current page
=item $page_num; the index of the page


=comment #TS:0:page-reordered:
=head3 page-reordered

the I<page-reordered> signal is emitted in the notebook right after a page has been reordered.

Since: 2.10

  method handler (
    N-GObject #`{ is widget } $child,
    UInt $page_num,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the B<Gnome::Gtk3::Notebook>
=item $child; the child B<Gnome::Gtk3::Widget> affected
=item $page_num; the new page number for I<child>


=comment #TS:0:page-removed:
=head3 page-removed

the I<page-removed> signal is emitted in the notebook right after a page is removed from the notebook.

Since: 2.10

  method handler (
    N-GObject #`{ is widget } $child,
    UInt $page_num,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the B<Gnome::Gtk3::Notebook>
=item $child; the child B<Gnome::Gtk3::Widget> affected
=item $page_num; the I<child> page number


=comment #TS:0:page-added:
=head3 page-added

the I<page-added> signal is emitted in the notebook right after a page is added to the notebook.

Since: 2.10

  method handler (
    N-GObject #`{ is widget } $child,
    UInt $page_num,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the B<Gnome::Gtk3::Notebook>
=item $child; the child B<Gnome::Gtk3::Widget> affected
=item $page_num; the new page number for I<child>


=comment #TS:0:create-window:
=head3 create-window

The I<create-window> signal is emitted when a detachable tab is dropped on the root window.

A handler for this signal can create a window containing a notebook where the tab will be attached. It is also responsible for moving/resizing the window and adding the necessary properties to the notebook (e.g. the I<group-name> ).

Returns: a B<Gnome::Gtk3::Notebook> that I<page> should be added to, or C<Any>.

Since: 2.12

  method handler (
    N-GObject #`{ is widget } $page,
    Int $x,
    Int $y,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
  );

=item $notebook; the B<Gnome::Gtk3::Notebook> emitting the signal
=item $page; the tab of I<notebook> that is being detached
=item $x; the X coordinate where the drop happens
=item $y; the Y coordinate where the drop happens


=comment #TS:0:reorder-tab:
=head3 reorder-tab

  method handler (
    Int $arg1, #`{ GtkDirectionType }
    Int $arg2, #`{ Bool }
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the B<Gnome::Gtk3::Notebook> emitting the signal
=item $arg1; ?
=item $arg2; ?


=comment #TS:0:page-reordered:
=head3 page-reordered

  method handler (
    N-GObject $child, #`{ is widget }
    uint $page-num,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the B<Gnome::Gtk3::Notebook> emitting the signal
=item $child; the child Gtk Widget affected
=item $page-num; the new page number for child


=comment #TS:0:page-removed:
=head3 page-removed

  method handler (
    N-GObject $child, #`{ is widget }
    uint $page-num,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the B<Gnome::Gtk3::Notebook> emitting the signal
=item $child; the child Gtk Widget affected
=item $page-num; the new page number for child


=comment #TS:0:page-added:
=head3 page-added

  method handler (
    N-GObject $child, #`{ is widget }
    uint $page-num,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Int
  );

=item $notebook; the B<Gnome::Gtk3::Notebook> emitting the signal
=item $child; the child Gtk Widget affected
=item $page-num; the new page number for child


=comment #TS:0:create-window:
=head3 create-window

  method handler (
    N-GObject #`{ is widget } $n-gobject #`{ is widget },
    Int $int,
    Int $int,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($notebook),
    *%user-options
    --> Unknown type GTK_TYPE_NOTEBOOK
  );

=item $notebook;
=item $n-gobject #`{ is widget };
=item $int;
=item $int;

=end pod
