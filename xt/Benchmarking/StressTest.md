# Stress test results

The structure of the setup is something like
```
Window
  ScrolledWindow to prevent a huge window height
    Grid
      n Widgets in a column
      1 Button to exit main loop
```

| loop count | grid widgets | total time  | time per build  | builds per sec| |
|------------|--------------|-------------|-----------------|---------------|--|
| 5          | 100 buttons  | 0.712       | 0.142           | 7.022
| 5          | 100 entries  | 0.829       | 0.166           | 6.034
| 5          | 100 entries  | 1.869       | 0.374           | 2.676 | 2020 11 30

# Modules

|Raku Version|Project Version|Sub Project|Test|Mean|Rps|Speedup|
|-|-|-|-|-|-|-|
|Raku-2021.02.1|Gnome::Gtk3-0.36.3|AboutDialog-0.2.0|Native sub search|0.006871|145.53|-.--|
|Raku-2020.12.32|Gnome::Gtk3-0.34.6|AboutDialog-0.2.0|Native sub search|0.006234|160.41|1.10|
|Raku-2021.02.1|Gnome::Gtk3-0.36.3|AboutDialog-0.2.0|Method calls|0.000752|1328.96|9.13|
|Raku-2020.12.32|Gnome::Gtk3-0.34.6|AboutDialog-0.2.0|Method calls|0.000725|1378.68|9.47|
