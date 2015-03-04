
$fs = 0.25;
$fa = 1;

$rows = 2;
$columns = 2;
$height = 8.5;
$distance = 16;
$gutter = 8;

$led_diameter = 3;
$led_height = 5;
$flange_height = 1;
$flange_diameter = 3.5;
$flange_flat_diameter = 3.4;
$snug_clearance = 0.2;
$lead_diameter = 0.5;

$wire_guide_distance = 5.5;
$wire_guide_height = 2.5;

function extent(holes) = (holes - 1) * $distance + 2 * $gutter;
function fragments(diameter) = $fn > 0.0 ? max(3.0, $fn) : ceil(max(min(360.0 / $fa, diameter * PI / $fs), 5));
function snugly(diameter) = diameter / cos(180 / fragments(diameter)) + 2 * $snug_clearance;

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

module tool(rows, columns) {
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
}

tool($rows, $columns);

// vim:set sts=4 sw=4 ai et:
