// include const used in this project
include <const.scad>

// include from MCAD
include <involute_gears.scad>

module servo_gear(gear_height = 11,
                  teeth = 12,
                  c_pitch = 400)
{

     difference() {
          gear(number_of_teeth=teeth,
               circular_pitch=c_pitch,
               diametral_pitch=100,
               pressure_angle=5,
               clearance = 0.2,
               gear_thickness=gear_height,
               rim_thickness=gear_height,
               rim_width=10,
               hub_thickness=3,
               hub_diameter=3,
               bore_diameter=0,
               involute_facets=10
               );


          translate([0, 0, -1]) {
               gear(number_of_teeth=25,
                    circular_pitch=39,
                    diametral_pitch=40,
                    pressure_angle=36,
                    clearance = 0.2,
                    gear_thickness=3,
                    rim_thickness=servo_spline_height+1,
                    rim_width=10,
                    hub_thickness=servo_spline_height+1,
                    hub_diameter=0,
                    bore_diameter=0,
                    circles=0,
                    backlash=0,
                    twist=0,
                    involute_facets=10
                    );
          }
          cylinder(gear_height+1, 2.5/2, 2.5/2);

          translate([0, 0, servo_spline_height+1.5]) {
               cylinder(gear_height+1, bolt_head_diameter/2, bolt_head_diameter/2+5);
          }
     }
}
