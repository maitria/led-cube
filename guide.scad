
$fs = 0.25;
$fa = 1;

include <config.scad>;

module hole() {
    translate([0, 0, $height - $wire_guide_height - $flange_height]) {
        difference() {
            cylinder(h = $flange_height, d = snugly($flange_diameter));
            translate([-snugly($flange_diameter)/2,
                       snugly($flange_diameter)/2 - ($flange_diameter - $flange_flat_diameter),
                       0]) {
                cube([$flange_diameter, $flange_diameter - $led_diameter, $flange_height]);
            }
        }
    }
    translate([0, 0, $height - $wire_guide_height - $led_height - 2]) cylinder(h = $led_height + 2, d = snugly($led_diameter));
}

module base(rows, columns) {
    cube([extent(rows), extent(columns), $height]);
}

module guide(rows, columns) {
    union() {
        difference() {
            base(rows, columns);
            for (i = [0:rows - 1])
                for (j = [0:columns - 1])
                    translate([$gutter + i * $distance, $gutter + j * $distance, 0])
                        hole();

            for (j = [0:columns - 1])
                translate([0, $gutter + j * $distance - $wire_guide_distance, $height - $wire_guide_height])
                    cube([extent(rows), 2 * $wire_guide_distance, $wire_guide_height]);
            for (i = [0:rows - 1]) {
                translate([$gutter + i * $distance + snugly($flange_diameter)/2, 0, $height - $wire_guide_height]) {
                    cube([snugly($lead_diameter), extent(columns), snugly($lead_diameter)]);
                }
                translate([$gutter + i * $distance + snugly($flange_diameter)/2, $gutter, $height - $wire_guide_height]) {
                    cube([snugly($lead_diameter), (columns - 1) * $distance, $wire_guide_height]);
                }
            }
        }
        for (i = [0:rows - 2])
            for (j = [0:columns - 1])
                translate([$gutter + (i + 0.55) * $distance,
                           $gutter + j * $distance + snugly($led_diameter)/2,
                           $height - $wire_guide_height])
                    union() {
                        cube([2.5, 5, 1.5]);
                        translate([0, -7 -1.5, 0]) cube([2.5, 7, 1.5]);
                    }
        for (j = [0:columns - 1])
            translate([extent(rows) - 2.5,
                       $gutter + j * $distance + snugly($led_diameter)/2,
                       $height - $wire_guide_height])
                union() {
                    cube([2.5, 5, 1.5]);
                    translate([0, -7 -1.5, 0]) cube([2.5, 7, 1.5]);
                }
    }
}

guide($rows, $columns);

// vim:set sts=4 sw=4 ai et:
