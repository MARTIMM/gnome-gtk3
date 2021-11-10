all: demo

clean:
	rm -fv *~ *.o demo my-resources.h my-resources.c

my-resources.h: my-resources.xml $(UI_FILES)
	glib-compile-resources my-resources.xml \
		--target=$@ --sourcedir=$(srcdir) --c-name _my --generate-header

my-resources.c: my-resources.xml $(UI_FILES)
	glib-compile-resources my-resources.xml \
		--target=$@ --sourcedir=$(srcdir) --c-name _my --generate-source

%.o: %.c
	gcc -o $@ -c $< -Wall `pkg-config --cflags gtk+-3.0 gmodule-export-2.0`

demo: demo.o mywidget.o my-resources.o
	gcc -o $@  $^ `pkg-config --libs gtk+-3.0 gmodule-export-2.0`

e01:
	gcc -E mywidget.h -o e01.c  `pkg-config --cflags gtk+-3.0 gmodule-export-2.0`

e02:
	gcc -E mywidget.c -o e02.c -Wno-deprecated `pkg-config --cflags gtk+-3.0 gmodule-export-2.0`
