use v6;
use Gnome::Gtk3::AboutDialog;

my Gnome::Gtk3::AboutDialog $a .= new;

my @bt1 = timethis( 'Method call .set-program-name()', 2000, {
    $a.set-program-name('AboutDialog.t');
  }
);
#show |@bt1;

my @bt2 = timethis(
  'Native sub search .gtk-about-dialog-set-program-name()', 500, {
    $a.gtk-about-dialog-set-program-name('AboutDialog.t');
  }
);

my @bt3 = timethis(
  'Native sub search .about-dialog-set-program-name()', 500, {
    $a.about-dialog-set-program-name('AboutDialog.t');
  }
);

my @bt4 = timethis(
  'Native sub search .gtk_about_dialog_set_program_name()', 500, {
    $a.gtk_about_dialog_set_program_name('AboutDialog.t');
  }
);

my @bt5 = timethis(
  'Native sub search .about_dialog_set_program_name()', 500, {
    $a.about_dialog_set_program_name('AboutDialog.t');
  }
);

my @bt6 = timethis(
  'Native sub search .set_program_name()', 500, {
    $a.set_program_name('AboutDialog.t');
  }
);

compare @bt1, @bt2, @bt3, @bt4, @bt5, @bt6;

#-------------------------------------------------------------------------------
sub show ( Str $test, $count, $total, $mean, $rps, $remark = '' ) {

  note (
    "\n$test",
    "Count: $count",
    "Total: $total.fmt('%.5f')",
    "Mean: $mean.fmt('%.5f')",
    "runs/sec: $rps.fmt('%.2f') $remark",
  ).join("\n  ");
}

#-------------------------------------------------------------------------------
sub timethis ( Str $test, Int $count, Callable $test-routine --> List ) {
  my Duration $total-time;
  loop ( my Int $test-count = 0; $test-count < $count; $test-count++ ) {
    $test-routine();
    $total-time += (now - ENTER now);
  }

  ( $test, $count, $total-time, $total-time/$count, $count/$total-time )
}

#-------------------------------------------------------------------------------
sub compare ( **@data ) {

  my $slowest;
  my Str $remark;
  for (|@data).sort( -> $a, $b { $a[4] <=> $b[4] }) -> @x {
    if $slowest.defined {
      $remark = (@x[4] / $slowest).fmt('%.2f') ~ ' times faster than slowest';
    }

    else {
      $remark = 'slowest';
      $slowest = @x[4];
    }

    show |@x, $remark;
  }
}
