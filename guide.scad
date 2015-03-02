
$fs = 0.25;
$fa = 1;

$rows = 2;
$columns = 2;
$height = 6;
$distance = 16;
$gutter = 8;

$led_diameter = 3;
$led_height = 5;
$flange_height = 1;
$flange_diameter = 3.5;
$flange_flat_diameter = 3.4;
$snug_clearance = 0.2;
$lead_diameter = 0.5;

$wire_guide_percent = 0.7;
$wire_guide_height = 2.5;
$wire_guide_width = 1.5;

function width(holes) = (holes - 1) * $distance + 2 * $gutter;

function fragments(diameter) = $fn > 0.0 ? max(3.0, $fn) : ceil(max(min(360.0 / $fa, diameter * PI / $fs), 5));
function snugly(diameter) = diameter / cos(180 / fragments(diameter)) + 2 * $snug_clearance;

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
    cube([width(rows), width(columns), $height]);
}

module wire_guide(length) {
    union() {
        translate([-snugly($lead_diameter)/2 - $wire_guide_width/2, 0, 0]) {
            cube([$wire_guide_width, length, $wire_guide_height]);
        }
        translate([snugly($lead_diameter)/2 + $wire_guide_width/2, 0, 0]) {
            cube([$wire_guide_width, length, $wire_guide_height]);
        }
    }
}

function edge_wire_guide_width() = (($gutter - snugly($flange_diameter)/2) * $wire_guide_percent) / 2;

module tool(rows, columns) {
    difference() {
        union() {
            base(rows, columns);
            for(i = [0:rows - 1]) {
                for (j = [0:columns - 2]) {
                    translate([$gutter + i * $distance + snugly($flange_diameter)/2,
                               $gutter + j * $distance + snugly($flange_diameter)/2 + (1.0 - $wire_guide_percent) / 2 * ($distance - $flange_diameter),
                               $height]) {
                        wire_guide($wire_guide_percent * ($distance - $flange_diameter));
                    }
                }
            }
            for (i = [0:rows - 1]) {
                translate([$gutter + i * $distance + snugly($flange_diameter)/2, 0, $height]) {
                    wire_guide(edge_wire_guide_width());
                }
                translate([$gutter + i * $distance + snugly($flange_diameter)/2, width($columns) - edge_wire_guide_width(), $height]) {
                    wire_guide(edge_wire_guide_width());
                }
            }
        }
        for (i = [0:rows - 1]) {
            for (j = [0:columns - 1]) {
                translate([$gutter + i * $distance, $gutter + j * $distance, 0]) {
                    hole();
                }
            }
        }
    }
}

tool($rows, $columns);

// vim:set sts=4 sw=4 ai et:
