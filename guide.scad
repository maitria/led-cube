
$fs = 0.25;
$fa = 1;

$rows = 2;
$columns = 2;
$height = 6;
$distance = 16;
$gutter = 10;

$led_diameter = 3;
$led_height = 5;
$flange_height = 1;
$flange_diameter = 3.5;
$flange_flat_diameter = 3.4;
$snug_clearance = 0.2;
$lead_diameter = 0.5;


function width(holes) = (holes - 1) * $distance + 2 * $gutter;

function fragments(diameter) = $fn > 0.0 ? max(3.0, $fn) : ceil(max(min(360.0 / $fa, diameter * PI / $fs), 5));
function snugly(diameter) = diameter / cos(180 / fragments(diameter)) + 2 * $snug_clearance;

echo(3 * PI / $fs);
echo(360.0 / $fa);

module hole() {
    translate([0, 0, $height - $flange_height]) {
        difference() {
            cylinder(h = $flange_height, d = snugly($flange_diameter));
            translate([-snugly($flange_diameter)/2,
                       snugly($flange_diameter)/2 - ($flange_diameter - $flange_flat_diameter),
                       0]) {
                cube([$flange_diameter, $flange_diameter - $led_diameter, $flange_height]);
            }
        }
    }
    translate([0, 0, $height - $led_height - 2]) {
        cylinder(h = $led_height + 2, d = snugly($led_diameter));
    }
}

module base(rows, columns) {
    difference() {
        cube([width(rows), width(columns), $height]);
        for (n = [0:1]) {
            translate([n * ((rows - 1) * $distance + 2 * $gutter), -1, $height]) {
                rotate([-90, 0, 0]) {
                    cylinder(h = width(columns) + 2, r = $height/2);
                }
            }
            translate([0, n * ((columns - 1) * $distance + 2 * $gutter), $height]) {
                rotate([0, 90, 0]) {
                    cylinder(h = width(rows) + 2, r = $height/2);
                }
            }
        }
    }
}

module tool(rows, columns) {
    difference() {
        base(rows, columns);
        for (i = [0:rows - 1]) {
            for (j = [0:columns - 1]) {
                translate([$gutter + i * $distance, $gutter + j * $distance, 0]) {
                        hole();
                }
            }
        }
        for (i = [0:rows - 1]) {
            translate([$gutter + i * $distance + $flange_diameter / 2, 0, $height - $lead_diameter]) {
                    cube([$lead_diameter + 2 * $snug_clearance, width(columns), $lead_diameter]);
            }
        }
    }
}

tool($rows, $columns);

// vim:set sts=4 sw=4 ai et:
