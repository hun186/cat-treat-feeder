/*
  Cat treat squeeze feeder V1 — 155 mm PP spoon adapter
  2026-10-27 • experimental 3D print prototype • units: millimeters

  Quick commands:
    openscad -o feeder_body.stl   -D 'part="body"'         cat_treat_feeder_v1.scad
    openscad -o squeeze_slider.stl -D 'part="slider_print"' cat_treat_feeder_v1.scad
  part: "assembly", "body", "body_side_print", "slider", "slider_print", "clip_coupon_print", "spoon_demo"

  Important: dimensions of the actual 15.5 cm spoon HANDLE are not yet known.
  `spoon_slot_width`/`spoon_mouth_width` are prototype estimates; test before use.
  Printed plastic must NOT contact food or cat mouths. Change spoon between cats.
*/

part = "assembly";
$fn=40;

// ===== User-adjustable dimensions =====
spoon_slot_width = 16.8;       // max cavity width between walls, mm
spoon_mouth_width = 10.6;      // snap-in opening, mm. Increase if spoon is wider
spoon_slot_height = 2.8;      // space between small retaining lip and plate, mm
spoon_clip_length = 12.0;
compression_gap = 2.0;         // empty space between packet bed and slider, mm
slider_clearance = 0.6;        // per side, mm
pouch_max_width = 29.5;       // width between packet side guides, mm

// ===== Main holder dimensions =====
length = 141;
base_halfwidth = 19;
plate_z0 = 6.5;
plate_thickness = 3.2;
plate_top = plate_z0 + plate_thickness;
wall_top = 14.0;
side_outer_width = 19.0;
wall_inner_y = pouch_max_width / 2;

// rounded 2D centered at y=0
module rounded_strip2d(L,W,r=2) {
    hull() for(x=[r,L-r],y=[-W/2+r,W/2-r]) translate([x,y]) circle(r=r);
}

module body() {
    union() {
        // Main packet-supporting surface (one continuous plate).
        translate([0,0,plate_z0])
            linear_extrude(height=plate_thickness)
                rounded_strip2d(length,base_halfwidth*2,2.0);
        // Two pouch edge guards, leaving a wide open center for the tube.
        for (side=[-1,1])
            translate([7,side*(wall_inner_y+(side_outer_width-wall_inner_y)/2),plate_top])
                cube([121,side_outer_width-wall_inner_y,wall_top-plate_top]);
        // Small front stops on the OUTSIDE only: avoid blocking cat-tube mouth.
        for (side=[-1,1])
            translate([137.5,side*17.5,16.5])
                cube([6.0,3.0,14.0],center=true);
        // Two underside snap clips for a disposable PP spoon stem.
        // Hooks attach below plate; no part of the printed body touches food.
        for (cx=[69,116]) spoon_clip(cx);
    }
}

module spoon_clip(cx) {
    clip_outer_half = spoon_slot_width/2 + 2.35;
    clip_inner_half = spoon_slot_width/2;
    mouth_half = spoon_mouth_width/2;
    lip_top = plate_z0 - spoon_slot_height; // under-plate vertical clearance
    translate([cx,0,0]) {
        for(side=[-1,1]) {
            // Side walls, vertical spring fingers.
            translate([0,side*(clip_inner_half+1.175),(2.0+plate_z0)/2])
                cube([spoon_clip_length,2.35,plate_z0-2.0],center=true);
            // Retaining tabs: narrower than handle channel; slightly tapered tips.
            // Two ramped lips facilitate press-fitting the spoon stem from below.
            hull() {
                translate([1.2,side*(mouth_half+0.5),lip_top-0.65])
                    cube([spoon_clip_length-2.4,1.0,0.6],center=true);
                translate([1.2,side*(clip_inner_half),lip_top+0.1])
                    cube([spoon_clip_length-2.4,1.0,0.7],center=true);
            }
        }
    }
}

// A captured U-shaped sliding squeegee. Insert from the rear of the main holder.
// Thin hooks at the feet keep the slider on the bed but avoid underside spoon clips.
module slider() {
    // Nominal envelope: 47.6 mm wide, 25.5 high. Slider travels along x.
    slider_x = 9;
    inner_y = base_halfwidth + slider_clearance;
    out_y = inner_y + 3.4;
    squeeze_z = plate_top + compression_gap;
    union() {
        // Thumb bridge and grip. It spans all the way across packet for pressure.
        translate([0,0,20.8]) cube([slider_x,2*out_y,5.4],center=true);
        // Broad, round-ended lower push bar across the pouch width.
        translate([0,0,(squeeze_z+21.0)/2]) cube([slider_x,2*(wall_inner_y-0.6),21.0-squeeze_z],center=true);
        // Two slim vertical side members
        for(side=[-1,1]) {
            translate([0,side*(inner_y+1.7),13.0])
                cube([slider_x,3.4,16.5],center=true);
            // Captured under-plate feet: they never touch the spoon handle clips.
            translate([0,side*(base_halfwidth-1.2),5.1])
                cube([slider_x,5.5,2.2],center=true);
        }
        // Round thumb tab: easier for a child to push with 1-2 fingers.
        translate([-1.8,0,25.0])
            cube([12.5,17,4],center=true);
    }
}

// Approximate spoon envelope — visual guide ONLY, NOT for printing or feeding.
module spoon_demo() {
    // The handle will lie between x~37 and 141; bowl x~142..192.
    color([0.91,0.95,0.99,0.6]) {
        hull() {
            translate([48,0,4.5]) cylinder(h=1.7,r=6.1,center=true);
            translate([140,0,4.5]) cylinder(h=1.7,r=4.1,center=true);
        }
        // Oval bowl reference footprint 43 wide x 50 long, very shallow.
        translate([169,0,4]) scale([25,21.5,2.3]) sphere(1,$fn=40);
    }
}

module pouch_demo() {
    color([0.99,0.75,0.31,0.56]) {
        hull() {
            translate([15,0,12.8]) cube([5,25,2.7],center=true);
            translate([125,0,12.8]) cube([6,25,2.7],center=true);
            translate([153,0,13]) cube([3,10,1.4],center=true);
        }
    }
}

// Print a small test coupon BEFORE committing to the full-sized holder.
module clip_coupon() {
    translate([0,0,plate_z0])
        linear_extrude(height=plate_thickness)
            rounded_strip2d(23,base_halfwidth*2,2);
    spoon_clip(11.5);
}
module clip_coupon_print() {
    translate([0,0,plate_top]) rotate([180,0,0]) clip_coupon();
}

// Render-position helpers: spread parts into valid printing orientations.
module body_side_print() {
    // Rotate so body's -Y outer edge is at build plate (along the long x-axis).
    // y_old -> z_new; z_old -> -y_new. Add translation so nothing is below z=0.
    translate([0,23.5,19]) rotate([90,0,0]) body();
}
module slider_print() {
    // x_old -> z_new; z_old -> -x_new. Entire ring lies flat on slicer bed.
    translate([27,0,8.05]) rotate([0,-90,0]) slider();
}

if(part=="body") body();
else if(part=="body_side_print") body_side_print();
else if(part=="slider") slider();
else if(part=="slider_print") slider_print();
else if(part=="spoon_demo") spoon_demo();
else if(part=="clip_coupon_print") clip_coupon_print();
else if(part=="underside_preview") {
    rotate([180,0,0]) {
        color("#74a5b9") body();
        translate([32,0,0]) color("#f7b15e") slider();
        spoon_demo();
    }
}
else {
    color("#74a5b9") body();
    translate([32,0,0]) color("#f7b15e") slider();
    spoon_demo();
    pouch_demo();
}
