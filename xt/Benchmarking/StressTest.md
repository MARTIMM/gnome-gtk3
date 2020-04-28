# Stress test results

The structure of the setup is something like
```
Window
  ScrolledWindow to prevent a huge window height
    Grid
      n Widgets in a column
      1 Button to exit main loop
```

| loop count | grid widgets | total time  | time per build  | builds per sec
|------------|--------------|-------------|-----------------|---------------|
| 5          | 100 buttons  | 0.712       | 0.142           | 7.022
| 5          | 100 entries  | 0.829       | 0.166           | 6.034
