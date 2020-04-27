# Stress test results

The structure of the setup is something like
```
Window
  ScrolledWindow to prevent a huge window height
    Grid
      n Widgets in a column
      1 Button to exit main loop
```

| loop count | grid widgets | total build | time time per build
|------------|--------------|-------------|---------------------|
| 5          | 100 buttons  | 0.712       | 0.142
| 5          | 100 entries  | 0.860       | 0.172
