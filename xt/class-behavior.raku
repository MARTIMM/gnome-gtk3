use v6.d;

class A {
  multi method new ( |c ) {
    self.show( A, 'An ');
    self.bless(|c);
  }

  submethod BUILD ( *%o ) {
    self.show( A, 'Ab ', %o);
  }

  submethod TWEAK ( *%o ) {
    self.show( A, 'At ', %o);
  }

  method show ( $type, Str $c, %o = %() ) {
    my Str $star = ? %o{$type.^name.lc} ?? '*' !! ' ';

    note "  $c: $star ",
      self.^name.fmt('%10s'),         # always class C in the test case
      $?CLASS.^name.fmt('%15s   '),   # always class A show() is running there
#      self.^mro>>.perl.Str, '   ',   # always mro() of class C
      $type.^mro>>.perl.join(' ').fmt('%-16s'), '  ',
      %o.perl>>.join(' ').fmt('%-20s')
      ;
  }

  method process ( *%o ) {
    self.show( A, 'Ap ', %o);
    callsame;
  }
}

class B1 is A {
  multi method new ( |c ) {
    self.show( B1, 'B1n ');
    self.bless(|c);
  }

  submethod BUILD ( *%o ) {
    self.show( B1, 'B1b', %o);
  }

  submethod TWEAK ( *%o ) {
    self.show( B1, 'B1t', %o);
  }

  method process ( *%o ) {
    self.show( B1, 'B1p', %o);
    callsame;
  }
}

class B2 is A {
  multi method new ( |c ) {
    self.show( B2, 'B2n ');
    self.bless(|c);
  }

  submethod BUILD ( *%o ) {
    self.show( B2, 'B2b', %o);

    note 'B2 start process from BUILD';
    self.process;
  }

  submethod TWEAK ( *%o ) {
    self.show( B2, 'B2t', %o);
  }

  method process ( *%o ) {
    self.show( B2, 'B2p', %o);
    callsame;
  }
}

class C is B1 is B2 {
  multi method new ( |c ) {
    self.show( C, 'Cn ', :b1, :b2);
    self.bless( |c, :b1, :b2);
  }

  submethod BUILD ( *%o ) {
    self.show( C, 'Cb ', %o);

#    note 'C start process from BUILD';
#    self.process;
  }

  submethod TWEAK ( *%o ) {
    self.show( C, 'Ct ', %o);
  }

  method process ( *%o ) {
    self.show( C, 'Cp ', %o);
    %o<c>:delete;
    callsame;
    note 'done';
  }
}


note "\nBuilding\n     ", '    self.^name  $?CLASS.^name   $type.^mro        options';
my C $x .= new(:text<opt>);

note "\nProcessing\n     ", '    self.^name  $?CLASS.^name   $type.^mro        options';
$x.process;


#`{{ Result

Building
         self.^name  $?CLASS.^name   $type.^mro        options
  Cn :            C              A   C B1 B2 A Any Mu  {}
  Ab :            C              A   A Any Mu          {:b1, :b2, :text("opt")}
  At :            C              A   A Any Mu          {:b1, :b2, :text("opt")}
  B2b: *          C              A   B2 A Any Mu       {:b1, :b2, :text("opt")}
B2 start process from BUILD
  Cp :            C              A   C B1 B2 A Any Mu  {}
  B1p:            C              A   B1 A Any Mu       {}
  B2p:            C              A   B2 A Any Mu       {}
  Ap :            C              A   A Any Mu          {}
done
  B2t: *          C              A   B2 A Any Mu       {:b1, :b2, :text("opt")}
  B1b: *          C              A   B1 A Any Mu       {:b1, :b2, :text("opt")}
  B1t: *          C              A   B1 A Any Mu       {:b1, :b2, :text("opt")}
  Cb :            C              A   C B1 B2 A Any Mu  {:b1, :b2, :text("opt")}
  Ct :            C              A   C B1 B2 A Any Mu  {:b1, :b2, :text("opt")}

Processing
         self.^name  $?CLASS.^name   $type.^mro        options
  Cp :            C              A   C B1 B2 A Any Mu  {}
  B1p:            C              A   B1 A Any Mu       {}
  B2p:            C              A   B2 A Any Mu       {}
  Ap :            C              A   A Any Mu          {}
done


C.new       Only new from initialized object
A.BUILD     Top level class starts building
A.TWEAK     Then tweaking
B2.BUILD    Direct child building
B2.TWEAK    and tweaking
...
C.BUILD
C.process   In between call to process() while building C
B1.process  Works its way up to the top level class A
...
C.TWEAK     Tweak the C object
...
C.process   After all building call process() again outside of build.
B1.process
B2.process
A.process
}}
