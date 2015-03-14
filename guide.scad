
$fs = 0.25;
$fa = 1;

include <config.scad>;

module hole() {
    translate([0, 0, $height - $wire_guide_height - $flange_height]) {
        difference() {
            cylinder(h = $flange_height + $wire_guide_height, d = snugly($flange_diameter));
            translate([-snugly($flange_diameter)/2,
                       snugly($flange_diameter)/2 - ($flange_diameter - $flange_flat_diameter),
                       0]) {
                cube([$flange_diameter, $flange_diameter - $led_diameter, $flange_height + $wire_guide_height]);
            }
        }
    }
    translate([0, 0, $height - $wire_guide_height - $led_height - 2]) cylinder(h = $led_height + 2, d = snugly($led_diameter));
    translate([-snugly($flange_diameter)/4 * 3, -snugly($flange_diameter)/4 * 3, $height - $wire_guide_height])
        cube([2 * snugly($flange_diameter), 2 * snugly($flange_diameter), $wire_guide_height]);
}

module base(rows, columns) {
    cube([extent(rows), extent(columns), $height]);
}

module wire_channel(i) {
    translate([$gutter + i * $distance + snugly($flange_diameter)/2, 0, $height - $wire_guide_height])
        cube([snugly($lead_diameter), extent($columns), snugly($lead_diameter)]);
    translate([$gutter + i * $distance + snugly($flange_diameter)/2, $gutter, $height - $wire_guide_height])
        cube([snugly($lead_diameter), ($columns - 1) * $distance, $wire_guide_height]);
}

module lead_channel(j) {
    translate([$gutter,
               $gutter + j * $distance + snugly($flange_diameter)/2 - ($flange_diameter - $flange_flat_diameter) - snugly($lead_diameter),
               $height - $wire_guide_height])
        cube([extent($rows), snugly($lead_diameter), $wire_guide_height]);
}

module guide(rows, columns) {
    union() {
        difference() {
            base(rows, columns);
            for (i = [0:rows - 1])
                for (j = [0:columns - 1])
                    translate([$gutter + i * $distance, $gutter + j * $distance, 0])
                        hole();

            for (i = [0:rows - 1])
                wire_channel(i);
            for (j = [0:columns - 1])
                lead_channel(j);
        }
    }
}

guide($rows, $columns);

// vim:set sts=4 sw=4 ai et:
