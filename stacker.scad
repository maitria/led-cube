
$fs = 1;
$fa = 0.1;

include <config.scad>;

$extra = 4;

difference() {
	cube([extent($rows) + 2 * $extra, $height + $distance - $wire_guide_height, 6]);
	translate([0, $height - $wire_guide_height, 0]) cube([extent($rows) - $gutter, 6, 6]);
}
