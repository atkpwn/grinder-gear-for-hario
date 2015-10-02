include <grinder_gear.scad>
include <servo_gear.scad>

grinder_gear();

translate([77, 0, 0]) {
     rotate([0, 0, 360/12/2])
          servo_gear();
}
