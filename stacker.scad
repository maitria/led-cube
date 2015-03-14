
$fs = 1;
$fa = 0.1;

include <config.scad>;

$extra = 12;
$thickness = 6;
$arm_width = 6;
$gap_width = snugly($lead_diameter);

module guide_notch() {
    scale([1,0.5,1])
        difference() {
            cube([$arm_width, 2 * $arm_width + 0.4, $thickness]);
            translate([$arm_width, 0, 0]) cylinder(r = $arm_width, h = $thickness);
            translate([$arm_width, 2 * $arm_width + 2 * $gap_width, 0]) cylinder(r = $arm_width, h = $thickness);
        }
}

difference() {
    cube([($rows - 1) * $distance + 2 * $extra, 2 * $arm_width + $distance + $gap_width, $thickness]);

    translate([$extra - $arm_width, $arm_width, 0]) cube([($rows - 1) * $distance + ($extra - $arm_width), $gap_width, $thickness]);
    translate([$extra - $arm_width, $arm_width + $distance, 0]) cube([($rows - 1) * $distance + ($extra - $arm_width), $gap_width, $thickness]);

    translate([0, $arm_width/2, 0]) guide_notch();
    translate([0, $arm_width/2 + $distance, 0]) guide_notch();

    translate([$extra - $arm_width, 0, 0]) cube([3, 2, $thickness]);
    translate([$extra - $arm_width, $distance + 2 * $arm_width + $gap_width - 2, 0]) cube([3, 3, $thickness]);
}
