// include const used in this project
include <const.scad>

module _round_cube(x, y, z, r=2) {
     union() {
          translate([r, 0, 0])
               cube([x-2*r, y, z]);
          translate([0, r, 0])
               cube([x, y-2*r, z]);
          translate([r, r, 0])
               cylinder(z, r, r);
          translate([x-r, r, 0])
               cylinder(z, r, r);
          translate([r, y-r, 0])
               cylinder(z, r, r);
          translate([x-r, y-r, 0])
               cylinder(z, r, r);
     }
}

module _round_square(x, y, r=2) {
     union() {
          translate([r, 0, 0])
               square([x-2*r, y]);
          translate([0, r, 0])
               square([x, y-2*r]);
          translate([r, r, 0])
               circle(r);
          translate([x-r, r, 0])
               circle(r);
          translate([r, y-r, 0])
               circle(r);
          translate([x-r, y-r, 0])
               circle(r);
     }
}

module _screw_base(h=1.68*beam_size, 
                   w=h+7, 
                   d=1.5*h, 
                   link_size=5, 
                   bolt_diameter = 3,
                   nut=true)
{
     bolt_radius = bolt_diameter/2;
     translate([0, -d, h]) {     
          rotate([-90, 0, 0]) {
               difference() {
                    union() {
                         _round_cube(w, h, d);
                         hull() {
                              corner = 0.01;
                              translate([w - corner*link_size, 0, -2*link_size - (1-corner)*link_size])
                                   cube([corner*link_size, h, d + 2*link_size + (1-corner)*link_size]);

                              //cube([0.25*link_size, h, 2*link_size + 1.5*h + (1-0.25)*link_size]);

                              translate([w - 3*link_size, 0, 0])
                                   cube([link_size, h, link_size]);                             
                         }
                    }
                    translate([0, link_size, -2*link_size-1])
                         cube([w + 1, h - 2*link_size, 2*link_size+1]);

                    translate([h/2, h/2, -1]) {
                         cylinder(1.5*h + 2, bolt_radius, bolt_radius);
                         if(nut) {
                              cylinder(h=3, r=7/2, $fn=6);
                         }
                         else {
                              sphere(d=5.3+1);
                         }
                    }
               }
          }
     }

}

