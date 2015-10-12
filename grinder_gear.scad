// include const used in this project
include <const.scad>

// include from MCAD
include <involute_gears.scad>

module grinder_gear(core_width = 4.64,
                    core_diameter = 6.0,
                    teeth = 57,
                    c_pitch = 400)
{

     difference() {
          gear(number_of_teeth=teeth,
               circular_pitch=c_pitch,
               diametral_pitch=20,
               pressure_angle=10,
               clearance = 0.2,
               gear_thickness=3,
               rim_thickness=6,
               rim_width=10,
               hub_thickness=3,
               hub_diameter=15,
               bore_diameter=0,
               circles=4,
               backlash=0,
               twist=0,
               involute_facets=10
               );

          translate([0, 0, -1]) {
               linear_extrude(6) {
                    rotate([0, 0, 45]) {
                         intersection() {
                              circle(0.5*core_diameter);
                              square([4.54, 10], center=true);
                         }
                    }
               }
          }
          rotate([0, 0, 45]) {
               lock_width = 3.5;
               lock_depth = 4.5;
               dist = 9 + lock_width/2;
               translate([dist, 0, 0])
                    cube([lock_width, lock_depth, 10], center=true);
               translate([-dist, 0, 0])
                    cube([lock_width, lock_depth, 10], center=true);
          }
     }

}
