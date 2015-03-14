
$rows = 2;
$columns = 2;
$height = 8.5;
$distance = 15;
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
function snugly(diameter) = diameter / cos(180 / fragments(diameter)) + 2 * $snug_clearance;
function fragments(diameter) = $fn > 0.0 ? max(3.0, $fn) : ceil(max(min(360.0 / $fa, diameter * PI / $fs), 5));