module servo_base(diameter = 70, // 76
                  // lower_diameter = 77, // 76
                  gap = 30,
                  beam_size = 10,
                  servo_base_height = 26,
                  // screw base
                  joint_height = 1.72*10,     // 1.72*beam_size
                  joint_width = 1.72*10 + 7,  // joint_height + 7
                  joint_depth = 2*10,         // 2*beam_size
     )
{
     up = 22;
     translate([-((servo_depth + 2*beam_size)/2 - diameter/2 - joint_width), 
                0,
                - beam_size + servo_base_height])
     difference() {
          union() {

               difference() {
                    hull() {
                         translate([0, 0, up + beam_size/2])
                              cube([servo_depth + 2*beam_size, servo_width, beam_size/2]);
                         translate([0, servo_width, up + beam_size - servo_base_height])
                              cube([servo_depth + 2*beam_size, beam_size, servo_base_height - beam_size]);
                    }
                    translate([beam_size, -1, 0])
                         cube([servo_depth, 2*beam_size + 1.4, 10*beam_size]);

                    translate([beam_size, 2*beam_size - 1, up])
                         cube([servo_depth, 2*beam_size, beam_size+1]);

               }

               translate([0, servo_width, beam_size - servo_base_height]) {
                    comp_y = - servo_width;
                    comp_z = - beam_size + servo_base_height;
                    hull() {
                         translate([0, beam_size/2, up - beam_size/2]) 
                              cube([servo_depth + 2*beam_size, beam_size, servo_base_height - beam_size]);

                         /* rectangle base */
                         /* translate([0, 2*beam_size, 0]) */
                         /*      cube([servo_depth + 2*beam_size, gap - 2*beam_size, beam_size+5]); */
                         /* end rectangle base */

                         translate([(servo_depth + 2*beam_size)/2, diameter/2 + gap, 0])
                              cylinder(beam_size, diameter/2 + beam_size, diameter/2 + beam_size);

                    }
               } 

               hull() {
                    translate([0, servo_width, up + beam_size - servo_base_height])
                         cube([servo_depth + 2*beam_size, beam_size, servo_base_height - beam_size]);
                    translate([0, servo_width + beam_size/2, up - servo_base_height + beam_size/2])
                         cube([servo_depth + 2*beam_size, beam_size, servo_base_height - beam_size]);
               }

               /* extend base */
               /* translate([(servo_depth + 2*beam_size)/2, */
               /*            diameter/2 + gap + servo_width + 0.5*joint_depth - beam_size, */
               /*            beam_size - servo_base_height - beam_size]) { */
               /*      difference() { */
               /*           rotate_extrude(convexity=5) { */
               /*                translate([diameter/2, 0, 0]) */
               /*                     _round_square(beam_size, beam_size+5); */
               /*           } */
               /*           translate([0, 0, -1]) */
               /*                cylinder(beam_size + 1, lower_diameter/2, lower_diameter/2); */
               /*      } */
               /* } */
               /* end extend base */

               /* screw base */
               translate([(servo_depth + 2*beam_size)/2 - diameter/2 - joint_width, 
                          diameter/2 + gap + servo_width + 0.5*joint_depth, 
                          beam_size - servo_base_height]) {

                    _screw_base(h=joint_height, w=joint_width, d=joint_depth);
                    translate([2*joint_width + diameter, 0, joint_height])
                         rotate([0, 180, 0])
                         _screw_base(h=joint_height, w=joint_width, d=joint_depth);
          
               }
               /* end screw base */

          }

          translate([(servo_depth + 2*beam_size)/2, servo_width + diameter/2 + gap, beam_size - servo_base_height - 1]) {
               cylinder(beam_size + 1, diameter/2, diameter/2);
               translate([0, 0, beam_size])
                    cylinder(3*beam_size, diameter/2, 1.4*diameter/2);
          }
          translate([-diameter/2,  diameter/2 + gap + servo_width -2, -diameter/2])
               cube([2*diameter, diameter, diameter]);

     }
}

module lock(diameter = 70, // 76
            // lower_diameter = 77, // 76
            beam_size = 10,
            // screw base
            joint_height = 1.72*10,     // 1.72*beam_size
            joint_width = 1.72*10 + 7,  // joint_height + 7
            joint_depth = 2*10,         // 2*beam_size
     ) 
{

     difference() {
          translate([0, 2, 0]) {
               difference() {
                    union() {
                         rotate_extrude(convexity=5) {
                              translate([diameter/2, 0, 0])
                                   _round_square(beam_size, joint_height);
                         }
                         translate([-joint_width-diameter/2,
                                    0.5 * joint_depth, 
                                    0]) {
                              _screw_base(h=joint_height, w=joint_width, d=joint_depth, nut=false);
                              translate([2*joint_width + diameter, 0, 0])
                                   mirror([1, 0, 0])
                                   _screw_base(h=joint_height, w=joint_width, d=joint_depth, nut=false);
                         }
                         cylinder(beam_size, diameter/2 + beam_size, diameter/2 + beam_size);
                    }
                    translate([0, 0, -1])
                         cylinder(beam_size + 2, diameter/2, diameter/2);
                    translate([0, 0, beam_size])
                         cylinder(3*beam_size, diameter/2, 1.4*diameter/2);
               }
          }
          translate([-diameter, 0, -1])
               cube([2*diameter, diameter, diameter]);
     }
}

diameter = 70;
joint_width = 1.72*10 + 7;
gap = 30;

servo_base();
translate([(diameter/2 + joint_width),
           diameter/2 + gap + servo_width + 3,
           0])
rotate([0, 0, 180])
lock();
