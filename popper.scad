
$fs = 1;
$fa = 0.1;

include <config.scad>;

cube([extent($rows), extent($columns), 0.2]);
for (i = [0:$rows - 1])
    for (j = [0:$columns - 1])
        translate([$gutter + j * $distance, $gutter + i * $distance, 0])
            cylinder(d = $led_diameter * 0.8, h = 3);

// vim:set sts=4 sw=4 ai et:
