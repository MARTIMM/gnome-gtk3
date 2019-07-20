
[toc]


# Snippits
1) Signature test
```
sub xx ( Callable $h where .signature ~~ :(|c), *@x ) {
    say $h(|@x);
};

my Callable $hh = -> Int $x {
    $x + 1
};

xx( $hh, 41);
```
2) Signature test
```
my Signature $sh1 = :( Int --> Int );
my Signature $sh2 = :( Str --> Int );

my Sub $hh1 = sub ( Int $x --> Int ) { $x + 1 };
my Sub $hh2 = sub ( Str $x --> Int ) { $x.Int - 1 };

sub xx ( Callable $h where .signature ~~ any($sh1,$sh2), *@x ) {
    say $h(|@x);
};

xx( $hh1, 41);
xx( $hh2, '41');
```
3) Signature test
```
my Signature $x = :( Int $i );
my Sub $s = sub (@ ($x)) { say $i; };
```
4) Test for use in GSignal
```
# signal-type: widget, data
my Signature $signal-type = :( N-GObject, OpaquePointer );
# event-type: widget, event, data
my Signature $event-type = :( N-GObject, GdkEvent, OpaquePointer );
my @handler-types = $signal-type, $event-type,;

sub g_signal_connect (
  N-GObject $widget, Str $signal,
  Callable $handler where .signature ~~ any(@handler-types),
  OpaquePointer
) {
  g_signal_connect_data_wd(
    $widget, $signal, $handler, OpaquePointer, Any, 0
  );
}

# can be called the same as g_signal_connect because of its defaults
sub g_signal_connect_data(
  N-GObject $widget, Str $signal,
  Callable $handler where .signature ~~ any(@handler-types),
  OpaquePointer $data,
  Callable $destroy_data
           where .signature ~~ :( OpaquePointer, OpaquePointer ) = Any,
  Int $connect_flags = 0
) returns Int
  is native(&gobject-lib)
  { * }
```


# Links

https://linuxhint.com/opencv-face-recognition/
http://www.linux-magazine.com/Issues/2018/214/Programming-Snapshot-Facial-Recognition
https://www.omgubuntu.co.uk/2018/06/new-shotwell-update-face-detection
https://userbase.kde.org/Digikam/Face_Recognition
https://github.com/ageitgey/face_recognition
https://cmusatyalab.github.io/openface/
http://torch.ch/
http://openbiometrics.org/docs/index.html

https://developer.gnome.org/gnome-devel-demos/stable/c.html.en
https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html

https://developer.gnome.org/gtk-tutorial/stable/x2431.html
http://www.dlugosz.com/Perl6/specdoc.pdf

[//]: # (References)
