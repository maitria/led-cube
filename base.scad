
$fs = 0.25;
$fa = 1;

include <config.scad>;

module hole(multiplier) {
    translate([0, 0, -0.1]) cylinder(h = $height + 0.2, d = snugly(multiplier*$lead_diameter));
}

module base(rows, columns) {
    cube([extent(rows), extent(columns), $height]);
}

$thickness = 3;
$gutter = 12;

module decorative_edges(rows, columns, adjustment, smidge) {
    translate([-smidge + adjustment, adjustment, 0])
        rotate([0, 90, 0])
            cylinder(h = extent(rows) - 2 * adjustment + 2 * smidge, d = $height);
    translate([-smidge + adjustment, extent(columns) - adjustment, 0])
        rotate([0, 90, 0])
            cylinder(h = extent(rows) - 2 * adjustment + 2 * smidge, d = $height);

    translate([adjustment, -smidge + adjustment, 0])
        rotate([-90, 0, 0])
            cylinder(h = extent(columns) - 2 * adjustment + 2 * smidge, d = $height);
    translate([extent(rows) - adjustment, -smidge + adjustment, 0])
        rotate([-90, 0, 0])
            cylinder(h = extent(columns) - 2 * adjustment + 2 * smidge, d = $height);
}

module inside_base(rows, columns) {
    difference() {
        translate([$thickness, $thickness, $thickness + 0.01 ])
            cube([extent(rows) - 2*$thickness, extent(columns) - 2*$thickness, $height - $thickness]);

        decorative_edges(rows, columns, $thickness, 0);
    }
}

module cube_base(rows, columns) {
    union() {
        difference() {
            base(rows, columns);

            for (i = [0:rows - 1])
                for (j = [0:columns - 1])
                    translate([$gutter + i * $distance, $gutter + j * $distance, 0])
                        hole(2);
            for (i = [0:rows - 1])
                translate([$gutter + i * $distance, $gutter - 4, 0])
                    hole(3);

            decorative_edges(rows, columns, 0, 0.1);
            inside_base(rows, columns);
        }
    }
}


rotate([180,0,0])
    cube_base($rows, $columns);

// vim:set sts=4 sw=4 ai et:
