

$fs = 1;
$fa = 0.1;

include <config.scad>;

$gap_multiplier = 2.75;

difference() {
	cube([$distance - snugly($lead_diameter), $distance - snugly($lead_diameter), extent($rows)]);
	cylinder(h = extent($rows), d = $gap_multiplier * $flange_diameter);
	translate([$distance - snugly($lead_diameter), 0, 0]) cylinder(h = extent($rows), d = $gap_multiplier * $flange_diameter);
	translate([0, $distance - snugly($lead_diameter), 0]) cylinder(h = extent($rows), d = $gap_multiplier * $flange_diameter);
	translate([$distance - snugly($lead_diameter), $distance - snugly($lead_diameter)]) cylinder(h = extent($rows), d = $gap_multiplier * $flange_diameter);

}
